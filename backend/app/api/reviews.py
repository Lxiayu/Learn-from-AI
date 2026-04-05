from fastapi import APIRouter, HTTPException, Request

from app.repositories.review_repository import ReviewRepository
from app.schemas.review import (
    ReviewCompleteRequest,
    ReviewCompleteResponse,
    ReviewItemResponse,
    ReviewListResponse,
)
from app.services.review_service import ReviewService

router = APIRouter(prefix="/reviews", tags=["reviews"])


@router.get("/today", response_model=ReviewListResponse)
def get_today_reviews(request: Request) -> ReviewListResponse:
    database_path = request.app.state.settings.database_path
    service = ReviewService(ReviewRepository(database_path))
    items = service.get_today_reviews()
    return ReviewListResponse(
        items=[
            ReviewItemResponse(
                id=item.id,
                prompt=item.prompt,
                due_at=item.due_at,
                status=item.status,
            )
            for item in items
        ]
    )


@router.post("/{review_task_id}/complete", response_model=ReviewCompleteResponse)
def complete_review(
    review_task_id: str,
    payload: ReviewCompleteRequest,
    request: Request,
) -> ReviewCompleteResponse:
    _ = payload.result
    database_path = request.app.state.settings.database_path
    service = ReviewService(ReviewRepository(database_path))
    try:
        review_task = service.complete_review(review_task_id)
    except ValueError as exc:
        raise HTTPException(status_code=404, detail=str(exc)) from exc
    return ReviewCompleteResponse(id=review_task.id, status=review_task.status)
