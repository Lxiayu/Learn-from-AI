from pathlib import Path


class Settings:
    """Minimal runtime settings for the local MVP backend."""

    app_name: str = "LearnAI Local Backend"
    api_prefix: str = "/api/v1"
    database_url: str = f"sqlite:///{Path(__file__).resolve().parents[1] / 'learnai.db'}"


settings = Settings()
