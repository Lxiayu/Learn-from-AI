from dataclasses import dataclass

from app.models.base import BaseRecord


@dataclass(frozen=True)
class LearningGoal(BaseRecord):
    topic: str
    target_outcome: str
    current_level: str
    study_pace: str
    evaluation_preference: bool
