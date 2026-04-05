from __future__ import annotations

from pydantic import BaseModel


class ReviewItemResponse(BaseModel):
    id: str
    prompt: str
    due_at: str
    status: str


class ReviewListResponse(BaseModel):
    items: list[ReviewItemResponse]


class ReviewCompleteRequest(BaseModel):
    result: str


class ReviewCompleteResponse(BaseModel):
    id: str
    status: str
