"""
Wraps Docling to turn an uploaded PDF/DOCX into Markdown with LaTeX
math, and to extract real figures (diagrams, graphs, scanned shapes)
as actual image files rather than just flagging that they exist —
those get uploaded (see db.py's upload_extracted_image) and referenced
via diagram_type='image' so a real textbook figure is preserved
instead of silently dropped or re-drawn incorrectly.

NOTE on API stability: this uses Docling's documented top-level
pattern (DocumentConverter().convert(...).document.export_to_markdown()),
which has been the stable headline API across recent Docling releases.
Picture extraction uses PictureItem.get_image(doc), Docling's own
documented figure-export pattern — but both this and the
`has_undescribed_pictures`/`caption_text` attribute names are more
likely to have shifted between versions than the top-level convert/
export calls. If either throws an AttributeError after `pip install`,
run `dir(result.document)` and `dir(picture)` on an actual converted
document to confirm the current shape and adjust.
"""

from __future__ import annotations
import tempfile
from dataclasses import dataclass, field
from pathlib import Path
from docling.document_converter import DocumentConverter
from docling_core.types.doc import PictureItem

_converter = DocumentConverter()


@dataclass
class ExtractedImage:
    local_path: Path
    caption: str | None = None


@dataclass
class ParseResult:
    markdown: str
    has_undescribed_pictures: bool
    page_count: int
    extracted_images: list[ExtractedImage] = field(default_factory=list)


def parse_document(file_path: str) -> ParseResult:
    result = _converter.convert(file_path)
    doc = result.document

    markdown = doc.export_to_markdown()

    pictures = getattr(doc, "pictures", None) or []
    # A picture Docling extracted but couldn't caption/describe is a
    # signal the page has a diagram/graph worth routing through the
    # vision-model fallback rather than trusting the text extraction
    # alone for that region.
    has_undescribed_pictures = any(
        not getattr(p, "caption_text", None) and not getattr(p, "annotations", None)
        for p in pictures
    )

    extracted_images: list[ExtractedImage] = []
    for i, picture in enumerate(pictures):
        if not isinstance(picture, PictureItem):
            continue
        try:
            pil_image = picture.get_image(doc)
            if pil_image is None:
                continue
            tmp = tempfile.NamedTemporaryFile(delete=False, suffix=f"-fig{i}.png")
            pil_image.save(tmp.name, format="PNG")
            caption = getattr(picture, "caption_text", None)
            extracted_images.append(ExtractedImage(local_path=Path(tmp.name), caption=caption))
        except Exception:
            # A single figure failing to extract shouldn't fail the
            # whole parse — the text extraction still proceeds, this
            # figure is just skipped (has_undescribed_pictures above
            # still flags that the source had unhandled visual content).
            continue

    page_count = len(getattr(doc, "pages", None) or []) or 1

    return ParseResult(
        markdown=markdown,
        has_undescribed_pictures=has_undescribed_pictures,
        page_count=page_count,
        extracted_images=extracted_images,
    )
