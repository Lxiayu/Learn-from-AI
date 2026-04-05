def test_create_learning_goal_persists_record(client) -> None:
    payload = {
        "topic": "数据结构",
        "target_outcome": "能够解释常见数据结构并完成中等题目",
        "current_level": "beginner",
        "study_pace": "steady",
        "evaluation_preference": False,
    }

    response = client.post("/api/v1/learning-goals", json=payload)

    assert response.status_code == 201
    body = response.json()
    assert body["topic"] == "数据结构"
    assert body["status"] == "draft"
