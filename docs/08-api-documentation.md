# API接口文档

## 文档信息
- **项目名称**：智学AI（LearnAI）
- **版本**：v1.0
- **文档创建日期**：2026-04-03
- **API负责人**：API工程师

## 一、API概述

### 1.1 基础信息
- **Base URL**：`https://api.learnai.com/v1`
- **协议**：HTTPS
- **数据格式**：JSON
- **字符编码**：UTF-8

### 1.2 认证方式

#### 1.2.1 JWT Token认证
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### 1.2.2 Token获取流程
```
1. 用户登录 → 获取 access_token + refresh_token
2. 每次请求携带 access_token
3. access_token过期 → 使用 refresh_token刷新
```

### 1.3 通用响应格式

#### 1.3.1 成功响应
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "uuid",
    "name": "示例数据"
  },
  "timestamp": "2026-04-03T10:00:00Z"
}
```

#### 1.3.2 列表响应
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "items": [...],
    "total": 100,
    "page": 1,
    "limit": 10,
    "has_more": true
  },
  "timestamp": "2026-04-03T10:00:00Z"
}
```

#### 1.3.3 错误响应
```json
{
  "code": 400,
  "message": "参数错误",
  "errors": [
    {
      "field": "email",
      "message": "邮箱格式不正确"
    }
  ],
  "timestamp": "2026-04-03T10:00:00Z"
}
```

### 1.4 HTTP状态码

| 状态码 | 说明 |
|--------|------|
| 200 | 成功 |
| 201 | 创建成功 |
| 204 | 删除成功（无内容） |
| 400 | 请求参数错误 |
| 401 | 未认证 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 409 | 资源冲突 |
| 422 | 参数验证失败 |
| 429 | 请求频率超限 |
| 500 | 服务器内部错误 |

### 1.5 分页参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| page | int | 否 | 1 | 页码，从1开始 |
| limit | int | 否 | 10 | 每页数量，最大100 |
| sort | string | 否 | created_at | 排序字段 |
| order | string | 否 | desc | 排序方向(asc/desc) |

## 二、用户认证接口

### 2.1 手机号注册

**接口**：`POST /auth/register/phone`

**请求参数**：
```json
{
  "phone": "13800138000",
  "code": "123456",
  "password": "Password123!",
  "nickname": "昵称"
}
```

**响应**：
```json
{
  "code": 201,
  "message": "注册成功",
  "data": {
    "user_id": "uuid",
    "access_token": "eyJhbGci...",
    "refresh_token": "eyJhbGci...",
    "expires_in": 7200
  }
}
```

**错误码**：
| code | message | 说明 |
|------|---------|------|
| 400 | 验证码错误 | - |
| 409 | 手机号已注册 | - |

### 2.2 邮箱注册

**接口**：`POST /auth/register/email`

**请求参数**：
```json
{
  "email": "user@example.com",
  "code": "123456",
  "password": "Password123!",
  "nickname": "昵称"
}
```

**响应**：同手机号注册

### 2.3 手机号登录

**接口**：`POST /auth/login/phone`

**请求参数**：
```json
{
  "phone": "13800138000",
  "password": "Password123!"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "user_id": "uuid",
    "access_token": "eyJhbGci...",
    "refresh_token": "eyJhbGci...",
    "expires_in": 7200
  }
}
```

**错误码**：
| code | message | 说明 |
|------|---------|------|
| 401 | 手机号或密码错误 | - |
| 403 | 账号已禁用 | - |

### 2.4 邮箱登录

**接口**：`POST /auth/login/email`

**请求参数**：
```json
{
  "email": "user@example.com",
  "password": "Password123!"
}
```

**响应**：同手机号登录

### 2.5 第三方登录

**接口**：`POST /auth/login/oauth`

**请求参数**：
```json
{
  "provider": "wechat",
  "code": "oauth_code",
  "state": "state_string"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "user_id": "uuid",
    "is_new_user": false,
    "access_token": "eyJhbGci...",
    "refresh_token": "eyJhbGci...",
    "expires_in": 7200
  }
}
```

### 2.6 刷新Token

**接口**：`POST /auth/refresh`

