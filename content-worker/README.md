# Mathora Content Worker

Parses a teacher/admin-uploaded PDF or DOCX into Markdown+LaTeX
(Docling), then asks a text LLM to generate multiple-choice questions
and worked examples in the exact shape `mathora_schema.sql` expects,
written in as `status='draft'` for an admin to review before students
ever see them.

This is a **separate service**, not part of `mathora-web`, because
Docling pulls in OCR/layout models that don't run inside Next.js's
serverless functions (Vercel-style hosting doesn't run long-lived
Python processes). `mathora-web` calls this over HTTP.

## Pipeline

```
[Admin uploads PDF/DOCX in mathora-web]
        │  (stored in Supabase Storage's "content-uploads" bucket)
        ▼
[mathora-web: POST /api/content/ingest]
        │  creates a content_uploads row (status='pending')
        │  fires POST /process/{upload_id} at this service (async, doesn't wait)
        ▼
[content-worker: parser.py]  Docling → Markdown + LaTeX
        ▼
[content-worker: generator.py]  text LLM → structured JSON
        │  (schema.py validates it against mathora_schema.sql's exact shape)
        ▼
[content-worker: db.py]  writes questions/worked_examples as status='draft'
        ▼
[Admin reviews in mathora-web's /admin "Pending Review" tab, approves or rejects]
```

## Running locally

```bash
cd content-worker
python -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows
pip install -r requirements.txt
cp .env.example .env  # fill in real values
uvicorn app.main:app --reload --port 8787
```

`mathora-web`'s `.env.local` needs `CONTENT_WORKER_URL=http://localhost:8787`
and the same `WORKER_SHARED_SECRET` value during local development.

## Deploying

Any host that runs a long-lived Python process works — Railway,
Fly.io, Render, a small VM. Docling's model downloads mean the first
request after a cold start is slow; keep at least one instance warm if
your host scales to zero.

## Known limitations, stated rather than hidden

- **No vision-model fallback wired in yet.** `parser.py` flags when a
  document has pictures Docling couldn't caption (likely a diagram or
  graph), and `main.py` logs a warning, but nothing currently re-sends
  those pages through a vision-capable model (Qwen2.5-VL, etc.) to
  extract them. That's the next piece to add — `VISION_LLM_MODEL` in
  `.env.example` is a placeholder for it, unused today.
- **Docling's math/formula recognition isn't perfect**, especially on
  scanned/photographed pages vs. clean digital PDFs. This is exactly
  why generated content lands as `status='draft'` and goes through
  human review rather than publishing straight to students — treat
  this pipeline as a first-draft generator, not an autopilot.
- **Package versions in `requirements.txt` are loose (`>=`) pins**,
  written without the ability to verify current exact PyPI releases.
  Run `pip freeze > requirements.lock.txt` after your first successful
  install and use that for reproducible deploys.
- **`content_uploads.requested_question_count` caps at 50** per
  upload (see the schema patch's check constraint) — a deliberate
  cost/quality guardrail, not a technical limit. Raise it there if you
  need more.
