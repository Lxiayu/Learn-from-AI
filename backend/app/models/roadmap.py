from __future__ import annotations

from dataclasses import dataclass

from app.models.base import BaseRecord


@dataclass(frozen=True)
class RoadmapStage:
    id: str
    roadmap_id: str
    order_index: int
    title: str
    objective: str
    completion_criteria: str
    status: str
    created_at: str
    updated_at: str


@dataclass(frozen=True)
class Roadmap(BaseRecord):
    learning_goal_id: str
    title: str
    summary: str
    current_stage_index: int
    total_stage_count: int
    estimated_duration_minutes: int
    stages: list[RoadmapStage]