**请求参数**：
```json
{
  "refresh_token": "eyJhbGci..."
}
```

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "access_token": "eyJhbGci...",
    "refresh_token": "eyJhbGci...",
    "expires_in": 7200
  }
}
```

### 2.7 退出登录

**接口**：`POST /auth/logout`

**认证**：需要

**响应**：
```json
{
  "code": 204,
  "message": "success"
}
```

### 2.8 发送验证码

**接口**：`POST /auth/send-code`

**请求参数**：
```json
{
  "type": "phone",
  "phone": "13800138000",
  "purpose": "register"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "发送成功",
  "data": {
    "expires_in": 300
  }
}
```

## 三、用户管理接口

### 3.1 获取当前用户信息

**接口**：`GET /users/me`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "uuid",
    "phone": "138****8000",
    "email": "user@example.com",
    "nickname": "昵称",
    "avatar_url": "https://example.com/avatar.jpg",
    "bio": "个人简介",
    "role": "user",
    "level": 3,
    "experience": 1500,
    "study_days": 23,
    "streak": 5,
    "created_at": "2026-01-01T00:00:00Z"
  }
}
```

### 3.2 更新用户信息

**接口**：`PUT /users/me`

**认证**：需要

**请求参数**：
```json
{
  "nickname": "新昵称",
  "bio": "新的个人简介",
  "gender": "male",
  "birth_date": "2000-01-01"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "更新成功",
  "data": {
    "id": "uuid",
    "nickname": "新昵称"
  }
}
```

### 3.3 上传头像

**接口**：`POST /users/me/avatar`

**认证**：需要

**请求**：multipart/form-data
```
file: [二进制文件]
```

**响应**：
```json
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "avatar_url": "https://example.com/avatar.jpg"
  }
}
```

### 3.4 修改密码

**接口**：`PUT /users/me/password`

**认证**：需要

**请求参数**：
```json
{
  "old_password": "OldPassword123!",
  "new_password": "NewPassword123!"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "密码修改成功"
}
```

### 3.5 获取用户设置

**接口**：`GET /users/me/settings`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "learning_level": "beginner",
    "learning_goals": ["编程", "算法"],
    "preferred_subjects": ["计算机科学"],
    "daily_goal_minutes": 30,
    "notification_enabled": true,
    "email_notification": true,
    "push_notification": true,
    "study_reminder_time": "19:00:00",
    "theme": "auto",
    "language": "zh-CN"
  }
}
```

### 3.6 更新用户设置

**接口**：`PUT /users/me/settings`

**认证**：需要

**请求参数**：
```json
{
  "daily_goal_minutes": 60,
  "theme": "dark"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "设置更新成功",
  "data": {
    "daily_goal_minutes": 60
  }
}
```

## 四、学习路线接口

### 4.1 创建学习路线

**接口**：`POST /learning/routes`

**认证**：需要

**请求参数**：
```json
{
  "topic": "Python",
  "target_outcome": "能够使用Python进行数据科学分析",
  "current_level": "beginner",
  "target_level": "intermediate",
  "available_time_per_day": 60
}
```

**响应**：
```json
{
  "code": 201,
  "message": "创建成功",
  "data": {
    "id": "uuid",
    "title": "Python学习路线",
    "topic": "Python",
    "target_outcome": "能够使用Python进行数据科学分析",
    "stages": [
      {
        "id": "uuid",
        "stage_number": 1,
        "title": "Python基础",
        "goal": "掌握Python基础语法",
        "knowledge_points": [
          {
            "id": "uuid",
            "title": "变量和数据类型",
            "difficulty": "easy"
          }
        ]
      }
    ],
    "estimated_duration": 40,
    "created_at": "2026-04-03T10:00:00Z"
  }
}
```

### 4.2 获取学习路线列表

**接口**：`GET /learning/routes`

**认证**：需要

**查询参数**：
| 参数 | 类型 | 说明 |
|------|------|------|
| status | string | 筛选状态(active/completed/paused) |

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "items": [
      {
        "id": "uuid",
        "title": "Python学习路线",
        "topic": "Python",
        "status": "active",
        "progress_percentage": 35,
        "current_stage": 2,
        "total_stages": 5,
        "started_at": "2026-03-01T00:00:00Z"
      }
    ],
    "total": 10,
    "page": 1,
    "limit": 10
  }
}
```

### 4.3 获取学习路线详情

