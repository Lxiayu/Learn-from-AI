from pathlib import Path

import pytest
from fastapi.testclient import TestClient

from app.main import create_app


@pytest.fixture()
def client(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> TestClient:
    database_file = tmp_path / "learnai-test.db"
    monkeypatch.setenv("LEARNAI_DATABASE_PATH", str(database_file))
    if database_file.exists():
        database_file.unlink()

    test_client = TestClient(create_app())
    yield test_client

    if database_file.exists():
        database_file.unlink()
