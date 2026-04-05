from __future__ import annotations

from dataclasses import dataclass

from app.models.base import BaseRecord


@dataclass(frozen=True)
class ReviewTask(BaseRecord):
    session_id: str
    prompt: str
    due_at: str
