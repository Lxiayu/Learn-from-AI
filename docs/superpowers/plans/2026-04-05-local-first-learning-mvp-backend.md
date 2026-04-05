# Local-First Learning MVP Backend Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first runnable local backend for LearnAI so the Flutter app can move from mock data to a real learning-loop MVP.

**Architecture:** Add a new `backend/` FastAPI service backed by SQLite and structured around clear domain boundaries: API routers, services, repositories, and AI provider abstractions. Keep the Flutter app on Riverpod, but replace mock-driven state with repository-backed state that talks to local HTTP endpoints while preserving local cache and future CloudBase migration boundaries.

**Tech Stack:** FastAPI, SQLAlchemy/SQLModel, SQLite, Pydantic, pytest, Flutter, Riverpod, Dio

---

## File Structure

### New backend files

- Create: `/Users/xia/program/Learn/backend/pyproject.toml`
- Create: `/Users/xia/program/Learn/backend/app/main.py`
- Create: `/Users/xia/program/Learn/backend/app/config.py`
- Create: `/Users/xia/program/Learn/backend/app/db.py`
- Create: `/Users/xia/program/Learn/backend/app/api/router.py`
- Create: `/Users/xia/program/Learn/backend/app/api/health.py`
- Create: `/Users/xia/program/Learn/backend/app/api/learning_goals.py`
- Create: `/Users/xia/program/Learn/backend/app/api/roadmaps.py`
- Create: `/Users/xia/program/Learn/backend/app/api/sessions.py`
- Create: `/Users/xia/program/Learn/backend/app/api/reviews.py`
- Create: `/Users/xia/program/Learn/backend/app/models/base.py`
- Create: `/Users/xia/program/Learn/backend/app/models/learning_goal.py`
- Create: `/Users/xia/program/Learn/backend/app/models/roadmap.py`
- Create: `/Users/xia/program/Learn/backend/app/models/session.py`
- Create: `/Users/xia/program/Learn/backend/app/models/review.py`
- Create: `/Users/xia/program/Learn/backend/app/schemas/learning_goal.py`
- Create: `/Users/xia/program/Learn/backend/app/schemas/roadmap.py`
- Create: `/Users/xia/program/Learn/backend/app/schemas/session.py`
- Create: `/Users/xia/program/Learn/backend/app/schemas/review.py`
- Create: `/Users/xia/program/Learn/backend/app/repositories/learning_goal_repository.py`
- Create: `/Users/xia/program/Learn/backend/app/repositories/roadmap_repository.py`
- Create: `/Users/xia/program/Learn/backend/app/repositories/session_repository.py`
- Create: `/Users/xia/program/Learn/backend/app/repositories/review_repository.py`
- Create: `/Users/xia/program/Learn/backend/app/services/learning_goal_service.py`
- Create: `/Users/xia/program/Learn/backend/app/services/roadmap_service.py`
- Create: `/Users/xia/program/Learn/backend/app/services/session_service.py`
- Create: `/Users/xia/program/Learn/backend/app/services/review_service.py`
- Create: `/Users/xia/program/Learn/backend/app/providers/base.py`
- Create: `/Users/xia/program/Learn/backend/app/providers/mock_provider.py`
- Create: `/Users/xia/program/Learn/backend/tests/conftest.py`
- Create: `/Users/xia/program/Learn/backend/tests/test_health.py`
- Create: `/Users/xia/program/Learn/backend/tests/test_learning_goals.py`
- Create: `/Users/xia/program/Learn/backend/tests/test_roadmaps.py`
- Create: `/Users/xia/program/Learn/backend/tests/test_sessions.py`
- Create: `/Users/xia/program/Learn/backend/tests/test_reviews.py`

### Flutter files likely to change

