from __future__ import annotations

from typing import Protocol


class RoadmapProvider(Protocol):
    def generate_roadmap(self, *, topic: str, target_outcome: str) -> dict[str, object]:
        ...

    def generate_hint(self, *, topic: str, phase: str) -> str:
        ...

    def explain_again(self, *, topic: str, objective: str) -> str:
        ...
