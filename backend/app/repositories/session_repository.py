from __future__ import annotations

from pathlib import Path

from app.db import get_connection
from app.models.session import LearningSession, TaskCard


class SessionRepository:
    def __init__(self, database_path: Path) -> None:
        self.database_path = database_path

    def ensure_tables(self) -> None:
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                CREATE TABLE IF NOT EXISTS learning_sessions (
                    id TEXT PRIMARY KEY,
                    roadmap_id TEXT NOT NULL,
                    current_stage_id TEXT NOT NULL,
                    phase TEXT NOT NULL,
                    task_topic TEXT NOT NULL,
                    task_objective TEXT NOT NULL,
                    task_question_focus TEXT NOT NULL,
                    task_success_criteria TEXT NOT NULL,
                    task_estimated_minutes INTEGER NOT NULL,
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

    def get_current(self) -> LearningSession | None:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            row = connection.execute(
                """
                SELECT * FROM learning_sessions
                WHERE status = 'in_progress'
                ORDER BY created_at DESC
                LIMIT 1
                """
            ).fetchone()

        if row is None:
            return None

        return LearningSession(
            id=row["id"],
            roadmap_id=row["roadmap_id"],
            current_stage_id=row["current_stage_id"],
            phase=row["phase"],
            task_card=TaskCard(
                topic=row["task_topic"],
                objective=row["task_objective"],
                question_focus=row["task_question_focus"],
                success_criteria=row["task_success_criteria"],
                estimated_minutes=row["task_estimated_minutes"],
            ),
            created_at=row["created_at"],
            updated_at=row["updated_at"],
            version=row["version"],
            status=row["status"],
            source=row["source"],
            sync_status=row["sync_status"],
        )

    def create(self, session: LearningSession) -> LearningSession:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                INSERT INTO learning_sessions (
                    id,
                    roadmap_id,
                    current_stage_id,
                    phase,
                    task_topic,
                    task_objective,
                    task_question_focus,
                    task_success_criteria,
                    task_estimated_minutes,
                    created_at,
                    updated_at,
                    version,
                    status,
                    source,
                    sync_status
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    session.id,
                    session.roadmap_id,
                    session.current_stage_id,
                    session.phase,
                    session.task_card.topic,
                    session.task_card.objective,
                    session.task_card.question_focus,
                    session.task_card.success_criteria,
                    session.task_card.estimated_minutes,
                    session.created_at,
                    session.updated_at,
                    session.version,
                    session.status,
                    session.source,
                    session.sync_status,
                ),
            )
            connection.commit()
        return session

    def get_by_id(self, session_id: str) -> LearningSession | None:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            row = connection.execute(
                "SELECT * FROM learning_sessions WHERE id = ?",
                (session_id,),
            ).fetchone()

        if row is None:
            return None

        return LearningSession(
            id=row["id"],
            roadmap_id=row["roadmap_id"],
            current_stage_id=row["current_stage_id"],
            phase=row["phase"],
            task_card=TaskCard(
                topic=row["task_topic"],
                objective=row["task_objective"],
                question_focus=row["task_question_focus"],
                success_criteria=row["task_success_criteria"],
                estimated_minutes=row["task_estimated_minutes"],
            ),
            created_at=row["created_at"],
            updated_at=row["updated_at"],
            version=row["version"],
            status=row["status"],
            source=row["source"],
            sync_status=row["sync_status"],
        )

    def update_phase(self, session_id: str, next_phase: str) -> LearningSession:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                UPDATE learning_sessions
                SET phase = ?
                WHERE id = ?
                """,
                (next_phase, session_id),
            )
            connection.commit()

        session = self.get_by_id(session_id)
        assert session is not None
        return session

    def complete(self, session_id: str) -> LearningSession:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                UPDATE learning_sessions
                SET status = 'completed'
                WHERE id = ?
                """,
                (session_id,),
            )
            connection.commit()

        session = self.get_by_id(session_id)
        assert session is not None
        return session
