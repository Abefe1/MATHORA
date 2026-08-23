"""
Wraps Docling to turn an uploaded PDF/DOCX into Markdown with LaTeX
math, and to flag pages that are mostly a diagram/graph Docling
couldn't convert to text (those get routed to the vision-model
fallback in generator.py instead of being force-fed as-is).

NOTE on API stability: this uses Docling's documented top-level
pattern (DocumentConverter().convert(...).document.export_to_markdown()),
which has been the stable headline API across recent Docling releases.
The `has_undescribed_pictures` heuristic below touches a more specific
attribute (`document.pictures`) that's more likely to have shifted
between versions than the top-level convert/export calls — if this
throws an AttributeError after `pip install`, run
`python -c "from docling.document_converter import DocumentConverter; import inspect; print(inspect.signature(DocumentConverter.convert))"`
and `dir(result.document)` to confirm the current shape and adjust.
"""

from __future__ import annotations
from dataclasses import dataclass
from docling.document_converter import DocumentConverter

_converter = DocumentConverter()


@dataclass
class ParseResult:
    markdown: str
    has_undescribed_pictures: bool
    page_count: int


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

    page_count = len(getattr(doc, "pages", None) or []) or 1

    return ParseResult(
        markdown=markdown,
        has_undescribed_pictures=has_undescribed_pictures,
        page_count=page_count,
    )
