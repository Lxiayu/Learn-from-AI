from fastapi import APIRouter

from app.api.health import router as health_router
from app.api.learning_goals import router as learning_goals_router

api_router = APIRouter()
api_router.include_router(health_router)
api_router.include_router(learning_goals_router)
