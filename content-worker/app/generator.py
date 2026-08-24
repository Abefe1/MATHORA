"""
Takes already-parsed Markdown/LaTeX (never a raw PDF/image — that's
the whole point of parsing first, see parser.py and the top-level
README) and asks a text LLM to generate questions + worked examples in
the exact JSON shape schema.py/mathora_schema.sql expect.

Uses an OpenAI-compatible client pointed at LLM_BASE_URL, so swapping
providers (SiliconFlow, OpenRouter, anything else that speaks the
OpenAI chat-completions format) is an env var change, not a code
change.
"""

from __future__ import annotations
import json
from openai import OpenAI
from pydantic import ValidationError
from .config import settings
from .schema import GenerationResult

_client = OpenAI(base_url=settings.llm_base_url, api_key=settings.llm_api_key)

SYSTEM_PROMPT = """You are an expert Nigerian secondary school mathematics teacher \
writing WAEC/BECE-aligned exam-preparation content.

Given a chapter of extracted textbook/worksheet text (already converted to \
Markdown with LaTeX math), generate multiple-choice questions and worked \
examples for it.

Rules:
- Every equation, fraction, or symbol MUST be valid LaTeX wrapped in $...$ \
(inline) or $$...$$ (block) delimiters — this is rendered with KaTeX on the \
student's screen, so it must be syntactically valid LaTeX, not plain text \
approximations like "x^2" outside math delimiters.
- Exactly one of option_a..option_d must be correct; correct_letter must \
match it.
- explanation must show the actual working, not just restate the answer.
- exam_shortcut is optional but should be a genuine WAEC/BECE-style \
technique (e.g. sum/product of roots) when one applies — leave it "" if none.
- difficulty is 1 (easiest) to 5 (hardest), calibrated to a WAEC SS2/SS3 \
candidate.
- Base every question strictly on the provided text. Do not invent topics \
the text doesn't cover.

For each worked_example:
- solution_steps must be genuinely step-by-step — at least 3 separate steps, \
each one small, self-contained working (not the whole solution in one \
paragraph, and not so fine-grained that a step does nothing). A student \
should be able to follow each step in isolation and see exactly one thing \
happen (one substitution, one simplification, one rule applied).
- real_life_context: reframe the SAME problem inside a concrete Nigerian \
real-world scenario WHENEVER the topic realistically supports one — e.g. \
Sets/Venn Diagrams -> market survey of which stalls sell rice vs beans; \
Simple Interest/Arithmetic of Finance -> a real bank/cooperative savings \
scenario; Mensuration/Volume -> a water tank or classroom's dimensions; \
Statistics -> class test scores or household sizes on a street; Bearings \
-> a trip between two named towns. Leave it "" (do not force one) for \
topics with no natural real-world framing (e.g. simplifying an algebraic \
fraction, proving an identity, pure logic/set notation).
- diagram_type + diagram_data: set a diagram_type OTHER than "none" whenever \
the topic is visual (geometry, trigonometry, coordinate graphs, sets, \
statistics charts, number lines) — do not force one onto purely algebraic \
topics. diagram_data's shape depends on diagram_type, exactly:
  - "number_line": {"min": number, "max": number, "step": number, "points": \
[{"value": number, "label": string}]}
  - "venn_diagram": {"setA": {"label": string}, "setB": {"label": string}, \
"setC": {"label": string} (omit if only 2 sets), "universalLabel": string}
  - "coordinate_plane": {"xRange": [min, max], "yRange": [min, max], \
"points": [{"x": number, "y": number, "label": string}], "lines": \
[{"from": {"x": number, "y": number}, "to": {"x": number, "y": number}, \
"label": string}]}
  - "triangle": {"vertices": [{"label": string, "x": number, "y": number}, \
... exactly 3], "sideLabels": [{"from": string, "to": string, "label": \
string}], "angleLabels": [{"vertex": string, "label": string}], \
"rightAngleAt": string (vertex label, omit if not right-angled)}
  - "circle": {"radiusLabel": string, "centerLabel": string, "points": \
[{"label": string, "angleDegrees": number}], "highlightSector": \
{"startAngle": number, "endAngle": number, "label": string}, "chord": \
{"fromAngle": number, "toAngle": number, "label": string}} (all keys optional)
  - "unit_circle": {"angleDegrees": number, "showSine": boolean, \
"showCosine": boolean, "showTangent": boolean}
  - "bar_chart": {"categories": [string, ...], "values": [number, ...], \
"yLabel": string}
  - "pie_chart": {"slices": [{"label": string, "value": number}, ...]}
  - Never output diagram_type "image" — that value is reserved for figures \
extracted directly from the source document and is assigned outside this \
generation step, not by you.

Respond with ONLY a JSON object of this exact shape (no prose, no markdown \
fences):
{
  "questions": [
    {
      "question_text": string,
      "question_latex": string,
      "option_a": string, "option_b": string, "option_c": string, "option_d": string,
      "correct_letter": "A" | "B" | "C" | "D",
      "difficulty": integer 1-5,
      "exam_type": "WAEC" | "BECE" | "JAMB" | "NECO" | "GENERAL",
      "explanation": string,
      "exam_shortcut": string,
      "diagram_type": string,
      "diagram_data": object
    }
  ],
  "worked_examples": [
    {
      "title": string,
      "problem_statement": string,
      "solution_steps": [string, string, string, ...],
      "exam_shortcut": string,
      "common_trap_warning": string,
      "real_life_context": string,
      "diagram_type": string,
      "diagram_data": object
    }
  ]
}"""


class GenerationError(Exception):
    pass


def generate_content(markdown_text: str, question_count: int) -> GenerationResult:
    user_prompt = (
        f"Generate {question_count} multiple-choice questions and 1-2 worked "
        f"examples from this text:\n\n{markdown_text}"
    )

    response = _client.chat.completions.create(
        model=settings.llm_model,
        response_format={"type": "json_object"},
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_prompt},
        ],
    )

    raw = response.choices[0].message.content
    if not raw:
        raise GenerationError("LLM returned an empty response")

    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError as e:
        raise GenerationError(f"LLM did not return valid JSON: {e}") from e

    try:
        return GenerationResult.model_validate(parsed)
    except ValidationError as e:
        # Surfaced into content_uploads.error_message so an admin can
        # see exactly what the model got wrong, rather than a silent
        # failure — reviewing prompt quality over time depends on this.
        raise GenerationError(f"LLM output didn't match the expected schema: {e}") from e
