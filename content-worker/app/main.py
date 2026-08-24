from __future__ import annotations
import logging
from fastapi import FastAPI, BackgroundTasks, Header, HTTPException
from .config import settings
from . import db
from .parser import parse_document
from .generator import generate_content, GenerationError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("content-worker")

app = FastAPI(title="Mathora Content Worker")


@app.get("/health")
def health():
    return {"status": "ok"}


def _run_pipeline(upload_id: str) -> None:
    try:
        upload = db.get_upload(upload_id)
        if not upload:
            logger.error("Upload %s not found", upload_id)
            return

        db.update_upload_status(upload_id, "parsing")
        local_path = db.download_upload_file(upload["storage_path"])
        try:
            parsed = parse_document(str(local_path))
        finally:
            local_path.unlink(missing_ok=True)

        if parsed.has_undescribed_pictures and not parsed.extracted_images:
            # Docling flagged a picture it couldn't caption but also
            # couldn't extract as an image (get_image() returned None
            # or raised) — genuinely lost content, not just unlabeled.
            # There's still no vision-model fallback to re-describe it
            # from the raw page; see README's known-limitations section.
            logger.warning(
                "Upload %s has undescribed, unextracted pictures — diagram/graph content "
                "on those pages may be missing entirely from the generated content.",
                upload_id,
            )

        image_urls: list[str] = []
        for i, image in enumerate(parsed.extracted_images):
            try:
                image_urls.append(db.upload_extracted_image(upload_id, image.local_path, i))
            except Exception:
                logger.exception("Failed to upload extracted image %d for upload %s", i, upload_id)
            finally:
                image.local_path.unlink(missing_ok=True)

        db.update_upload_status(upload_id, "generating")
        result = generate_content(parsed.markdown, upload["requested_question_count"])

        if not result.questions and not result.worked_examples:
            db.update_upload_status(
                upload_id, "failed", "The model returned no questions or worked examples for this document."
            )
            return

        db.insert_generated_content(upload_id, upload["topic_id"], result, extracted_image_urls=image_urls)
        logger.info(
            "Upload %s ready for review: %d questions, %d worked examples",
            upload_id,
            len(result.questions),
            len(result.worked_examples),
        )
    except GenerationError as e:
        logger.exception("Generation failed for upload %s", upload_id)
        db.update_upload_status(upload_id, "failed", str(e))
    except Exception as e:  # noqa: BLE001 — this is a background job's top-level boundary; any failure must land in content_uploads, not vanish into a log line no one is watching.
        logger.exception("Unhandled error processing upload %s", upload_id)
        db.update_upload_status(upload_id, "failed", f"Unexpected error: {e}")


@app.post("/process/{upload_id}")
def process(upload_id: str, background_tasks: BackgroundTasks, x_worker_secret: str = Header(default="")):
    if x_worker_secret != settings.worker_shared_secret:
        raise HTTPException(status_code=401, detail="unauthorized")

    # Returns immediately; the actual parse+generate work (which can
    # take anywhere from seconds to a couple minutes depending on
    # document length) happens after the response, and progress is
    # tracked via content_uploads.status rather than this request
    # blocking on it.
    background_tasks.add_task(_run_pipeline, upload_id)
    return {"status": "accepted", "upload_id": upload_id}