**接口**：`GET /learning/routes/{route_id}`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "uuid",
    "title": "Python学习路线",
    "description": "从入门到精通的Python学习路径",
    "topic": "Python",
    "target_outcome": "能够使用Python进行数据科学分析",
    "current_level": "beginner",
    "target_level": "intermediate",
    "status": "active",
    "progress_percentage": 35,
    "current_stage": 2,
    "total_stages": 5,
    "stages": [
      {
        "id": "uuid",
        "stage_number": 1,
        "title": "Python基础",
        "description": "学习Python的基础语法",
        "goal": "掌握Python基础语法",
        "completion_criteria": "能够完成简单的Python编程",
        "status": "completed",
        "knowledge_points": [...]
      },
      {
        "id": "uuid",
        "stage_number": 2,
        "title": "面向对象编程",
        "status": "active",
        "knowledge_points": [...]
      }
    ],
    "estimated_duration": 40,
    "started_at": "2026-03-01T00:00:00Z",
    "created_at": "2026-03-01T00:00:00Z"
  }
}
```

### 4.4 更新学习路线

**接口**：`PUT /learning/routes/{route_id}`

**认证**：需要

**请求参数**：
```json
{
  "title": "新的标题",
  "target_outcome": "新的目标"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "更新成功",
  "data": {
    "id": "uuid",
    "title": "新的标题"
  }
}
```

### 4.5 开始学习路线

**接口**：`POST /learning/routes/{route_id}/start`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "开始学习",
  "data": {
    "route_id": "uuid",
    "current_knowledge_point_id": "uuid"
  }
}
```

### 4.6 暂停学习路线

**接口**：`POST /learning/routes/{route_id}/pause`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "已暂停"
}
```

### 4.7 删除学习路线

**接口**：`DELETE /learning/routes/{route_id}`

**认证**：需要

**响应**：
```json
{
  "code": 204,
  "message": "删除成功"
}
```

### 4.8 获取学习进度

**接口**：`GET /learning/routes/{route_id}/progress`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "route_id": "uuid",
    "progress_percentage": 35,
    "stages_completed": 1,
    "stages_total": 5,
    "knowledge_points_completed": 8,
    "knowledge_points_total": 24,
    "study_duration": 7200,
    "weekly_progress": [
      {
        "date": "2026-04-01",
        "points_learned": 3,
        "duration": 1800
      }
    ]
  }
}
```

## 五、知识点接口

### 5.1 获取知识点详情

**接口**：`GET /learning/knowledge-points/{kp_id}`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "uuid",
    "stage_id": "uuid",
    "title": "变量和数据类型",
    "content": "变量是用来存储数据的容器...",
    "summary": "学习Python中的变量和基本数据类型",
    "difficulty": "easy",
    "category": "Python基础",
    "tags": ["Python", "变量", "数据类型"],
    "mastery_level": "not_started",
    "estimated_study_time": 30,
    "created_at": "2026-04-03T10:00:00Z"
  }
}
```

### 5.2 标记知识点完成

**接口**：`POST /learning/knowledge-points/{kp_id}/complete`

**认证**：需要

**请求参数**：
```json
{
  "mastery_level": "basic"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "标记完成",
  "data": {
    "knowledge_point_id": "uuid",
    "mastery_level": "basic"
  }
}
```

### 5.3 获取知识点模板

**接口**：`GET /learning/knowledge-points/templates`

**认证**：需要

**查询参数**：
| 参数 | 类型 | 说明 |
|------|------|------|
| category | string | 分类筛选 |
| difficulty | string | 难度筛选 |

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "items": [...]
  }
}
```

## 六、AI对话接口

### 6.1 开始对话会话

**接口**：`POST /ai/chat/sessions`

**认证**：需要

**请求参数**：
```json
{
  "knowledge_point_id": "uuid"
}
```

**响应**：
```json
{
  "code": 201,
  "message": "会话创建成功",
  "data": {
    "session_id": "uuid",
    "first_message": {
      "role": "assistant",
      "content": "你好！让我们开始学习这个知识点。首先，请用你自己的话描述一下什么是变量？",
      "question_type": "explain"
    }
  }
}
```

### 6.2 发送消息

**接口**：`POST /ai/chat/sessions/{session_id}/messages`

**认证**：需要

**请求参数**：
```json
{
  "content": "变量是用来存储数据的容器，可以赋值不同的数据类型"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "message": {
      "id": "uuid",
      "role": "assistant",
      "content": "很好！你对变量的理解是正确的。现在，能不能给我举一个具体的例子？",
      "question_type": "example",
      "feedback_type": "correct"
    },
    "question_number": 2,
    "total_questions": 4
  }
}
```

