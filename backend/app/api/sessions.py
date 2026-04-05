from dataclasses import asdict

from fastapi import APIRouter, HTTPException, Request

from app.providers.mock_provider import MockRoadmapProvider
from app.repositories.roadmap_repository import RoadmapRepository
from app.repositories.review_repository import ReviewRepository
from app.repositories.session_repository import SessionRepository
from app.schemas.session import (
    CompleteSessionResponse,
    CurrentSessionResponse,
    ExplainAgainResponse,
    HintResponse,
    SessionAnswerRequest,
    SessionAnswerResponse,
)
from app.services.session_service import SessionService

router = APIRouter(prefix="/sessions", tags=["sessions"])


@router.get("/current", response_model=CurrentSessionResponse)
def get_current_session(request: Request) -> CurrentSessionResponse:
    database_path = request.app.state.settings.database_path
    service = SessionService(
        roadmap_repository=RoadmapRepository(database_path),
        session_repository=SessionRepository(database_path),
        review_repository=ReviewRepository(database_path),
        provider=MockRoadmapProvider(),
    )
    try:
        session = service.get_or_create_current_session()
    except ValueError as exc:
        raise HTTPException(status_code=404, detail=str(exc)) from exc

    return CurrentSessionResponse(**{**session.to_dict(), "task_card": asdict(session.task_card)})


@router.post("/{session_id}/answer", response_model=SessionAnswerResponse)
def answer_session(
    session_id: str,
    payload: SessionAnswerRequest,
    request: Request,
) -> SessionAnswerResponse:
    database_path = request.app.state.settings.database_path
    service = SessionService(
        roadmap_repository=RoadmapRepository(database_path),
        session_repository=SessionRepository(database_path),
        review_repository=ReviewRepository(database_path),
        provider=MockRoadmapProvider(),
    )
    try:
        result = service.answer(session_id, payload.answer)
    except ValueError as exc:
        raise HTTPException(status_code=404, detail=str(exc)) from exc
    return SessionAnswerResponse(**result)


@router.post("/{session_id}/hint", response_model=HintResponse)
def hint_for_session(session_id: str, request: Request) -> HintResponse:
    database_path = request.app.state.settings.database_path
    service = SessionService(
        roadmap_repository=RoadmapRepository(database_path),
        session_repository=SessionRepository(database_path),
        review_repository=ReviewRepository(database_path),
        provider=MockRoadmapProvider(),
    )
    try:
        hint = service.hint(session_id)
    except ValueError as exc:
        raise HTTPException(status_code=404, detail=str(exc)) from exc
    return HintResponse(hint=hint)


@router.post("/{session_id}/explain-again", response_model=ExplainAgainResponse)
def explain_again(session_id: str, request: Request) -> ExplainAgainResponse:
    database_path = request.app.state.settings.database_path
    service = SessionService(
        roadmap_repository=RoadmapRepository(database_path),
        session_repository=SessionRepository(database_path),
        review_repository=ReviewRepository(database_path),
        provider=MockRoadmapProvider(),
    )
    try:
        explanation = service.explain_again(session_id)
    except ValueError as exc:
        raise HTTPException(status_code=404, detail=str(exc)) from exc
    return ExplainAgainResponse(explanation=explanation)


@router.post("/{session_id}/complete", response_model=CompleteSessionResponse)
def complete_session(session_id: str, request: Request) -> CompleteSessionResponse:
    database_path = request.app.state.settings.database_path
    service = SessionService(
        roadmap_repository=RoadmapRepository(database_path),
        session_repository=SessionRepository(database_path),
        review_repository=ReviewRepository(database_path),
        provider=MockRoadmapProvider(),
    )
    try:
        review_tasks = service.complete(session_id)
    except ValueError as exc:
        raise HTTPException(status_code=404, detail=str(exc)) from exc
    return CompleteSessionResponse(
        generated_review_tasks=[{"id": task.id, "prompt": task.prompt} for task in review_tasks]
    )
