# LearnAI Local Backend

本目录是智学 AI 当前阶段使用的本地优先后端实现。

## 当前范围

已实现的核心能力：

- 健康检查
- 创建学习目标
- 生成并确认学习路线
- 获取当前学习会话与任务卡
- 学习会话回答、提示、重讲
- 完成会话并生成复习任务
- 获取今日复习任务
- 完成复习任务

## 运行测试

```bash
cd /Users/xia/program/Learn/.worktrees/local-backend-mvp/backend
python3 -m pytest -q
```

## 启动本地服务

```bash
cd /Users/xia/program/Learn/.worktrees/local-backend-mvp/backend
python3 -m uvicorn app.main:app --reload
```

启动后默认可访问：

- `GET /api/v1/health`

## 本地 API 示例

### 1. 创建学习目标

```bash
curl -sS -X POST http://127.0.0.1:8000/api/v1/learning-goals \
  -H "Content-Type: application/json" \
  -d '{
    "topic":"数据结构",
    "target_outcome":"能够解释常见数据结构并完成中等题目",
    "current_level":"beginner",
    "study_pace":"steady",
    "evaluation_preference":false
  }'
```

### 2. 生成路线

```bash
curl -sS -X POST http://127.0.0.1:8000/api/v1/roadmaps/generate \
  -H "Content-Type: application/json" \
  -d '{"learning_goal_id":"<learning_goal_id>"}'
```

### 3. 确认路线

```bash
curl -sS -X POST http://127.0.0.1:8000/api/v1/roadmaps/<roadmap_id>/confirm
```

### 4. 获取当前会话

```bash
curl -sS http://127.0.0.1:8000/api/v1/sessions/current
```

### 5. 提交一次回答

```bash
curl -sS -X POST http://127.0.0.1:8000/api/v1/sessions/<session_id>/answer \
  -H "Content-Type: application/json" \
  -d '{"answer":"栈是先进后出的线性结构。"}'
```

### 6. 获取提示

```bash
curl -sS -X POST http://127.0.0.1:8000/api/v1/sessions/<session_id>/hint
```

### 7. 重新讲解

```bash
curl -sS -X POST http://127.0.0.1:8000/api/v1/sessions/<session_id>/explain-again
```

### 8. 完成会话

```bash
curl -sS -X POST http://127.0.0.1:8000/api/v1/sessions/<session_id>/complete
```

### 9. 查看今日复习

```bash
curl -sS http://127.0.0.1:8000/api/v1/reviews/today
```

### 10. 完成复习

```bash
curl -sS -X POST http://127.0.0.1:8000/api/v1/reviews/<review_task_id>/complete \
  -H "Content-Type: application/json" \
  -d '{"result":"good"}'
```
