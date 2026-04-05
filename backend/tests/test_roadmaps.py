def _create_learning_goal(client) -> str:
    response = client.post(
        "/api/v1/learning-goals",
        json={
            "topic": "算法基础",
            "target_outcome": "能够解释常见算法思想",
            "current_level": "beginner",
            "study_pace": "steady",
            "evaluation_preference": False,
        },
    )
    assert response.status_code == 201
    return response.json()["id"]


def test_generate_roadmap_from_learning_goal(client) -> None:
    learning_goal_id = _create_learning_goal(client)

    response = client.post(
        "/api/v1/roadmaps/generate",
        json={"learning_goal_id": learning_goal_id},
    )

    assert response.status_code == 201
    body = response.json()
    assert body["status"] == "draft"
    assert len(body["stages"]) >= 1


def test_confirm_roadmap_marks_it_active(client) -> None:
    learning_goal_id = _create_learning_goal(client)
    generated = client.post(
        "/api/v1/roadmaps/generate",
        json={"learning_goal_id": learning_goal_id},
    )
    assert generated.status_code == 201
    roadmap_id = generated.json()["id"]

    response = client.post(f"/api/v1/roadmaps/{roadmap_id}/confirm")

    assert response.status_code == 200
    assert response.json()["status"] == "active"