- Modify: `/Users/xia/program/Learn/flutter_app/pubspec.yaml`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/app/app.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/home/presentation/home_screen.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/roadmap/presentation/roadmap_screen.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/chat/presentation/chat_screen.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/review/presentation/review_screen.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/profile/presentation/profile_analytics_screen.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/core/network/api_client.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/core/config/app_env.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/data/*.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/domain/*.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/state/*.dart`
- Create: `/Users/xia/program/Learn/flutter_app/test/features/learning/*.dart`

---

### Task 1: Scaffold the local backend service

**Files:**
- Create: `/Users/xia/program/Learn/backend/pyproject.toml`
- Create: `/Users/xia/program/Learn/backend/app/main.py`
- Create: `/Users/xia/program/Learn/backend/app/config.py`
- Create: `/Users/xia/program/Learn/backend/app/db.py`
- Create: `/Users/xia/program/Learn/backend/app/api/router.py`
- Create: `/Users/xia/program/Learn/backend/app/api/health.py`
- Test: `/Users/xia/program/Learn/backend/tests/test_health.py`

- [ ] **Step 1: Write the failing health test**

```python
def test_health_endpoint_returns_ok(client):
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_health.py -v`
Expected: FAIL because backend package and app do not exist yet

- [ ] **Step 3: Create backend project scaffold**

Implement:
- `pyproject.toml` with FastAPI, SQLAlchemy/SQLModel, pytest, httpx
- `app.main:create_app`
- base config and SQLite URL
- DB session factory
- `/api/v1/health` router

- [ ] **Step 4: Run backend health test**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_health.py -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git -C /Users/xia/program/Learn add backend
git -C /Users/xia/program/Learn commit -m "feat: scaffold local FastAPI backend"
```

### Task 2: Add learning goal persistence and create endpoint

**Files:**
- Create: `/Users/xia/program/Learn/backend/app/models/base.py`
- Create: `/Users/xia/program/Learn/backend/app/models/learning_goal.py`
- Create: `/Users/xia/program/Learn/backend/app/schemas/learning_goal.py`
- Create: `/Users/xia/program/Learn/backend/app/repositories/learning_goal_repository.py`
- Create: `/Users/xia/program/Learn/backend/app/services/learning_goal_service.py`
- Create: `/Users/xia/program/Learn/backend/app/api/learning_goals.py`
- Test: `/Users/xia/program/Learn/backend/tests/test_learning_goals.py`

- [ ] **Step 1: Write failing create-learning-goal test**

```python
def test_create_learning_goal_persists_record(client):
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_learning_goals.py -v`
Expected: FAIL because route and model do not exist

- [ ] **Step 3: Implement model, schema, repository, service, router**

Requirements:
- include common fields `id`, `created_at`, `updated_at`, `version`, `status`, `source`, `sync_status`
- set default `status="draft"`
- return JSON shaped for Flutter consumption

- [ ] **Step 4: Run the learning goal test**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_learning_goals.py -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git -C /Users/xia/program/Learn add backend
git -C /Users/xia/program/Learn commit -m "feat: add learning goal creation API"
```

### Task 3: Generate and confirm roadmap

**Files:**
- Create: `/Users/xia/program/Learn/backend/app/models/roadmap.py`
- Create: `/Users/xia/program/Learn/backend/app/schemas/roadmap.py`
- Create: `/Users/xia/program/Learn/backend/app/repositories/roadmap_repository.py`
- Create: `/Users/xia/program/Learn/backend/app/services/roadmap_service.py`
- Create: `/Users/xia/program/Learn/backend/app/providers/base.py`
- Create: `/Users/xia/program/Learn/backend/app/providers/mock_provider.py`
- Create: `/Users/xia/program/Learn/backend/app/api/roadmaps.py`
- Test: `/Users/xia/program/Learn/backend/tests/test_roadmaps.py`

- [ ] **Step 1: Write failing roadmap generation test**

```python
def test_generate_roadmap_from_learning_goal(client, learning_goal_id):
    response = client.post("/api/v1/roadmaps/generate", json={"learning_goal_id": learning_goal_id})
    assert response.status_code == 201
    body = response.json()
    assert body["status"] == "draft"
    assert len(body["stages"]) >= 1
```

- [ ] **Step 2: Write failing roadmap confirm test**

```python
def test_confirm_roadmap_marks_it_active(client, roadmap_id):
    response = client.post(f"/api/v1/roadmaps/{roadmap_id}/confirm")
    assert response.status_code == 200
    assert response.json()["status"] == "active"
```

- [ ] **Step 3: Run roadmap tests to verify failure**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_roadmaps.py -v`
Expected: FAIL because roadmap service and provider do not exist

- [ ] **Step 4: Implement roadmap model and provider-backed generator**

Requirements:
- mock provider returns deterministic roadmap stages
- save roadmap plus stage rows
- confirm endpoint changes roadmap status and current stage

- [ ] **Step 5: Run roadmap tests**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_roadmaps.py -v`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git -C /Users/xia/program/Learn add backend
git -C /Users/xia/program/Learn commit -m "feat: add roadmap generation and confirmation"
```

### Task 4: Add current session bootstrap and task card

**Files:**
- Create: `/Users/xia/program/Learn/backend/app/models/session.py`
- Create: `/Users/xia/program/Learn/backend/app/schemas/session.py`
- Create: `/Users/xia/program/Learn/backend/app/repositories/session_repository.py`
- Create: `/Users/xia/program/Learn/backend/app/services/session_service.py`
- Create: `/Users/xia/program/Learn/backend/app/api/sessions.py`
- Test: `/Users/xia/program/Learn/backend/tests/test_sessions.py`

- [ ] **Step 1: Write failing current-session test**

```python
def test_get_current_session_returns_task_card(client, confirmed_roadmap_id):
    response = client.get("/api/v1/sessions/current")
    assert response.status_code == 200
    body = response.json()
    assert body["task_card"]["topic"]
    assert body["task_card"]["success_criteria"]
```

- [ ] **Step 2: Run session test to verify failure**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_sessions.py::test_get_current_session_returns_task_card -v`
Expected: FAIL because current session route does not exist

- [ ] **Step 3: Implement session bootstrap**

Requirements:
- create current session from active roadmap if none exists
- include task card fields: topic, objective, question focus, success criteria, estimated minutes
- persist session and first phase

- [ ] **Step 4: Run targeted session test**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_sessions.py::test_get_current_session_returns_task_card -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git -C /Users/xia/program/Learn add backend
git -C /Users/xia/program/Learn commit -m "feat: add current session bootstrap"
```

### Task 5: Add answer, hint, explain-again, and complete session endpoints

**Files:**
- Modify: `/Users/xia/program/Learn/backend/app/services/session_service.py`
- Modify: `/Users/xia/program/Learn/backend/app/api/sessions.py`
- Modify: `/Users/xia/program/Learn/backend/app/providers/mock_provider.py`
- Test: `/Users/xia/program/Learn/backend/tests/test_sessions.py`

- [ ] **Step 1: Write failing answer progression test**

```python
def test_answer_advances_session_step(client, current_session_id):
    response = client.post(
        f"/api/v1/sessions/{current_session_id}/answer",
        json={"answer": "栈是先进后出结构"},
    )
    assert response.status_code == 200
    body = response.json()
    assert body["feedback"]["type"] in {"encourage", "corrective"}
    assert body["next_step"] in {"example", "compare", "transfer"}
```

- [ ] **Step 2: Write failing hint and explain-again tests**

```python
def test_hint_returns_smaller_prompt(client, current_session_id):
    response = client.post(f"/api/v1/sessions/{current_session_id}/hint")
    assert response.status_code == 200
    assert response.json()["hint"]
```

```python
def test_explain_again_returns_reframed_explanation(client, current_session_id):
    response = client.post(f"/api/v1/sessions/{current_session_id}/explain-again")
    assert response.status_code == 200
    assert response.json()["explanation"]
```

- [ ] **Step 3: Write failing complete-session test**

```python
def test_complete_session_generates_review_tasks(client, current_session_id):
    response = client.post(f"/api/v1/sessions/{current_session_id}/complete")
    assert response.status_code == 200
    assert len(response.json()["generated_review_tasks"]) >= 1
```

- [ ] **Step 4: Run session suite to verify failure**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_sessions.py -v`
Expected: FAIL because progression logic does not exist yet

- [ ] **Step 5: Implement deterministic MVP learning state machine**

Requirements:
- phases follow explain -> example -> compare -> transfer
- incorrect answers trigger corrective feedback and same/smaller-step retry
- hint and explain-again use provider hooks
- complete session writes mastery assessment and review seeds

- [ ] **Step 6: Run full session suite**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_sessions.py -v`
Expected: PASS

- [ ] **Step 7: Commit**

```bash
git -C /Users/xia/program/Learn add backend
git -C /Users/xia/program/Learn commit -m "feat: add learning session progression APIs"
```

### Task 6: Add review APIs

**Files:**
- Create: `/Users/xia/program/Learn/backend/app/models/review.py`
- Create: `/Users/xia/program/Learn/backend/app/schemas/review.py`
- Create: `/Users/xia/program/Learn/backend/app/repositories/review_repository.py`
- Create: `/Users/xia/program/Learn/backend/app/services/review_service.py`
- Create: `/Users/xia/program/Learn/backend/app/api/reviews.py`
- Test: `/Users/xia/program/Learn/backend/tests/test_reviews.py`

- [ ] **Step 1: Write failing today-review test**

```python
def test_get_todays_reviews_returns_due_tasks(client):
    response = client.get("/api/v1/reviews/today")
    assert response.status_code == 200
    assert isinstance(response.json()["items"], list)
```

- [ ] **Step 2: Write failing complete-review test**

```python
def test_complete_review_updates_status(client, review_task_id):
    response = client.post(f"/api/v1/reviews/{review_task_id}/complete", json={"result": "good"})
    assert response.status_code == 200
    assert response.json()["status"] == "completed"
```

- [ ] **Step 3: Run review tests to verify failure**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_reviews.py -v`
Expected: FAIL because review API does not exist

- [ ] **Step 4: Implement review list and completion logic**

Requirements:
- session completion seeds review tasks using simple spaced repetition offsets
- `/reviews/today` filters by due date and status
- review completion updates next review metadata and mastery snapshot

- [ ] **Step 5: Run review suite**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest tests/test_reviews.py -v`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git -C /Users/xia/program/Learn add backend
git -C /Users/xia/program/Learn commit -m "feat: add review task APIs"
```

### Task 7: Add backend smoke command and documentation

**Files:**
- Modify: `/Users/xia/program/Learn/README.md`
- Create: `/Users/xia/program/Learn/backend/README.md`

- [ ] **Step 1: Document backend startup and test commands**
- [ ] **Step 2: Add minimal curl examples for health, goal, roadmap, session, review**
- [ ] **Step 3: Commit**

```bash
git -C /Users/xia/program/Learn add README.md backend/README.md
git -C /Users/xia/program/Learn commit -m "docs: add local backend run instructions"
```

### Task 8: Add Flutter API client and learning repository

**Files:**
- Modify: `/Users/xia/program/Learn/flutter_app/pubspec.yaml`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/core/config/app_env.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/core/network/api_client.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/domain/learning_goal.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/domain/roadmap.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/domain/session.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/domain/review_task.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/data/learning_api.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/data/learning_repository.dart`
- Create: `/Users/xia/program/Learn/flutter_app/lib/src/features/learning/state/*.dart`
- Test: `/Users/xia/program/Learn/flutter_app/test/features/learning/*.dart`

- [ ] **Step 1: Write failing Flutter repository/provider tests**

Target assertions:
- loads current session from HTTP response
- loads review list from HTTP response
- surfaces loading/error states cleanly

- [ ] **Step 2: Run Flutter targeted tests to verify failure**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter test test/features/learning -r compact`
Expected: FAIL because repository/provider files do not exist

- [ ] **Step 3: Implement API client, DTO mapping, repository, and providers**

Requirements:
- single configured Dio client
- base URL from env/config
- keep domain models small and UI-focused
- repository shields screens from transport details

- [ ] **Step 4: Run targeted Flutter tests**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter test test/features/learning -r compact`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git -C /Users/xia/program/Learn add flutter_app/pubspec.yaml flutter_app/lib/src/core flutter_app/lib/src/features/learning flutter_app/test/features/learning
git -C /Users/xia/program/Learn commit -m "feat: add Flutter learning API client"
```

### Task 9: Replace mock-driven Home and Roadmap entry state

**Files:**
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/home/presentation/home_screen.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/roadmap/presentation/roadmap_screen.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/profile/presentation/profile_analytics_screen.dart`
- Test: `/Users/xia/program/Learn/flutter_app/test/features/home/*.dart`
- Test: `/Users/xia/program/Learn/flutter_app/test/features/roadmap/*.dart`

- [ ] **Step 1: Write failing UI/provider tests for real state rendering**

Assertions:
- Home shows current task from provider
- Roadmap shows active roadmap stages from API data
- Profile shows backend-driven study stats placeholder instead of hard-coded values

- [ ] **Step 2: Run targeted tests to verify failure**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter test test/features/home test/features/roadmap -r compact`
Expected: FAIL because screens still use mock data

- [ ] **Step 3: Replace mock usage with repository-backed providers**

- [ ] **Step 4: Run targeted tests**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter test test/features/home test/features/roadmap -r compact`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git -C /Users/xia/program/Learn add flutter_app/lib/src/features/home flutter_app/lib/src/features/roadmap flutter_app/lib/src/features/profile
git -C /Users/xia/program/Learn commit -m "feat: connect home and roadmap to local backend"
```

### Task 10: Replace mock-driven Chat and Review logic

**Files:**
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/chat/presentation/chat_screen.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/review/presentation/review_screen.dart`
- Modify: `/Users/xia/program/Learn/flutter_app/lib/src/features/chat/presentation/focus_mode_screen.dart`
- Test: `/Users/xia/program/Learn/flutter_app/test/features/chat/*.dart`
- Test: `/Users/xia/program/Learn/flutter_app/test/features/review/*.dart`

- [ ] **Step 1: Write failing UI tests for session progression**

Assertions:
- sending answer calls answer API and updates next prompt
- tapping hint calls hint API
- tapping explain-again calls explain-again API
- review screen lists due tasks and completion updates state

- [ ] **Step 2: Run targeted tests to verify failure**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter test test/features/chat test/features/review -r compact`
Expected: FAIL because chat and review still use local stub state

- [ ] **Step 3: Wire Chat and Review to backend providers**

Requirements:
- preserve loading/empty/error states
- preserve existing visual design
- disable actions while request is in flight

- [ ] **Step 4: Run targeted tests**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter test test/features/chat test/features/review -r compact`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git -C /Users/xia/program/Learn add flutter_app/lib/src/features/chat flutter_app/lib/src/features/review flutter_app/test/features/chat flutter_app/test/features/review
git -C /Users/xia/program/Learn commit -m "feat: connect chat and review to local backend"
```

### Task 11: End-to-end local verification

**Files:**
- Modify: docs if needed based on verification findings

- [ ] **Step 1: Run backend test suite**

Run: `cd /Users/xia/program/Learn/backend && python3 -m pytest -q`
Expected: all backend tests pass

- [ ] **Step 2: Run Flutter verification**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter analyze`
Expected: no issues

- [ ] **Step 3: Run Flutter tests**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter test`
Expected: all tests pass

- [ ] **Step 4: Run web build**

Run: `cd /Users/xia/program/Learn/flutter_app && flutter build web`
Expected: build succeeds

- [ ] **Step 5: Start backend locally and smoke test health**

Run: `cd /Users/xia/program/Learn/backend && python3 -m uvicorn app.main:app --reload`
Expected: backend serves `/api/v1/health`

- [ ] **Step 6: Manual smoke flow**

Verify:
- create learning goal
- generate roadmap
- confirm roadmap
- fetch current session
- answer once
- list today reviews

- [ ] **Step 7: Commit final fixes**

```bash
git -C /Users/xia/program/Learn add backend flutter_app README.md docs
git -C /Users/xia/program/Learn commit -m "feat: ship local-first learning loop MVP"
```
