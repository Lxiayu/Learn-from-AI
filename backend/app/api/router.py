from fastapi import APIRouter

from app.api.health import router as health_router
from app.api.learning_goals import router as learning_goals_router
from app.api.reviews import router as reviews_router
from app.api.roadmaps import router as roadmaps_router
from app.api.sessions import router as sessions_router

api_router = APIRouter()
api_router.include_router(health_router)
api_router.include_router(learning_goals_router)
api_router.include_router(reviews_router)
api_router.include_router(roadmaps_router)
api_router.include_router(sessions_router)
