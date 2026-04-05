from __future__ import annotations

from dataclasses import asdict, dataclass


@dataclass(frozen=True)
class BaseRecord:
    id: str
    created_at: str
    updated_at: str
    version: int
    status: str
    source: str
    sync_status: str

    def to_dict(self) -> dict[str, object]:
        return asdict(self)
