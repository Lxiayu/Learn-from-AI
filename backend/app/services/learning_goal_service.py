from datetime import datetime, timezone
from uuid import uuid4

from app.models.learning_goal import LearningGoal
from app.repositories.learning_goal_repository import LearningGoalRepository
from app.schemas.learning_goal import LearningGoalCreate


class LearningGoalService:
    def __init__(self, repository: LearningGoalRepository) -> None:
        self.repository = repository

    def create_learning_goal(self, payload: LearningGoalCreate) -> LearningGoal:
        now = datetime.now(timezone.utc).isoformat()
        learning_goal = LearningGoal(
            id=str(uuid4()),
            topic=payload.topic,
            target_outcome=payload.target_outcome,
            current_level=payload.current_level,
            study_pace=payload.study_pace,
            evaluation_preference=payload.evaluation_preference,
            created_at=now,
            updated_at=now,
            version=1,
            status="draft",
            source="local_api",
            sync_status="local_only",
        )
        return self.repository.create(learning_goal)
