import os
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class Settings:
    """Minimal runtime settings for the local MVP backend."""

    app_name: str
    api_prefix: str
    database_path: Path
    allowed_origins: tuple[str, ...]

    @property
    def database_url(self) -> str:
        return f"sqlite:///{self.database_path}"


def get_settings() -> Settings:
    default_path = Path(__file__).resolve().parents[1] / "learnai.db"
    configured_path = Path(os.getenv("LEARNAI_DATABASE_PATH", default_path))
    return Settings(
        app_name="LearnAI Local Backend",
        api_prefix="/api/v1",
        database_path=configured_path,
        allowed_origins=(
            "http://localhost:5173",
            "http://127.0.0.1:5173",
            "http://localhost:3000",
            "http://127.0.0.1:3000",
        ),
    )
