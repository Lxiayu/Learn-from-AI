# 数据库设计文档

## 文档信息
- **项目名称**：智学AI（LearnAI）
- **版本**：v1.0
- **文档创建日期**：2026-04-03
- **数据库负责人**：数据库工程师

## 一、数据库概述

### 1.1 设计原则
- **规范化**：遵循第三范式，减少数据冗余
- **性能优先**：合理使用索引，优化查询性能
- **可扩展**：支持水平和垂直扩展
- **安全性**：敏感数据加密存储
- **可维护**：清晰的命名规范和文档

### 1.2 数据库选型
| 数据库类型 | 数据库 | 用途 | 选型理由 |
|-----------|--------|------|---------|
| 关系型数据库 | PostgreSQL 15+ | 主数据库 | 开源、功能强大、稳定 |
| 缓存数据库 | Redis 7+ | 缓存、会话 | 高性能、支持多种数据结构 |
| 文档数据库 | MongoDB 7+ | 非结构化数据 | 灵活的文档存储 |
| 向量数据库 | Pinecone | 向量检索 | AI相关数据 |

### 1.3 命名规范
- **表名**：小写+下划线，复数形式，如 `users`、`learning_routes`
- **字段名**：小写+下划线，如 `user_id`、`created_at`
- **索引名**：`idx_表名_字段名`，如 `idx_users_email`
- **外键名**：`fk_表名_字段名`，如 `fk_learning_routes_user_id`
- **主键**：统一使用 `id`，类型为 UUID

## 二、数据库架构

### 2.1 ER图（简化版）

```
┌─────────┐
│  users  │
└────┬────┘
     │ 1
     │
     │ N
     ↓
┌──────────────────┐       ┌──────────────────┐
│ learning_routes  │──────→│ learning_stages  │
└────────┬─────────┘ 1   N └────────┬─────────┘
         │                              │
         │ N                            │ N
         ↓                              ↓
┌──────────────────┐       ┌──────────────────────┐
│ learning_records │       │ knowledge_points      │
└──────────────────┘       └───────┬──────────────┘
                                   │ 1
                                   │
                                   │ N
                                   ↓
                          ┌──────────────────────┐
                          │ chat_sessions        │
                          └───────┬──────────────┘
                                  │ 1
                                  │
                                  │ N
                                  ↓
                         ┌──────────────────────┐
                         │ chat_messages        │
                         └──────────────────────┘

┌──────────────────┐
│  review_plans   │
└────────┬─────────┘
         │ 1
         │
         │ N
         ↓
┌──────────────────┐
│  review_tasks   │
└──────────────────┘

┌──────────────────┐
│  achievements   │
└────────┬─────────┘
         │ 1
         │
         │ N
         ↓
┌──────────────────┐
│user_achievements│
└──────────────────┘

┌──────────────────┐
│user_statistics  │
└──────────────────┘
```

## 三、表结构设计

### 3.1 用户相关表

#### 3.1.1 users（用户表）
存储用户基本信息

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 用户ID |
| phone | VARCHAR(20) | UNIQUE | NULL | 手机号 |
| email | VARCHAR(255) | UNIQUE | NULL | 邮箱 |
| password_hash | VARCHAR(255) | NOT NULL | - | 密码哈希 |
| nickname | VARCHAR(50) | | NULL | 昵称 |
| avatar_url | VARCHAR(500) | | NULL | 头像URL |
| bio | TEXT | | NULL | 个人简介 |
| gender | VARCHAR(10) | | NULL | 性别 |
| birth_date | DATE | | NULL | 生日 |
| role | VARCHAR(20) | NOT NULL | 'user' | 用户角色(user/premium/admin) |
| status | VARCHAR(20) | NOT NULL | 'active' | 状态(active/disabled) |
| last_login_at | TIMESTAMP | | NULL | 最后登录时间 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE UNIQUE INDEX idx_users_phone ON users(phone) WHERE phone IS NOT NULL;
CREATE UNIQUE INDEX idx_users_email ON users(email) WHERE email IS NOT NULL;
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_created_at ON users(created_at);
```

#### 3.1.2 user_sessions（用户会话表）
存储用户登录会话

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 会话ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| token | VARCHAR(500) | NOT NULL | - | JWT Token |
| refresh_token | VARCHAR(500) | | NULL | 刷新Token |
| device_type | VARCHAR(50) | | NULL | 设备类型 |
| device_info | JSONB | | {} | 设备信息 |
| ip_address | VARCHAR(50) | | NULL | IP地址 |
| user_agent | TEXT | | NULL | User Agent |
| expires_at | TIMESTAMP | NOT NULL | - | 过期时间 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |

**索引**：
```sql
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_token ON user_sessions(token);
CREATE INDEX idx_user_sessions_expires_at ON user_sessions(expires_at);
```

#### 3.1.3 user_profiles（用户资料表）
存储用户学习偏好和设置

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| learning_level | VARCHAR(20) | | 'beginner' | 学习水平 |
| learning_goals | TEXT[] | | '{}' | 学习目标 |
| preferred_subjects | TEXT[] | | '{}' | 偏好学科 |
| daily_goal_minutes | INT | | 30 | 每日学习目标（分钟） |
| notification_enabled | BOOLEAN | | true | 是否启用通知 |
| email_notification | BOOLEAN | | true | 邮件通知 |
| push_notification | BOOLEAN | | true | 推送通知 |
| study_reminder_time | TIME | | '19:00:00' | 学习提醒时间 |
| theme | VARCHAR(20) | | 'auto' | 主题(auto/light/dark) |
| language | VARCHAR(20) | | 'zh-CN' | 语言 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE UNIQUE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
```

