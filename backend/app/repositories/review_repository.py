from __future__ import annotations

from pathlib import Path

from app.db import get_connection
from app.models.review import ReviewTask


class ReviewRepository:
    def __init__(self, database_path: Path) -> None:
        self.database_path = database_path

    def ensure_tables(self) -> None:
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                CREATE TABLE IF NOT EXISTS review_tasks (
                    id TEXT PRIMARY KEY,
                    session_id TEXT NOT NULL,
                    prompt TEXT NOT NULL,
                    due_at TEXT NOT NULL,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL,
                    version INTEGER NOT NULL,
                    status TEXT NOT NULL,
                    source TEXT NOT NULL,
                    sync_status TEXT NOT NULL
                )
                """
            )
            connection.commit()

    def create_many(self, tasks: list[ReviewTask]) -> list[ReviewTask]:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            connection.executemany(
                """
                INSERT INTO review_tasks (
                    id,
                    session_id,
                    prompt,
                    due_at,
                    created_at,
                    updated_at,
                    version,
                    status,
                    source,
                    sync_status
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                [
                    (
                        task.id,
                        task.session_id,
                        task.prompt,
                        task.due_at,
                        task.created_at,
                        task.updated_at,
                        task.version,
                        task.status,
                        task.source,
                        task.sync_status,
                    )
                    for task in tasks
                ],
            )
            connection.commit()
        return tasks

    def list_due(self, now: str) -> list[ReviewTask]:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            rows = connection.execute(
                """
                SELECT * FROM review_tasks
                WHERE due_at <= ? AND status = 'pending'
                ORDER BY due_at ASC
                """,
                (now,),
            ).fetchall()

        return [
            ReviewTask(
                id=row["id"],
                session_id=row["session_id"],
                prompt=row["prompt"],
                due_at=row["due_at"],
                created_at=row["created_at"],
                updated_at=row["updated_at"],
                version=row["version"],
                status=row["status"],
                source=row["source"],
                sync_status=row["sync_status"],
            )
            for row in rows
        ]

    def complete(self, review_task_id: str) -> ReviewTask | None:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                UPDATE review_tasks
                SET status = 'completed'
                WHERE id = ?
                """,
                (review_task_id,),
            )
            connection.commit()
            row = connection.execute(
                "SELECT * FROM review_tasks WHERE id = ?",
                (review_task_id,),
            ).fetchone()

        if row is None:
            return None

        return ReviewTask(
            id=row["id"],
            session_id=row["session_id"],
            prompt=row["prompt"],
            due_at=row["due_at"],
            created_at=row["created_at"],
            updated_at=row["updated_at"],
            version=row["version"],
            status=row["status"],
            source=row["source"],
            sync_status=row["sync_status"],
        )
