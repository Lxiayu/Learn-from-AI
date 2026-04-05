from fastapi import FastAPI

from app.api.router import api_router
from app.config import settings


def create_app() -> FastAPI:
    app = FastAPI(title=settings.app_name)
    app.include_router(api_router, prefix=settings.api_prefix)
    return app


app = create_app()