#### 3.1.4 user_statistics（用户统计表）
存储用户每日学习统计

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| date | DATE | NOT NULL | - | 日期 |
| study_duration | INT | NOT NULL | 0 | 学习时长（秒） |
| knowledge_points_learned | INT | NOT NULL | 0 | 学习知识点数 |
| review_tasks_completed | INT | NOT NULL | 0 | 完成复习任务数 |
| chat_sessions_count | INT | NOT NULL | 0 | 对话会话数 |
| questions_answered | INT | NOT NULL | 0 | 回答问题数 |
| correct_answers | INT | NOT NULL | 0 | 正确答案数 |
| streak | INT | NOT NULL | 0 | 连续学习天数 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE UNIQUE INDEX idx_user_statistics_user_date ON user_statistics(user_id, date);
CREATE INDEX idx_user_statistics_date ON user_statistics(date);
```

### 3.2 学习相关表

#### 3.2.1 learning_routes（学习路线表）
存储用户学习路线

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 路线ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| title | VARCHAR(200) | NOT NULL | - | 路线标题 |
| description | TEXT | | NULL | 路线描述 |
| topic | VARCHAR(100) | NOT NULL | - | 学习主题 |
| target_outcome | TEXT | | NULL | 目标结果 |
| current_level | VARCHAR(20) | NOT NULL | 'beginner' | 当前水平 |
| target_level | VARCHAR(20) | NOT NULL | 'intermediate' | 目标水平 |
| status | VARCHAR(20) | NOT NULL | 'active' | 状态(active/completed/paused) |
| current_stage | INT | NOT NULL | 1 | 当前阶段 |
| total_stages | INT | NOT NULL | 1 | 总阶段数 |
| progress_percentage | INT | NOT NULL | 0 | 进度百分比 |
| estimated_duration | INT | | NULL | 预计时长（小时） |
| started_at | TIMESTAMP | | NULL | 开始时间 |
| completed_at | TIMESTAMP | | NULL | 完成时间 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE INDEX idx_learning_routes_user_id ON learning_routes(user_id);
CREATE INDEX idx_learning_routes_status ON learning_routes(status);
CREATE INDEX idx_learning_routes_topic ON learning_routes(topic);
CREATE INDEX idx_learning_routes_created_at ON learning_routes(created_at);
```

