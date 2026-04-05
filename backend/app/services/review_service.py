from __future__ import annotations

from datetime import datetime, timezone

from app.models.review import ReviewTask
from app.repositories.review_repository import ReviewRepository


class ReviewService:
    def __init__(self, review_repository: ReviewRepository) -> None:
        self.review_repository = review_repository

    def get_today_reviews(self) -> list[ReviewTask]:
        return self.review_repository.list_due(datetime.now(timezone.utc).isoformat())

    def complete_review(self, review_task_id: str) -> ReviewTask:
        review_task = self.review_repository.complete(review_task_id)
        if review_task is None:
            raise ValueError("review_task_not_found")
        return review_task
