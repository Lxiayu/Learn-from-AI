from datetime import datetime, timezone
from uuid import uuid4

from app.models.roadmap import Roadmap, RoadmapStage
from app.providers.base import RoadmapProvider
from app.repositories.learning_goal_repository import LearningGoalRepository
from app.repositories.roadmap_repository import RoadmapRepository


class RoadmapService:
    def __init__(
        self,
        learning_goal_repository: LearningGoalRepository,
        roadmap_repository: RoadmapRepository,
        provider: RoadmapProvider,
    ) -> None:
        self.learning_goal_repository = learning_goal_repository
        self.roadmap_repository = roadmap_repository
        self.provider = provider

    def generate(self, learning_goal_id: str) -> Roadmap:
        learning_goal = self.learning_goal_repository.get_by_id(learning_goal_id)
        if learning_goal is None:
            raise ValueError("learning_goal_not_found")

        now = datetime.now(timezone.utc).isoformat()
        provider_result = self.provider.generate_roadmap(
            topic=learning_goal.topic,
            target_outcome=learning_goal.target_outcome,
        )
        roadmap_id = str(uuid4())
        stage_payloads = provider_result["stages"]
        stages = [
            RoadmapStage(
                id=str(uuid4()),
                roadmap_id=roadmap_id,
                order_index=index,
                title=stage["title"],
                objective=stage["objective"],
                completion_criteria=stage["completion_criteria"],
                status="available" if index == 1 else "locked",
                created_at=now,
                updated_at=now,
            )
            for index, stage in enumerate(stage_payloads, start=1)
        ]
        roadmap = Roadmap(
            id=roadmap_id,
            learning_goal_id=learning_goal_id,
            title=str(provider_result["title"]),
            summary=str(provider_result["summary"]),
            current_stage_index=0,
            total_stage_count=len(stages),
            estimated_duration_minutes=int(provider_result["estimated_duration_minutes"]),
            created_at=now,
            updated_at=now,
            version=1,
            status="draft",
            source="local_api",
            sync_status="local_only",
            stages=stages,
        )
        return self.roadmap_repository.create(roadmap)

    def confirm(self, roadmap_id: str) -> Roadmap:
        roadmap = self.roadmap_repository.get_by_id(roadmap_id)
        if roadmap is None:
            raise ValueError("roadmap_not_found")
        return self.roadmap_repository.activate(roadmap_id)

    def get_current(self) -> Roadmap:
        roadmap = self.roadmap_repository.get_active_roadmap()
        if roadmap is None:
            raise ValueError("active_roadmap_not_found")
        return roadmap