#### 3.2.2 learning_stages（学习阶段表）
存储学习路线的各个阶段

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 阶段ID |
| route_id | UUID | REFERENCES learning_routes(id) | - | 路线ID |
| stage_number | INT | NOT NULL | - | 阶段序号 |
| title | VARCHAR(200) | NOT NULL | - | 阶段标题 |
| description | TEXT | | NULL | 阶段描述 |
| goal | TEXT | | NULL | 阶段目标 |
| completion_criteria | TEXT | | NULL | 完成标准 |
| why_first | TEXT | | NULL | 为什么先学 |
| connection_to_prev | TEXT | | NULL | 与上一阶段的连接 |
| status | VARCHAR(20) | NOT NULL | 'locked' | 状态(locked/active/completed) |
| order_index | INT | NOT NULL | 0 | 排序 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE INDEX idx_learning_stages_route_id ON learning_stages(route_id);
CREATE INDEX idx_learning_stages_route_stage ON learning_stages(route_id, stage_number);
CREATE INDEX idx_learning_stages_status ON learning_stages(status);
```

#### 3.2.3 knowledge_points（知识点表）
存储各个知识点

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 知识点ID |
| stage_id | UUID | REFERENCES learning_stages(id) | - | 阶段ID |
| title | VARCHAR(200) | NOT NULL | - | 知识点标题 |
| content | TEXT | | NULL | 知识点内容 |
| summary | TEXT | | NULL | 知识点摘要 |
| difficulty | VARCHAR(20) | NOT NULL | 'easy' | 难度(easy/medium/hard) |
| category | VARCHAR(100) | | NULL | 分类 |
| tags | TEXT[] | | '{}' | 标签 |
| mastery_level | VARCHAR(20) | NOT NULL | 'not_started' | 掌握度 |
| estimated_study_time | INT | | 30 | 预计学习时间（分钟） |
| order_index | INT | NOT NULL | 0 | 排序 |
| is_template | BOOLEAN | NOT NULL | false | 是否为模板 |
| template_id | UUID | | NULL | 模板ID |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE INDEX idx_knowledge_points_stage_id ON knowledge_points(stage_id);
CREATE INDEX idx_knowledge_points_difficulty ON knowledge_points(difficulty);
CREATE INDEX idx_knowledge_points_mastery_level ON knowledge_points(mastery_level);
CREATE INDEX idx_knowledge_points_tags ON knowledge_points USING GIN(tags);
```

#### 3.2.4 learning_records（学习记录表）
存储用户学习行为记录

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 记录ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| knowledge_point_id | UUID | REFERENCES knowledge_points(id) | - | 知识点ID |
| action | VARCHAR(50) | NOT NULL | - | 动作(start/complete/pause/resume) |
| duration | INT | | 0 | 持续时长（秒） |
| details | JSONB | | '{}' | 详细信息 |
| device_type | VARCHAR(50) | | NULL | 设备类型 |
| ip_address | VARCHAR(50) | | NULL | IP地址 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |

**索引**：
```sql
CREATE INDEX idx_learning_records_user_id ON learning_records(user_id);
CREATE INDEX idx_learning_records_knowledge_point_id ON learning_records(knowledge_point_id);
CREATE INDEX idx_learning_records_action ON learning_records(action);
CREATE INDEX idx_learning_records_created_at ON learning_records(created_at);
```

### 3.3 AI对话相关表

#### 3.3.1 chat_sessions（对话会话表）
存储AI对话会话

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 会话ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| knowledge_point_id | UUID | REFERENCES knowledge_points(id) | - | 知识点ID |
| title | VARCHAR(200) | | NULL | 会话标题 |
| status | VARCHAR(20) | NOT NULL | 'active' | 状态(active/completed) |
| question_type | VARCHAR(50) | | NULL | 当前问题类型 |
| current_question_number | INT | NOT NULL | 1 | 当前问题序号 |
| total_questions | INT | NOT NULL | 4 | 总问题数 |
| model_used | VARCHAR(100) | | NULL | 使用的模型 |
| token_used | INT | NOT NULL | 0 | Token使用量 |
| started_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 开始时间 |
| ended_at | TIMESTAMP | | NULL | 结束时间 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE INDEX idx_chat_sessions_user_id ON chat_sessions(user_id);
CREATE INDEX idx_chat_sessions_knowledge_point_id ON chat_sessions(knowledge_point_id);
CREATE INDEX idx_chat_sessions_status ON chat_sessions(status);
CREATE INDEX idx_chat_sessions_created_at ON chat_sessions(created_at);
```

#### 3.3.2 chat_messages（对话消息表）
存储对话消息

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 消息ID |
| session_id | UUID | REFERENCES chat_sessions(id) | - | 会话ID |
| role | VARCHAR(20) | NOT NULL | - | 角色(user/assistant/system) |
| content | TEXT | NOT NULL | - | 消息内容 |
| content_type | VARCHAR(50) | NOT NULL | 'text' | 内容类型(text/image/file) |
| question_type | VARCHAR(50) | | NULL | 问题类型 |
| feedback_type | VARCHAR(50) | | NULL | 反馈类型(correct/partial/incorrect) |
| is_skipped | BOOLEAN | NOT NULL | false | 是否跳过 |
| is_hinted | BOOLEAN | NOT NULL | false | 是否使用了提示 |
| metadata | JSONB | | '{}' | 元数据 |
| order_index | INT | NOT NULL | 0 | 排序 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |

**索引**：
```sql
CREATE INDEX idx_chat_messages_session_id ON chat_messages(session_id);
CREATE INDEX idx_chat_messages_session_order ON chat_messages(session_id, order_index);
CREATE INDEX idx_chat_messages_role ON chat_messages(role);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at);
```

### 3.4 复习相关表

#### 3.4.1 review_plans（复习计划表）
存储用户复习计划

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 计划ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| knowledge_point_id | UUID | REFERENCES knowledge_points(id) | - | 知识点ID |
| next_review_date | DATE | NOT NULL | - | 下次复习日期 |
| review_count | INT | NOT NULL | 0 | 复习次数 |
| mastery_level | VARCHAR(20) | NOT NULL | 'basic' | 掌握度(basic/deep) |
| algorithm_type | VARCHAR(50) | NOT NULL | 'default' | 使用的算法 |
| easiness_factor | DECIMAL(5,2) | NOT NULL | 2.5 | 难度系数 |
| interval_days | INT | NOT NULL | 1 | 间隔天数 |
| repetitions | INT | NOT NULL | 0 | 重复次数 |
| last_review_at | TIMESTAMP | | NULL | 上次复习时间 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE INDEX idx_review_plans_user_id ON review_plans(user_id);
CREATE INDEX idx_review_plans_knowledge_point_id ON review_plans(knowledge_point_id);
CREATE INDEX idx_review_plans_next_review_date ON review_plans(next_review_date);
CREATE INDEX idx_review_plans_mastery_level ON review_plans(mastery_level);
```

