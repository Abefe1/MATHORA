"""
Pydantic models for the LLM's generated output. Field names and shapes
match mathora_schema.sql's `questions` and `worked_examples` tables
EXACTLY (see mathora_schema.sql's own comment: the schema was
reconciled to the app's flattened option_a..option_d/correct_letter
shape, not a normalized options table) — this is what lets db.py
insert the LLM's JSON output directly with no reshaping layer.
"""

from __future__ import annotations
from typing import Literal
from pydantic import BaseModel, Field, field_validator

Letter = Literal["A", "B", "C", "D"]
ExamType = Literal["WAEC", "BECE", "JAMB", "NECO", "GENERAL"]


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

    @field_validator("question_text", "option_a", "option_b", "option_c", "option_d", "explanation")
    @classmethod
    def not_blank(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("must not be blank")
        return v


class GeneratedWorkedExample(BaseModel):
    title: str
    problem_statement: str
    solution_steps: list[str] = Field(min_length=1)
    exam_shortcut: str = ""
    common_trap_warning: str = ""


class GenerationResult(BaseModel):
    questions: list[GeneratedQuestion] = []
    worked_examples: list[GeneratedWorkedExample] = []
