from pathlib import Path

from app.db import get_connection
from app.models.learning_goal import LearningGoal


class LearningGoalRepository:
    def __init__(self, database_path: Path) -> None:
        self.database_path = database_path

    def ensure_tables(self) -> None:
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                CREATE TABLE IF NOT EXISTS learning_goals (
                    id TEXT PRIMARY KEY,
                    topic TEXT NOT NULL,
                    target_outcome TEXT NOT NULL,
                    current_level TEXT NOT NULL,
                    study_pace TEXT NOT NULL,
                    evaluation_preference INTEGER NOT NULL,
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

    def create(self, learning_goal: LearningGoal) -> LearningGoal:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                INSERT INTO learning_goals (
                    id,
                    topic,
                    target_outcome,
                    current_level,
                    study_pace,
                    evaluation_preference,
                    created_at,
                    updated_at,
                    version,
                    status,
                    source,
                    sync_status
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    learning_goal.id,
                    learning_goal.topic,
                    learning_goal.target_outcome,
                    learning_goal.current_level,
                    learning_goal.study_pace,
                    int(learning_goal.evaluation_preference),
                    learning_goal.created_at,
                    learning_goal.updated_at,
                    learning_goal.version,
                    learning_goal.status,
                    learning_goal.source,
                    learning_goal.sync_status,
                ),
            )
            connection.commit()

        return learning_goal