#### 3.4.2 review_tasks（复习任务表）
存储具体的复习任务

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 任务ID |
| plan_id | UUID | REFERENCES review_plans(id) | - | 计划ID |
| scheduled_date | DATE | NOT NULL | - | 计划日期 |
| review_type | VARCHAR(50) | NOT NULL | - | 复习类型(recall/compare/apply/summarize) |
| review_content | TEXT | | NULL | 复习内容 |
| status | VARCHAR(20) | NOT NULL | 'pending' | 状态(pending/completed/skipped) |
| result | VARCHAR(50) | | NULL | 结果(perfect/good/fair/poor) |
| user_response | TEXT | | NULL | 用户回答 |
| completed_at | TIMESTAMP | | NULL | 完成时间 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE INDEX idx_review_tasks_plan_id ON review_tasks(plan_id);
CREATE INDEX idx_review_tasks_scheduled_date ON review_tasks(scheduled_date);
CREATE INDEX idx_review_tasks_status ON review_tasks(status);
```

### 3.5 成就系统表

#### 3.5.1 achievements（成就表）
存储成就定义

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 成就ID |
| code | VARCHAR(50) | UNIQUE NOT NULL | - | 成就代码 |
| name | VARCHAR(100) | NOT NULL | - | 成就名称 |
| description | TEXT | | NULL | 成就描述 |
| icon_url | VARCHAR(500) | | NULL | 图标URL |
| category | VARCHAR(50) | NOT NULL | 'learning' | 分类 |
| condition_type | VARCHAR(50) | NOT NULL | - | 条件类型 |
| condition_value | JSONB | NOT NULL | '{}' | 条件值 |
| reward_type | VARCHAR(50) | | NULL | 奖励类型 |
| reward_value | INT | | 0 | 奖励值 |
| is_active | BOOLEAN | NOT NULL | true | 是否激活 |
| order_index | INT | NOT NULL | 0 | 排序 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE UNIQUE INDEX idx_achievements_code ON achievements(code);
CREATE INDEX idx_achievements_category ON achievements(category);
CREATE INDEX idx_achievements_is_active ON achievements(is_active);
```

#### 3.5.2 user_achievements（用户成就表）
存储用户解锁的成就

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| achievement_id | UUID | REFERENCES achievements(id) | - | 成就ID |
| progress | DECIMAL(5,2) | NOT NULL | 0.0 | 进度 |
| unlocked_at | TIMESTAMP | | NULL | 解锁时间 |
| metadata | JSONB | | '{}' | 元数据 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引**：
```sql
CREATE UNIQUE INDEX idx_user_achievements_user_achievement ON user_achievements(user_id, achievement_id);
CREATE INDEX idx_user_achievements_user_id ON user_achievements(user_id);
CREATE INDEX idx_user_achievements_unlocked_at ON user_achievements(unlocked_at);
```

