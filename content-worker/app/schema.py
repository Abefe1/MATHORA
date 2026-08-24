"""
Pydantic models for the LLM's generated output. Field names and shapes
match mathora_schema.sql's `questions` and `worked_examples` tables
EXACTLY (see mathora_schema.sql's own comment: the schema was
reconciled to the app's flattened option_a..option_d/correct_letter
shape, not a normalized options table) — this is what lets db.py
insert the LLM's JSON output directly with no reshaping layer.
"""

from __future__ import annotations
from typing import Any, Literal
from pydantic import BaseModel, Field, field_validator

Letter = Literal["A", "B", "C", "D"]
ExamType = Literal["WAEC", "BECE", "JAMB", "NECO", "GENERAL"]

# Must match mathora_schema_diagrams_patch.sql's diagram_type enum and
# lib/diagramTypes.ts's DiagramType union EXACTLY — this is the
# three-way contract (DB enum / web renderer / this model) that lets a
# generated diagram_type actually render. 'image' is reserved for
# figures parser.py extracted from the source document (see db.py's
# upload_extracted_image) — the LLM is never asked to invent one of
# those; main.py assigns it directly when an extracted image exists
# for the topic being generated.
DiagramType = Literal[
    "none",
    "number_line",
    "venn_diagram",
    "coordinate_plane",
    "triangle",
    "circle",
    "unit_circle",
    "bar_chart",
    "pie_chart",
    "image",
]


class GeneratedQuestion(BaseModel):
    question_text: str
    question_latex: str = ""
    option_a: str
    option_b: str
    option_c: str
    option_d: str
    correct_letter: Letter
    difficulty: int = Field(ge=1, le=5, default=2)
    exam_type: ExamType = "GENERAL"
    explanation: str
    exam_shortcut: str = ""
    diagram_type: DiagramType = "none"
    diagram_data: dict[str, Any] = Field(default_factory=dict)

    @field_validator("question_text", "option_a", "option_b", "option_c", "option_d", "explanation")
    @classmethod
    def not_blank(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("must not be blank")
        return v


class GeneratedWorkedExample(BaseModel):
    title: str
    problem_statement: str
    solution_steps: list[str] = Field(min_length=3)  # genuinely step-by-step, not one paragraph
    exam_shortcut: str = ""
    common_trap_warning: str = ""
    # Populated "whenever the topic realistically supports one" per
    # the generator prompt — null/blank means the model judged this
    # problem doesn't naturally fit a real-world framing, not that it
    # was skipped.
    real_life_context: str = ""
    diagram_type: DiagramType = "none"
    diagram_data: dict[str, Any] = Field(default_factory=dict)


class GenerationResult(BaseModel):
    questions: list[GeneratedQuestion] = []
    worked_examples: list[GeneratedWorkedExample] = []
