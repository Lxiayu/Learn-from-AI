from __future__ import annotations

from datetime import datetime, timedelta, timezone
from uuid import uuid4

from app.models.review import ReviewTask
from app.providers.base import RoadmapProvider
from app.models.session import LearningSession, TaskCard
from app.repositories.roadmap_repository import RoadmapRepository
from app.repositories.review_repository import ReviewRepository
from app.repositories.session_repository import SessionRepository


class SessionService:
    PHASE_ORDER = ["explain", "example", "compare", "transfer"]

    def __init__(
        self,
        roadmap_repository: RoadmapRepository,
        session_repository: SessionRepository,
        review_repository: ReviewRepository,
        provider: RoadmapProvider,
    ) -> None:
        self.roadmap_repository = roadmap_repository
        self.session_repository = session_repository
        self.review_repository = review_repository
        self.provider = provider

    def get_or_create_current_session(self) -> LearningSession:
        existing = self.session_repository.get_current()
        if existing is not None:
            return existing

        roadmap = self.roadmap_repository.get_active_roadmap()
        if roadmap is None:
            raise ValueError("active_roadmap_not_found")

        active_stage = next(
            (stage for stage in roadmap.stages if stage.status == "active"),
            roadmap.stages[0],
        )
        now = datetime.now(timezone.utc).isoformat()
        session = LearningSession(
            id=str(uuid4()),
            roadmap_id=roadmap.id,
            current_stage_id=active_stage.id,
            phase="explain",
            task_card=TaskCard(
                topic=active_stage.title,
                objective=active_stage.objective,
                question_focus="先用自己的话解释这个知识点，再尝试举一个简单例子。",
                success_criteria=active_stage.completion_criteria,
                estimated_minutes=max(15, roadmap.estimated_duration_minutes // max(roadmap.total_stage_count, 1) // 4),
            ),
            created_at=now,
            updated_at=now,
            version=1,
            status="in_progress",
            source="local_api",
            sync_status="local_only",
        )
        return self.session_repository.create(session)

    def answer(self, session_id: str, answer: str) -> dict[str, object]:
        session = self.session_repository.get_by_id(session_id)
        if session is None:
            raise ValueError("session_not_found")

        current_index = self.PHASE_ORDER.index(session.phase)
        is_confident = len(answer.strip()) >= 8
        if is_confident and current_index < len(self.PHASE_ORDER) - 1:
            next_phase = self.PHASE_ORDER[current_index + 1]
            self.session_repository.update_phase(session_id, next_phase)
            return {
                "feedback": {
                    "type": "encourage",
                    "message": "回答抓住了关键点，我们继续往更深一层推进。",
                },
                "next_step": next_phase,
            }

        return {
            "feedback": {
                "type": "corrective" if not is_confident else "encourage",
                "message": "先把关键特征说清楚，我们再继续推进下一步。",
            },
            "next_step": session.phase,
        }

    def hint(self, session_id: str) -> str:
        session = self.session_repository.get_by_id(session_id)
        if session is None:
            raise ValueError("session_not_found")
        return self.provider.generate_hint(topic=session.task_card.topic, phase=session.phase)

    def explain_again(self, session_id: str) -> str:
        session = self.session_repository.get_by_id(session_id)
        if session is None:
            raise ValueError("session_not_found")
        return self.provider.explain_again(
            topic=session.task_card.topic,
            objective=session.task_card.objective,
        )

    def complete(self, session_id: str) -> list[ReviewTask]:
        session = self.session_repository.get_by_id(session_id)
        if session is None:
            raise ValueError("session_not_found")

        completed = self.session_repository.complete(session_id)
        now = datetime.now(timezone.utc)
        tasks = [
            ReviewTask(
                id=str(uuid4()),
                session_id=completed.id,
                prompt=f"复述 {completed.task_card.topic} 的核心概念并举一个例子",
                due_at=(now + timedelta(days=days)).isoformat(),
                created_at=now.isoformat(),
                updated_at=now.isoformat(),
                version=1,
                status="pending",
                source="local_api",
                sync_status="local_only",
            )
            for days in (0, 3)
        ]
        return self.review_repository.create_many(tasks)