### 3.6 通知相关表

#### 3.6.1 notifications（通知表）
存储通知记录

| 字段名 | 数据类型 | 约束 | 默认值 | 说明 |
|--------|---------|------|--------|------|
| id | UUID | PRIMARY KEY | gen_random_uuid() | 通知ID |
| user_id | UUID | REFERENCES users(id) | - | 用户ID |
| type | VARCHAR(50) | NOT NULL | - | 通知类型 |
| title | VARCHAR(200) | NOT NULL | - | 标题 |
| content | TEXT | NOT NULL | - | 内容 |
| data | JSONB | | '{}' | 额外数据 |
| is_read | BOOLEAN | NOT NULL | false | 是否已读 |
| read_at | TIMESTAMP | | NULL | 阅读时间 |
| sent_at | TIMESTAMP | | NULL | 发送时间 |
| created_at | TIMESTAMP | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |

**索引**：
```sql
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
```

## 四、索引策略

### 4.1 索引设计原则
- 主键索引：自动创建
- 唯一索引：确保数据唯一性
- 普通索引：优化查询性能
- 复合索引：优化多条件查询
- 部分索引：针对特定条件优化

### 4.2 查询优化建议

#### 4.2.1 常用查询模式
```sql
-- 获取用户活跃学习路线
SELECT * FROM learning_routes 
WHERE user_id = ? AND status = 'active'
ORDER BY created_at DESC;

-- 获取今日复习任务
SELECT rt.* FROM review_tasks rt
JOIN review_plans rp ON rt.plan_id = rp.id
WHERE rp.user_id = ? 
  AND rt.scheduled_date = CURRENT_DATE
  AND rt.status = 'pending'
ORDER BY rt.created_at;

-- 获取用户学习统计
SELECT 
    date,
    SUM(study_duration) as total_duration,
    SUM(knowledge_points_learned) as total_points
FROM user_statistics
WHERE user_id = ?
  AND date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY date
ORDER BY date;
```

#### 4.2.2 查询优化技巧
- 使用EXPLAIN ANALYZE分析查询计划
- 避免SELECT *，只查询需要的字段
- 使用LIMIT限制结果集大小
- 合理使用JOIN，避免N+1查询
- 适当使用物化视图优化复杂查询

## 五、数据分区

### 5.1 分区策略

#### 5.1.1 大表分区
- `learning_records`：按月份分区
- `user_statistics`：按月份分区
- `chat_messages`：按月份分区
- `notifications`：按月份分区

#### 5.1.2 分区示例
```sql
-- learning_records 按月份分区
CREATE TABLE learning_records (
    -- 字段定义
) PARTITION BY RANGE (created_at);

-- 创建分区
CREATE TABLE learning_records_202601 
PARTITION OF learning_records
FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
```

## 六、数据安全

### 6.1 敏感数据处理

#### 6.1.1 加密字段
- `password_hash`：使用bcrypt加密
- `phone`：存储时加密，查询时解密
- `email`：存储时加密，查询时解密
- `token`：JWT加密

#### 6.1.2 数据脱敏
- 日志输出时脱敏
- 数据导出时脱敏
- 测试环境使用假数据

### 6.2 数据备份

#### 6.2.1 备份策略
- 全量备份：每日凌晨2点
- 增量备份：每小时一次
- 异地备份：跨区域备份
- 保留时间：30天

#### 6.2.2 恢复演练
- 每周进行恢复演练
- 确保备份可用
- 记录恢复时间

## 七、数据迁移

### 7.1 迁移工具
使用Alembic进行数据库版本管理

### 7.2 迁移流程
```
1. 编写迁移脚本
2. 在测试环境测试
3. 在预发布环境测试
4. 备份生产数据
5. 执行生产环境迁移
6. 验证数据完整性
7. 回滚预案
```

## 八、监控与维护

### 8.1 数据库监控
- 连接数监控
- 慢查询监控
- 表大小监控
- 索引使用监控
- 备份状态监控

### 8.2 维护任务
- 定期VACUUM ANALYZE
- 索引重建
- 表统计信息更新
- 日志清理

## 九、附录

### 9.1 数据库配置
- 连接池配置
- 慢查询阈值
- 备份配置
- 监控配置

### 9.2 常用SQL脚本
- 查询优化脚本
- 数据修复脚本
- 统计分析脚本