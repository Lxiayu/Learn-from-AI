from app.config import settings


def get_database_url() -> str:
    """Return the configured database URL for future repository setup."""

    return settings.database_url
