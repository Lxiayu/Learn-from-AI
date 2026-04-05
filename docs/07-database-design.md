# 数据库设计文档

## 文档信息
- **项目名称**：智学AI（LearnAI）
- **版本**：v1.1
- **文档更新日期**：2026-04-05
- **数据库负责人**：数据库工程师

## 一、文档定位

本文件描述项目在“双轨架构”下的数据库策略：

- **当前实施阶段**：以后端本地主库为核心，优先使用 `SQLite`
- **目标生产阶段**：未来迁移到 CloudBase 数据层

这里的重点不是现在就确定所有云端细节，而是确保：

- 当前本地实现能支撑学习闭环 MVP
- 领域模型和字段设计未来可迁移
- 前端本地缓存与后端业务真相分工清晰

---

## 二、数据库设计原则

- **本地优先**：当前阶段优先保证本地可运行、可联调、可测试
- **业务真相集中**：核心业务状态由后端主库维护，不由前端页面拼装
- **模型稳定**：先稳定领域实体，再决定未来云端如何映射
- **可迁移**：字段和关系设计避免强绑定当前数据库特性
- **体验分层**：前端本地缓存与后端主库分层管理

---

## 三、数据库选型

### 3.1 当前实施阶段

| 类型 | 技术 | 用途 |
|------|------|------|
| 后端主数据库 | SQLite | 学习目标、路线、会话、复习、统计等业务真相数据 |
| 前端结构化缓存 | SQFlite | 路线摘要、今日任务、复习摘要、本地快照 |
| 前端半结构化缓存 | Hive | 会话草稿、聊天快照、页面局部状态 |
| 前端配置存储 | SharedPreferences | 语言、主题、提醒、同步偏好 |

### 3.2 目标生产阶段

| 类型 | 技术 | 用途 |
|------|------|------|
| 关系型数据库 | CloudBase MySQL | 用户、学习路线、复习任务、统计数据 |
| 文档型数据库 | CloudBase 文档数据库 | 对话摘要、学习日志、补讲记录等 |
| 对象存储 | CloudBase 存储 | 头像、附件、导出文件、后续多媒体资源 |

---

## 四、数据分层

### 4.1 前端本地体验数据

前端本地数据用于体验优化，不作为业务真相：

- 当前输入草稿
- 最近页面状态
- 今日任务列表缓存
- 上次学习入口
- 语言、主题和提醒设置

### 4.2 后端业务真相数据

以下数据由本地后端主库维护：

- `LearningGoal`
- `Roadmap`
- `RoadmapStage`
- `KnowledgeNodeProgress`
- `LearningSession`
- `SessionTurn`
- `MasteryAssessment`
- `ReviewTask`
- `ReviewResult`
- `UserPreference`
- `UserStatistic`

---

## 五、核心实体模型

### 5.1 LearningGoal

用于记录用户要学什么、想达到什么结果以及当前基础。

关键字段：

- `id`
- `topic`
- `target_outcome`
- `current_level`
- `study_pace`
- `evaluation_preference`
- `status`
- `created_at`
- `updated_at`

### 5.2 Roadmap

用于保存学习路线整体信息。

关键字段：

- `id`
- `learning_goal_id`
- `title`
- `summary`
- `status`
- `current_stage_index`
- `total_stage_count`
- `estimated_duration_minutes`
- `created_at`
- `updated_at`

### 5.3 RoadmapStage

用于表示路线中的阶段节点。

关键字段：

- `id`
- `roadmap_id`
- `order_index`
- `title`
- `objective`
- `entry_criteria`
- `completion_criteria`
- `status`
- `created_at`
- `updated_at`

### 5.4 KnowledgeNodeProgress

用于记录用户对某个知识点的掌握与进度。

关键字段：

- `id`
- `roadmap_stage_id`
- `node_title`
- `mastery_level`
- `last_session_id`
- `next_review_at`
- `status`
- `created_at`
- `updated_at`

### 5.5 LearningSession

用于保存一次引导式学习会话。

关键字段：

- `id`
- `roadmap_id`
- `current_node_id`
- `session_phase`
- `task_card_snapshot`
- `status`
- `started_at`
- `completed_at`
- `created_at`
- `updated_at`

### 5.6 SessionTurn

用于保存会话中的一轮问答。

关键字段：

