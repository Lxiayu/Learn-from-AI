def _complete_session(client) -> str:
    learning_goal = client.post(
        "/api/v1/learning-goals",
        json={
            "topic": "数据库",
            "target_outcome": "能够解释索引与事务的基本作用",
            "current_level": "beginner",
            "study_pace": "steady",
            "evaluation_preference": False,
        },
    )
    assert learning_goal.status_code == 201

    generated = client.post(
        "/api/v1/roadmaps/generate",
        json={"learning_goal_id": learning_goal.json()["id"]},
    )
    assert generated.status_code == 201

    confirmed = client.post(f"/api/v1/roadmaps/{generated.json()['id']}/confirm")
    assert confirmed.status_code == 200

    current = client.get("/api/v1/sessions/current")
    assert current.status_code == 200

    completed = client.post(f"/api/v1/sessions/{current.json()['id']}/complete")
    assert completed.status_code == 200
    return completed.json()["generated_review_tasks"][0]["id"]


def test_get_todays_reviews_returns_due_tasks(client) -> None:
    _complete_session(client)

    response = client.get("/api/v1/reviews/today")

    assert response.status_code == 200
    assert isinstance(response.json()["items"], list)
    assert len(response.json()["items"]) >= 1


def test_complete_review_updates_status(client) -> None:
    review_task_id = _complete_session(client)

    response = client.post(f"/api/v1/reviews/{review_task_id}/complete", json={"result": "good"})

    assert response.status_code == 200
    assert response.json()["status"] == "completed"
