from __future__ import annotations

from dataclasses import dataclass

from app.models.base import BaseRecord


@dataclass(frozen=True)
class TaskCard:
    topic: str
    objective: str
    question_focus: str
    success_criteria: str
    estimated_minutes: int


@dataclass(frozen=True)
class LearningSession(BaseRecord):
    roadmap_id: str
    current_stage_id: str
    phase: str
    task_card: TaskCard