### 6.3 获取对话历史

**接口**：`GET /ai/chat/sessions/{session_id}/messages`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "session_id": "uuid",
    "title": "变量和数据类型",
    "status": "active",
    "messages": [
      {
        "id": "uuid",
        "role": "assistant",
        "content": "你好！让我们开始学习这个知识点...",
        "question_type": "explain",
        "created_at": "2026-04-03T10:00:00Z"
      },
      {
        "id": "uuid",
        "role": "user",
        "content": "变量是用来存储数据的容器...",
        "created_at": "2026-04-03T10:01:00Z"
      }
    ]
  }
}
```

### 6.4 跳过当前问题

**接口**：`POST /ai/chat/sessions/{session_id}/skip`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "message": {
      "role": "assistant",
      "content": "没关系，我们换一个问题。让我们来思考...",
      "question_type": "compare"
    }
  }
}
```

### 6.5 获取提示

**接口**：`POST /ai/chat/sessions/{session_id}/hint`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "hint": "提示：考虑变量名的命名规范..."
  }
}
```

### 6.6 结束对话会话

**接口**：`POST /ai/chat/sessions/{session_id}/end`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "会话已结束",
  "data": {
    "session_id": "uuid",
    "mastery_level": "basic",
    "summary": "你已经掌握了变量和数据类型的基础知识"
  }
}
```

## 七、复习系统接口

### 7.1 获取今日复习任务

**接口**：`GET /review/tasks/today`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total_count": 3,
    "completed_count": 1,
    "tasks": [
      {
        "id": "uuid",
        "plan_id": "uuid",
        "knowledge_point": {
          "id": "uuid",
          "title": "变量和数据类型"
        },
        "review_type": "recall",
        "review_content": "请回忆什么是变量？",
        "status": "pending",
        "scheduled_date": "2026-04-03"
      }
    ]
  }
}
```

### 7.2 获取复习任务详情

**接口**：`GET /review/tasks/{task_id}`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": "uuid",
    "knowledge_point": {
      "id": "uuid",
      "title": "变量和数据类型",
      "content": "..."
    },
    "review_type": "recall",
    "review_content": "请回忆什么是变量？",
    "status": "pending",
    "scheduled_date": "2026-04-03"
  }
}
```

### 7.3 完成复习任务

**接口**：`POST /review/tasks/{task_id}/complete`

**认证**：需要

**请求参数**：
```json
{
  "user_response": "变量是用来存储数据的容器",
  "result": "good"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "复习完成",
  "data": {
    "task_id": "uuid",
    "next_review_date": "2026-04-06",
    "mastery_level": "basic"
  }
}
```

### 7.4 跳过复习任务

**接口**：`POST /review/tasks/{task_id}/skip`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "已跳过",
  "data": {
    "task_id": "uuid"
  }
}
```

### 7.5 获取复习计划

**接口**：`GET /review/plans`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "items": [
      {
        "id": "uuid",
        "knowledge_point": {
          "id": "uuid",
          "title": "变量和数据类型"
        },
        "next_review_date": "2026-04-06",
        "review_count": 2,
        "mastery_level": "basic"
      }
    ],
    "total": 15
  }
}
```

### 7.6 获取复习日历

**接口**：`GET /review/calendar`

**认证**：需要

**查询参数**：
| 参数 | 类型 | 说明 |
|------|------|------|
| year | int | 年份 |
| month | int | 月份 |

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "year": 2026,
    "month": 4,
    "days": [
      {
        "date": "2026-04-03",
        "task_count": 3,
        "completed_count": 1
      }
    ]
  }
}
```

### 7.7 获取掌握度统计

**接口**：`GET /review/mastery`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total_knowledge_points": 24,
    "not_started": 8,
    "basic_mastery": 12,
    "deep_mastery": 4,
    "mastery_chart": [
      {
        "date": "2026-04-01",
        "basic": 10,
        "deep": 3
      }
    ]
  }
}
```

## 八、数据统计接口

### 8.1 获取学习统计概览

**接口**：`GET /data/statistics/summary`

**认证**：需要

