def _create_confirmed_roadmap(client) -> str:
    learning_goal = client.post(
        "/api/v1/learning-goals",
        json={
            "topic": "操作系统",
            "target_outcome": "能够解释进程、线程与调度的核心概念",
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
    return confirmed.json()["id"]


def test_get_current_session_returns_task_card(client) -> None:
    _create_confirmed_roadmap(client)

    response = client.get("/api/v1/sessions/current")

    assert response.status_code == 200
    body = response.json()
    assert body["task_card"]["topic"]
    assert body["task_card"]["success_criteria"]


def test_answer_advances_session_step(client) -> None:
    _create_confirmed_roadmap(client)
    current = client.get("/api/v1/sessions/current")
    assert current.status_code == 200
    session_id = current.json()["id"]

    response = client.post(
        f"/api/v1/sessions/{session_id}/answer",
        json={"answer": "栈是先进后出的线性结构。"},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["feedback"]["type"] in {"encourage", "corrective"}
    assert body["next_step"] in {"example", "compare", "transfer"}


def test_hint_returns_smaller_prompt(client) -> None:
    _create_confirmed_roadmap(client)
    current = client.get("/api/v1/sessions/current")
    session_id = current.json()["id"]

    response = client.post(f"/api/v1/sessions/{session_id}/hint")

    assert response.status_code == 200
    assert response.json()["hint"]


def test_explain_again_returns_reframed_explanation(client) -> None:
    _create_confirmed_roadmap(client)
    current = client.get("/api/v1/sessions/current")
    session_id = current.json()["id"]

    response = client.post(f"/api/v1/sessions/{session_id}/explain-again")

    assert response.status_code == 200
    assert response.json()["explanation"]


def test_complete_session_generates_review_tasks(client) -> None:
    _create_confirmed_roadmap(client)
    current = client.get("/api/v1/sessions/current")
    session_id = current.json()["id"]

    response = client.post(f"/api/v1/sessions/{session_id}/complete")

    assert response.status_code == 200
    assert len(response.json()["generated_review_tasks"]) >= 1
