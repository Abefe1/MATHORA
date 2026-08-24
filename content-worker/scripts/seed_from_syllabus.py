#!/usr/bin/env python3
"""
Runs Stage 2 for real: generates questions + worked examples for every
topic seeded by mathora_seed_topics_ss1_ss2_ss3.sql that doesn't
already have content, using content-worker's existing generator.py —
skipping parser.py/Docling entirely, because a topic's `description`
column is already clean syllabus text, not a file that needs parsing.

Needs a live Supabase project (with mathora_schema.sql +
mathora_schema_auth_patch.sql + mathora_schema_content_pipeline_patch.sql
+ mathora_schema_diagrams_patch.sql + mathora_schema_topics_term_patch.sql
+ mathora_seed_topics_ss1_ss2_ss3.sql already applied/run) and a real
LLM_API_KEY in .env — this script makes real, billed API calls. It
cannot be run inside the environment this was written in; there is no
network path to Supabase or an LLM provider from there.

Every generated item lands as status='draft', same review gate as the
file-upload path — nothing here publishes directly to students.

Usage:
  cd content-worker
  python -m scripts.seed_from_syllabus --subject Mathematics --dry-run
  python -m scripts.seed_from_syllabus --subject Mathematics
  python -m scripts.seed_from_syllabus --subject "Further Mathematics" --questions-per-topic 8
  python -m scripts.seed_from_syllabus --subject Mathematics --class-level SS1 --term 1
"""

from __future__ import annotations
import argparse
import sys
import time

from app import db
from app.generator import generate_content, GenerationError


def build_topic_prompt_text(topic: dict, subject: str) -> str:
    return (
        f"Subject: {subject}\n"
        f"Class: {topic['class_level']}, Term {topic['term']}\n"
        f"Topic: {topic['title']}\n"
        f"Syllabus scope for this topic (from the Lagos State Ministry of "
        f"Education scheme of work — treat this as the authoritative boundary "
        f"of what to cover, do not go beyond it): {topic['description']}"
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--subject", required=True, choices=["Mathematics", "Further Mathematics"])
    parser.add_argument("--class-level", choices=["SS1", "SS2", "SS3"], help="Restrict to one class level")
    parser.add_argument("--term", type=int, choices=[1, 2, 3], help="Restrict to one term")
    parser.add_argument("--questions-per-topic", type=int, default=6, help="Default 6 — keep modest per topic; this runs across ~60-70 topics per subject")
    parser.add_argument("--delay", type=float, default=2.0, help="Seconds to sleep between topics (rate-limit courtesy)")
    parser.add_argument("--dry-run", action="store_true", help="List what would be generated without calling the LLM or writing anything")
    parser.add_argument("--limit", type=int, help="Stop after this many topics (for a small test run)")
    args = parser.parse_args()

    topics = db.list_topics_for_subject(args.subject)
    if args.class_level:
        topics = [t for t in topics if t["class_level"] == args.class_level]
    if args.term:
        topics = [t for t in topics if t["term"] == args.term]

    to_process = [t for t in topics if not db.topic_has_generated_content(t["id"])]
    skipped = len(topics) - len(to_process)
    if args.limit:
        to_process = to_process[: args.limit]

    print(f"{len(topics)} topics matched, {skipped} already have content, {len(to_process)} to process.", file=sys.stderr)

    if args.dry_run:
        for t in to_process:
            print(f"  [DRY RUN] {t['class_level']} T{t['term']} — {t['title']}")
        return 0

    succeeded = 0
    failed = 0

    for i, topic in enumerate(to_process, start=1):
        label = f"{topic['class_level']} T{topic['term']} — {topic['title']}"
        print(f"[{i}/{len(to_process)}] {label} ...", file=sys.stderr)

        upload = db.create_syllabus_upload_placeholder(topic["id"], topic["title"], args.questions_per_topic)
        try:
            prompt_text = build_topic_prompt_text(topic, args.subject)
            result = generate_content(prompt_text, args.questions_per_topic)

            if not result.questions and not result.worked_examples:
                db.update_upload_status(upload["id"], "failed", "Model returned no questions or worked examples.")
                print(f"  -> FAILED (empty result)", file=sys.stderr)
                failed += 1
                continue

            db.insert_generated_content(upload["id"], topic["id"], result)
            print(f"  -> OK: {len(result.questions)} questions, {len(result.worked_examples)} worked examples", file=sys.stderr)
            succeeded += 1
        except GenerationError as e:
            db.update_upload_status(upload["id"], "failed", str(e))
            print(f"  -> FAILED: {e}", file=sys.stderr)
            failed += 1
        except Exception as e:  # noqa: BLE001 — same top-level boundary reasoning as main.py's _run_pipeline: one topic's unexpected failure must not kill the whole batch, and must land in content_uploads, not vanish.
            db.update_upload_status(upload["id"], "failed", f"Unexpected error: {e}")
            print(f"  -> FAILED (unexpected): {e}", file=sys.stderr)
            failed += 1

        if i < len(to_process):
            time.sleep(args.delay)

    print(f"\nDone. {succeeded} succeeded, {failed} failed, {skipped} already had content.", file=sys.stderr)
    print("Everything generated is status='draft' — review and approve in mathora-web's /admin Pending Review tab.", file=sys.stderr)
    return 1 if failed > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
