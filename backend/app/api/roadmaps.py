from dataclasses import asdict

from fastapi import APIRouter, HTTPException, Request, status

from app.providers.mock_provider import MockRoadmapProvider
from app.repositories.learning_goal_repository import LearningGoalRepository
from app.repositories.roadmap_repository import RoadmapRepository
from app.schemas.roadmap import RoadmapGenerateRequest, RoadmapResponse
from app.services.roadmap_service import RoadmapService

router = APIRouter(prefix="/roadmaps", tags=["roadmaps"])


def _service(request: Request) -> RoadmapService:
    database_path = request.app.state.settings.database_path
    return RoadmapService(
        learning_goal_repository=LearningGoalRepository(database_path),
        roadmap_repository=RoadmapRepository(database_path),
        provider=MockRoadmapProvider(),
    )


@router.post("/generate", response_model=RoadmapResponse, status_code=status.HTTP_201_CREATED)
def generate_roadmap(
    payload: RoadmapGenerateRequest,
    request: Request,
) -> RoadmapResponse:
    service = _service(request)
    try:
        roadmap = service.generate(payload.learning_goal_id)
    except ValueError as exc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(exc)) from exc

    return RoadmapResponse(
        **{**roadmap.to_dict(), "stages": [asdict(stage) for stage in roadmap.stages]}
    )


@router.post("/{roadmap_id}/confirm", response_model=RoadmapResponse)
def confirm_roadmap(roadmap_id: str, request: Request) -> RoadmapResponse:
    service = _service(request)
    try:
        roadmap = service.confirm(roadmap_id)
    except ValueError as exc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(exc)) from exc

    return RoadmapResponse(
        **{**roadmap.to_dict(), "stages": [asdict(stage) for stage in roadmap.stages]}
    )