- `id`
- `session_id`
- `step_type`
- `assistant_prompt`
- `user_answer`
- `feedback_type`
- `hint_used`
- `created_at`

### 5.7 MasteryAssessment

用于保存掌握度判断。

关键字段：

- `id`
- `session_id`
- `knowledge_node_id`
- `recognition_score`
- `explanation_score`
- `example_score`
- `transfer_score`
- `decision`
- `created_at`
- `updated_at`

### 5.8 ReviewTask

用于保存复习任务。

关键字段：

- `id`
- `knowledge_node_id`
- `source_session_id`
- `due_at`
- `difficulty_tag`
- `status`
- `created_at`
- `updated_at`

### 5.9 ReviewResult

用于保存复习结果。

关键字段：

- `id`
- `review_task_id`
- `result`
- `mistake_type`
- `next_review_at`
- `created_at`

---

## 六、统一字段约束

所有核心业务实体从当前阶段起统一保留以下字段：

- `id`
- `created_at`
- `updated_at`
- `version`
- `status`
- `source`
- `sync_status`

字段说明：

- `version`：未来用于并发更新和迁移控制
- `source`：标识数据来源，如 `local_api`、`local_seed`
- `sync_status`：当前可默认 `local_only`，未来扩展为 `pending`、`synced`、`conflict`

---

## 七、当前阶段关系模型

```text
LearningGoal 1 ── N Roadmap
Roadmap 1 ── N RoadmapStage
RoadmapStage 1 ── N KnowledgeNodeProgress
Roadmap 1 ── N LearningSession
LearningSession 1 ── N SessionTurn
LearningSession 1 ── N MasteryAssessment
KnowledgeNodeProgress 1 ── N ReviewTask
ReviewTask 1 ── N ReviewResult
```

---

## 八、前端缓存与后端主库映射

| 数据 | 前端缓存 | 后端主库 | 说明 |
|------|---------|---------|------|
| 当前学习路线摘要 | SQFlite | Roadmap / RoadmapStage | 前端只缓存摘要与最近状态 |
| 今日任务 | SQFlite | ReviewTask | 前端缓存列表，真相在后端 |
| 当前会话草稿 | Hive | LearningSession / SessionTurn | 草稿只本地保存，提交后写主库 |
| 语言与设置 | SharedPreferences | UserPreference | 当前阶段可仅保留前端；后续再决定是否同步 |
| 学习统计卡片 | SQFlite | UserStatistic | 前端显示缓存，后端定期聚合 |

---

## 九、迁移映射

| 当前本地主库实体 | 目标生产落点 | 说明 |
|------------------|-------------|------|
| LearningGoal | CloudBase MySQL | 结构化主数据 |
| Roadmap | CloudBase MySQL | 结构化主数据 |
| RoadmapStage | CloudBase MySQL | 结构化主数据 |
| KnowledgeNodeProgress | CloudBase MySQL | 结构化主数据 |
| LearningSession | CloudBase 文档数据库 / MySQL | 视写入规模与查询方式决定 |
| SessionTurn | CloudBase 文档数据库 | 更适合文档型记录 |
| MasteryAssessment | CloudBase MySQL | 结构化评分数据 |
| ReviewTask | CloudBase MySQL | 结构化任务数据 |
| ReviewResult | CloudBase MySQL | 结构化结果数据 |

---

## 十、当前阶段数据库约束

- 先以 SQLite 兼容子集实现，不依赖复杂数据库特性
- 避免当前阶段引入 Redis、MongoDB、向量库作为前置条件
- API 层而不是前端页面负责事务边界
- 会话推进、复习生成和路线确认必须写入后端主库
- 前端刷新后能从后端或本地快照恢复当前状态

---

## 十一、后续扩展方向

当前阶段先不做，但需在模型层预留：

- 多设备同步字段
- 云端冲突解决字段
- 用户登录与租户隔离字段
- 推荐阅读与分支探索记录
- 向量化内容索引字段

---

## 十二、推荐结论

数据库层当前应采用以下策略：

- 后端主库：`SQLite`
- 前端本地缓存：`SQFlite + Hive + SharedPreferences`
- 未来迁移：按实体映射迁移到 CloudBase 数据层

这样可以保证：

- 当前开发快速落地
- 业务真相集中且可测试
- 后续迁移不必重做领域模型