**查询参数**：
| 参数 | 类型 | 说明 |
|------|------|------|
| period | string | 统计周期(week/month/year) |

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total_study_days": 23,
    "total_study_duration": 72000,
    "total_knowledge_points": 24,
    "completed_knowledge_points": 16,
    "review_tasks_completed": 45,
    "current_streak": 5,
    "longest_streak": 12,
    "avg_daily_duration": 1800,
    "trend": "up"
  }
}
```

### 8.2 获取每日学习数据

**接口**：`GET /data/statistics/daily`

**认证**：需要

**查询参数**：
| 参数 | 类型 | 说明 |
|------|------|------|
| start_date | string | 开始日期 |
| end_date | string | 结束日期 |

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "items": [
      {
        "date": "2026-04-01",
        "study_duration": 3600,
        "knowledge_points_learned": 3,
        "review_tasks_completed": 2,
        "chat_sessions_count": 2,
        "questions_answered": 8,
        "correct_answers": 6
      }
    ],
    "total": 30
  }
}
```

### 8.3 获取成就列表

**接口**：`GET /data/achievements`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "unlocked": [
      {
        "id": "uuid",
        "code": "first_learning",
        "name": "学习新手",
        "description": "完成第一个知识点",
        "icon_url": "https://example.com/badge.jpg",
        "unlocked_at": "2026-03-01T00:00:00Z"
      }
    ],
    "locked": [
      {
        "id": "uuid",
        "code": "study_master",
        "name": "学习达人",
        "description": "完成50个知识点",
        "icon_url": "https://example.com/badge.jpg",
        "progress": 32,
        "total": 50
      }
    ]
  }
}
```

### 8.4 导出学习报告

**接口**：`GET /data/report`

**认证**：需要

**查询参数**：
| 参数 | 类型 | 说明 |
|------|------|------|
| format | string | 格式(pdf/excel) |
| start_date | string | 开始日期 |
| end_date | string | 结束日期 |

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "download_url": "https://example.com/report.pdf"
  }
}
```

## 九、通知接口

### 9.1 获取通知列表

**接口**：`GET /notifications`

**认证**：需要

**查询参数**：
| 参数 | 类型 | 说明 |
|------|------|------|
| type | string | 通知类型 |
| is_read | boolean | 是否已读 |

**响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "items": [
      {
        "id": "uuid",
        "type": "review",
        "title": "复习提醒",
        "content": "你有3个知识点需要复习",
        "is_read": false,
        "created_at": "2026-04-03T10:00:00Z"
      }
    ],
    "total": 10,
    "unread_count": 3
  }
}
```

### 9.2 标记通知已读

**接口**：`PUT /notifications/{notification_id}/read`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "已标记已读"
}
```

### 9.3 标记全部已读

**接口**：`PUT /notifications/read-all`

**认证**：需要

**响应**：
```json
{
  "code": 200,
  "message": "已全部标记已读"
}
```

## 十、错误码说明

| 错误码 | 说明 |
|--------|------|
| 10001 | 参数验证失败 |
| 10002 | 用户不存在 |
| 10003 | 密码错误 |
| 10004 | 验证码错误 |
| 10005 | 验证码已过期 |
| 10006 | 手机号已注册 |
| 10007 | 邮箱已注册 |
| 10008 | Token无效 |
| 10009 | Token已过期 |
| 10010 | 账号已禁用 |
| 20001 | 学习路线不存在 |
| 20002 | 知识点不存在 |
| 20003 | 对话会话不存在 |
| 20004 | 复习任务不存在 |
| 20005 | 无权访问 |
| 30001 | AI服务暂时不可用 |
| 30002 | AI响应超时 |
| 30003 | Token使用超限 |
| 40001 | 上传文件过大 |
| 40002 | 文件格式不支持 |
| 50001 | 服务器内部错误 |
| 50002 | 数据库错误 |
| 50003 | 缓存错误 |

## 十一、附录

### 11.1 WebSocket接口

#### 实时对话
```
连接：wss://api.learnai.com/v1/ws/chat/{session_id}

消息格式：
{
  "type": "message",
  "data": {
    "content": "用户消息"
  }
}

响应：
{
  "type": "message",
  "data": {
    "role": "assistant",
    "content": "AI回复"
  }
}
```

### 11.2 SDK文档

- iOS SDK：[LearnAI-iOS](https://github.com/learnai/LearnAI-iOS)
- Android SDK：[LearnAI-Android](https://github.com/learnai/LearnAI-Android)
- Web SDK：[LearnAI-Web](https://github.com/learnai/LearnAI-Web)

### 11.3 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|---------|
| v1.0 | 2026-04-03 | 初始版本 |