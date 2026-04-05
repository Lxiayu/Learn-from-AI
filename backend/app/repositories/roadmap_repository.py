from __future__ import annotations

from pathlib import Path

from app.db import get_connection
from app.models.roadmap import Roadmap, RoadmapStage


class RoadmapRepository:
    def __init__(self, database_path: Path) -> None:
        self.database_path = database_path

    def ensure_tables(self) -> None:
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                CREATE TABLE IF NOT EXISTS roadmaps (
                    id TEXT PRIMARY KEY,
                    learning_goal_id TEXT NOT NULL,
                    title TEXT NOT NULL,
                    summary TEXT NOT NULL,
                    current_stage_index INTEGER NOT NULL,
                    total_stage_count INTEGER NOT NULL,
                    estimated_duration_minutes INTEGER NOT NULL,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL,
                    version INTEGER NOT NULL,
                    status TEXT NOT NULL,
                    source TEXT NOT NULL,
                    sync_status TEXT NOT NULL
                )
                """
            )
            connection.execute(
                """
                CREATE TABLE IF NOT EXISTS roadmap_stages (
                    id TEXT PRIMARY KEY,
                    roadmap_id TEXT NOT NULL,
                    order_index INTEGER NOT NULL,
                    title TEXT NOT NULL,
                    objective TEXT NOT NULL,
                    completion_criteria TEXT NOT NULL,
                    status TEXT NOT NULL,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL
                )
                """
            )
            connection.commit()

    def create(self, roadmap: Roadmap) -> Roadmap:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                INSERT INTO roadmaps (
                    id,
                    learning_goal_id,
                    title,
                    summary,
                    current_stage_index,
                    total_stage_count,
                    estimated_duration_minutes,
                    created_at,
                    updated_at,
                    version,
                    status,
                    source,
                    sync_status
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    roadmap.id,
                    roadmap.learning_goal_id,
                    roadmap.title,
                    roadmap.summary,
                    roadmap.current_stage_index,
                    roadmap.total_stage_count,
                    roadmap.estimated_duration_minutes,
                    roadmap.created_at,
                    roadmap.updated_at,
                    roadmap.version,
                    roadmap.status,
                    roadmap.source,
                    roadmap.sync_status,
                ),
            )
            connection.executemany(
                """
                INSERT INTO roadmap_stages (
                    id,
                    roadmap_id,
                    order_index,
                    title,
                    objective,
                    completion_criteria,
                    status,
                    created_at,
                    updated_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                [
                    (
                        stage.id,
                        stage.roadmap_id,
                        stage.order_index,
                        stage.title,
                        stage.objective,
                        stage.completion_criteria,
                        stage.status,
                        stage.created_at,
                        stage.updated_at,
                    )
                    for stage in roadmap.stages
                ],
            )
            connection.commit()

        return roadmap

    def get_by_id(self, roadmap_id: str) -> Roadmap | None:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            roadmap_row = connection.execute(
                "SELECT * FROM roadmaps WHERE id = ?",
                (roadmap_id,),
            ).fetchone()
            if roadmap_row is None:
                return None

            stage_rows = connection.execute(
                """
                SELECT * FROM roadmap_stages
                WHERE roadmap_id = ?
                ORDER BY order_index ASC
                """,
                (roadmap_id,),
            ).fetchall()

        stages = [
            RoadmapStage(
                id=row["id"],
                roadmap_id=row["roadmap_id"],
                order_index=row["order_index"],
                title=row["title"],
                objective=row["objective"],
                completion_criteria=row["completion_criteria"],
                status=row["status"],
                created_at=row["created_at"],
                updated_at=row["updated_at"],
            )
            for row in stage_rows
        ]
        return Roadmap(
            id=roadmap_row["id"],
            learning_goal_id=roadmap_row["learning_goal_id"],
            title=roadmap_row["title"],
            summary=roadmap_row["summary"],
            current_stage_index=roadmap_row["current_stage_index"],
            total_stage_count=roadmap_row["total_stage_count"],
            estimated_duration_minutes=roadmap_row["estimated_duration_minutes"],
            created_at=roadmap_row["created_at"],
            updated_at=roadmap_row["updated_at"],
            version=roadmap_row["version"],
            status=roadmap_row["status"],
            source=roadmap_row["source"],
            sync_status=roadmap_row["sync_status"],
            stages=stages,
        )

    def activate(self, roadmap_id: str) -> Roadmap:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            connection.execute(
                """
                UPDATE roadmaps
                SET status = ?, current_stage_index = ?, updated_at = updated_at
                WHERE id = ?
                """,
                ("active", 1, roadmap_id),
            )
            connection.execute(
                """
                UPDATE roadmap_stages
                SET status = CASE WHEN order_index = 1 THEN 'active' ELSE status END
                WHERE roadmap_id = ?
                """,
                (roadmap_id,),
            )
            connection.commit()

        roadmap = self.get_by_id(roadmap_id)
        assert roadmap is not None
        return roadmap

    def get_active_roadmap(self) -> Roadmap | None:
        self.ensure_tables()
        with get_connection(self.database_path) as connection:
            row = connection.execute(
                """
                SELECT id FROM roadmaps
                WHERE status = 'active'
                ORDER BY created_at DESC
                LIMIT 1
                """
            ).fetchone()

        if row is None:
            return None

        return self.get_by_id(row["id"])
