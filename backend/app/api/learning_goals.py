from fastapi import APIRouter, Request, status

from app.repositories.learning_goal_repository import LearningGoalRepository
from app.schemas.learning_goal import LearningGoalCreate, LearningGoalResponse
from app.services.learning_goal_service import LearningGoalService

router = APIRouter(prefix="/learning-goals", tags=["learning-goals"])


@router.post("", response_model=LearningGoalResponse, status_code=status.HTTP_201_CREATED)
def create_learning_goal(
    payload: LearningGoalCreate,
    request: Request,
) -> LearningGoalResponse:
    repository = LearningGoalRepository(request.app.state.settings.database_path)
    service = LearningGoalService(repository)
    learning_goal = service.create_learning_goal(payload)
    return LearningGoalResponse(**learning_goal.to_dict())
