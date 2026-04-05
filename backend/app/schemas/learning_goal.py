from pydantic import BaseModel


class LearningGoalCreate(BaseModel):
    topic: str
    target_outcome: str
    current_level: str
    study_pace: str
    evaluation_preference: bool = False


class LearningGoalResponse(LearningGoalCreate):
    id: str
    created_at: str
    updated_at: str
    version: int
    status: str
    source: str
    sync_status: str
