from __future__ import annotations

from pydantic import BaseModel


class RoadmapGenerateRequest(BaseModel):
    learning_goal_id: str


class RoadmapStageResponse(BaseModel):
    id: str
    roadmap_id: str
    order_index: int
    title: str
    objective: str
    completion_criteria: str
    status: str
    created_at: str
    updated_at: str


class RoadmapResponse(BaseModel):
    id: str
    learning_goal_id: str
    title: str
    summary: str
    current_stage_index: int
    total_stage_count: int
    estimated_duration_minutes: int
    version: int
    status: str
    source: str
    sync_status: str
    created_at: str
    updated_at: str
    stages: list[RoadmapStageResponse]
