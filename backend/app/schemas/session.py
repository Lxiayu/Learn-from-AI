from __future__ import annotations

from pydantic import BaseModel


class TaskCardResponse(BaseModel):
    topic: str
    objective: str
    question_focus: str
    success_criteria: str
    estimated_minutes: int


class CurrentSessionResponse(BaseModel):
    id: str
    roadmap_id: str
    current_stage_id: str
    phase: str
    version: int
    status: str
    source: str
    sync_status: str
    created_at: str
    updated_at: str
    task_card: TaskCardResponse


class SessionAnswerRequest(BaseModel):
    answer: str


class SessionAnswerResponse(BaseModel):
    feedback: dict[str, str]
    next_step: str


class HintResponse(BaseModel):
    hint: str


class ExplainAgainResponse(BaseModel):
    explanation: str


class CompleteSessionResponse(BaseModel):
    generated_review_tasks: list[dict[str, str]]
