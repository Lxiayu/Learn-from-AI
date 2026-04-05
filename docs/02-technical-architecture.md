# 技术架构设计文档

## 文档信息
- **项目名称**：智学AI（LearnAI）
- **版本**：v2.2
- **文档更新日期**：2026-04-05
- **技术负责人**：技术团队
- **开发周期**：5-6个月

## 一、文档定位

本文件采用“双轨架构”描述项目技术路线：

- **当前实施架构**：本地优先，使用 `Flutter + 本地 FastAPI + 本地数据库 + 本地可替换 AI Provider`
- **目标生产架构**：未来迁移到 `CloudBase Run / 云函数 / 云端数据库 / CloudBase AI`

这意味着：

- 当前开发不以 CloudBase 为前置依赖
- 当前阶段优先验证“学习闭环 MVP”是否成立
- 所有接口、领域模型和同步边界都按“未来可迁移”来设计
- 文档里涉及 CloudBase 的部分默认表示**未来目标生产架构**，而不是当前开发要求

---

## 二、架构目标

### 2.1 设计原则

- **本地优先**：当前阶段优先在本地完成学习目标、路线、会话、复习的闭环验证
- **可迁移性**：API 边界、领域模型和存储字段从一开始就为未来迁移预留
- **高性能**：响应时间目标小于 2 秒，本地优先返回关键状态
- **离线能力**：核心学习体验在网络不稳定甚至离线时仍可继续
- **低耦合**：前端、后端、AI Provider、存储层各自独立，可单独替换
- **安全渐进**：当前阶段先保证本地安全闭环，目标生产阶段再对齐云端安全体系
- **成本控制**：开发阶段避免过早引入复杂云依赖，生产阶段再使用云端弹性能力

### 2.2 当前阶段目标

- 打通学习闭环 MVP
- 让前端从 mock 状态切换到真实 API
- 建立本地数据库与后端业务真相层
- 为未来迁移到 CloudBase 保持结构稳定

### 2.3 当前阶段非目标

- 不要求当前接入 CloudBase
- 不要求当前实现多设备同步
- 不要求当前实现完整账号体系
- 不要求当前引入推送、向量检索和复杂任务队列
- 不要求当前以生产级高可用架构部署

---

## 三、技术选型

### 3.1 前端技术栈

| 技术 | 版本 | 用途 | 说明 |
|------|------|------|------|
| Flutter | 3.41+ | 跨平台前端 | 一套代码运行在移动端与 Web |
| Dart | 3.11+ | 编程语言 | Flutter 官方语言 |
| Riverpod | Latest | 状态管理 | 统一页面状态、会话状态、设置状态 |
| GoRouter | Latest | 路由管理 | 管理一级页与二级页导航 |
| Dio | Latest | HTTP 客户端 | 对接本地 FastAPI 与未来云端 API |
| SQFlite | Latest | 结构化本地存储 | 保存路线、进度、复习任务摘要 |
| Hive | Latest | 半结构化本地存储 | 保存聊天草稿、会话快照等 |
| SharedPreferences | Latest | 配置存储 | 保存语言、主题和开关类设置 |

### 3.2 当前实施阶段后端技术栈

| 技术 | 版本 | 用途 | 说明 |
|------|------|------|------|
| Python | 3.11+ | 后端开发语言 | AI 生态成熟，适合业务编排 |
| FastAPI | 0.100+ | Web 框架 | 高性能、易调试、自动文档生成 |
| SQLAlchemy / SQLModel | Latest | ORM / Repository 支撑 | 统一领域模型与数据访问 |
| SQLite | Latest | 当前主数据库 | 零运维，便于本地开发与测试 |
| PostgreSQL | 15+ | 可选增强数据库 | 当开发阶段需要更强约束时可切换 |

### 3.3 AI 技术栈

| 技术 | 用途 | 说明 |
|------|------|------|
| AI Provider Abstraction | 模型抽象层 | 不把具体模型厂商写死在业务层 |
| Local / Replaceable Provider | 当前阶段模型接入 | 先服务于本地调试与闭环验证 |
| LangChain | 可选编排层 | 管理 Prompt、链路和会话上下文 |
| CloudBase AI | 未来云端模型能力 | 作为迁移后的目标接入方式 |

### 3.4 目标生产阶段基础设施

| 技术 | 用途 | 说明 |
|------|------|------|
| CloudBase Run | 容器托管 | 未来承载 FastAPI 正式服务 |
| CloudBase 云函数 | 异步/短任务 | 未来承载通知、定时任务、轻量 AI 任务 |
| CloudBase MySQL | 关系型数据 | 未来承载结构化业务数据 |
| CloudBase 文档数据库 | 文档型数据 | 未来承载对话摘要、日志等非结构化数据 |
| CloudBase 存储 / CDN | 文件与分发 | 未来承载头像、附件、静态资源 |
| CloudBase 监控 / 日志 | 运维能力 | 未来承载监控、告警与日志聚合 |

---

## 四、系统架构

### 4.1 当前实施架构

```text
Flutter App
  ├─ Presentation / Components
  ├─ Riverpod State
  ├─ Local Cache (SQFlite / Hive / SharedPreferences)
  └─ API Client (Dio)
            ↓
        Local FastAPI
  ├─ Learning Goal Service
  ├─ Roadmap Service
  ├─ Session Service
  ├─ Review Service
  ├─ Analytics Aggregation
  └─ AI Provider Adapter
            ↓
      SQLite / Optional Postgres
```

### 4.2 目标生产架构

```text
Flutter App
  ├─ Local Cache
  └─ API Client
            ↓
 CloudBase Run (FastAPI)
  ├─ Core Business APIs
  ├─ Sync APIs
  └─ AI Orchestration
            ↓
 CloudBase 云函数 / 数据层 / AI 能力
```

### 4.3 双轨关系

- 当前实施架构用于快速验证功能、调试和本地联调
- 目标生产架构用于正式部署、同步、弹性扩缩容和云端运维
- 两者共享同一套 API 语义、领域模型和数据字段约束

---

## 五、服务边界

### 5.1 Flutter 客户端职责

- 页面渲染与交互
- 用户输入与即时反馈
- 本地轻量缓存和草稿保存
- 离线恢复入口
- 调用后端 API 获取真实业务状态

客户端不直接承载复杂业务真相，不直接绕过 API 操作核心业务数据。

### 5.2 本地 FastAPI 职责

- 创建学习目标
- 生成学习路线
- 确认路线并进入学习
- 生成当前任务卡
- 推进学习会话
- 处理提示、补讲、再次解释
- 记录掌握度结果
- 生成与完成复习任务
- 提供当前会话与中断恢复能力

### 5.3 AI Provider 层职责

- 路线草案生成
- 提问生成
- 补讲文本生成
- 提示生成
- 会话上下文裁剪与编排

该层必须以接口形式存在，避免未来迁移时重写业务逻辑。

### 5.4 Repository / Storage 层职责

- 屏蔽 SQLite 与未来云端存储差异
- 屏蔽当前本地 Provider 与未来云端 AI 差异
- 为领域服务提供稳定读写接口

---

## 六、核心数据策略

### 6.1 前端本地体验数据

这类数据服务于体验，不作为业务真相：

- 当前输入草稿
- 最近打开页面状态
- 今日任务摘要缓存
- 语言、主题、提醒开关
- 网络状态与同步偏好

### 6.2 后端业务真相数据

这类数据由后端主库维护：

- `LearningGoal`
- `Roadmap`
- `RoadmapStage`
- `KnowledgeNodeProgress`
- `LearningSession`
- `SessionTurn`
- `MasteryAssessment`
- `ReviewTask`
- `ReviewResult`

### 6.3 统一字段约束

所有核心领域实体从当前阶段起统一保留：

- `id`
- `created_at`
- `updated_at`
- `version`
- `status`
- `source`
- `sync_status`

这组字段用于未来迁移、同步与审计。

### 6.4 访问策略

- 当前阶段查看关键学习状态优先读本地前端缓存
- 业务真相变化以本地 FastAPI 返回结果为准
- 当前阶段不开放复杂多端同步
- 目标生产阶段再增加云同步、冲突解决与备份恢复

---

## 七、学习闭环 MVP

### 7.1 当前阶段必须打通的链路

1. 用户创建学习目标
2. 系统生成学习路线
3. 用户确认路线
4. 系统生成当前任务卡
5. 用户进入学习会话
6. 系统处理回答、提示、补讲与掌握度
7. 系统生成复习任务
8. 用户下次进入时可恢复当前状态

### 7.2 P0 API

```text
POST /learning-goals
POST /roadmaps/generate
POST /roadmaps/{id}/confirm
GET  /sessions/current
POST /sessions/{id}/answer
POST /sessions/{id}/hint
POST /sessions/{id}/explain-again
POST /sessions/{id}/complete
GET  /reviews/today
POST /reviews/{id}/complete
```

### 7.3 当前阶段明确不做

- CloudBase 接入
- 多设备同步
- 正式推送通知
- RAG 与向量检索
- 完整账号体系
- 复杂异步任务编排

---

## 八、AI 架构

### 8.1 当前阶段

当前 AI 架构采用“业务层 + Provider 抽象层”模式：

```text
Session / Roadmap Logic
        ↓
AI Provider Interface
        ↓
Local or Replaceable Provider
```

这样做的目标是：

- 先验证学习逻辑，不被云平台绑定
- 允许部分能力以 mock 或固定策略先跑通
- 后续接 CloudBase AI 时仅替换 Provider 实现

### 8.2 目标生产阶段

未来迁移后：

- 路线生成、补讲、问题生成等能力可接 CloudBase AI
- 轻量异步任务可迁入云函数
- 更复杂的检索与推荐能力可后置到云端能力层

---

## 九、安全与稳定性

### 9.1 当前阶段重点

- 本地敏感信息最小化存储
- API 参数校验与错误边界清晰
- Web / 移动端运行时异常必须归零
- 学习闭环主流程一旦失败，要有明确错误反馈和恢复路径

### 9.2 目标生产阶段重点

- HTTPS 传输
- 云端访问控制与日志审计
- 云端存储加密
- 服务监控与告警

---

## 十、性能策略

### 10.1 当前阶段

- 优先优化本地数据库访问
- 批量写入会话和复习结果
- 减少重复请求与无效重建
- 通过本地缓存加快 Home / Review / Chat 首屏恢复

### 10.2 目标生产阶段

- 使用云端弹性扩缩容
- API 层缓存与静态资源 CDN
- 查询优化与云端热点数据缓存

---

## 十一、环境划分

| 环境 | 用途 | 部署方式 |
|------|------|---------|
| 本地开发环境 | 日常开发 | Flutter + 本地 FastAPI + 本地数据库 |
| 本地集成环境 | 联调与功能测试 | Flutter + 本地 FastAPI + 本地数据库 / Docker |
| 预发布环境 | 迁移验证 | 未来 CloudBase 预发布环境 |
| 生产环境 | 正式服务 | 未来 CloudBase 生产环境 |

---

## 十二、迁移策略

### 12.1 迁移原则

- 先稳定业务接口，再迁移部署形态
- 先迁移后端与数据适配层，再迁移云端能力
- 前端页面结构和主要状态流尽量不因迁云而重写

### 12.2 迁移顺序

1. 固化本地 FastAPI API 语义
2. 固化领域模型和数据库字段
3. 将 FastAPI 部署目标切换到 CloudBase Run
4. 将数据库从本地主库映射到云端数据层
5. 将 AI Provider 替换为 CloudBase AI 实现
6. 最后补云同步、推送和多端恢复

---

## 十三、主要风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|---------|
| 本地实现与未来迁移脱节 | 高 | 统一 API 边界、统一字段约束、分离 Provider |
| 前端继续依赖 mock 数据 | 高 | 下一阶段优先接本地 FastAPI |
| MVP 范围失控 | 高 | 当前只做学习闭环，不做云同步与推荐系统 |
| 本地数据损坏 | 中 | 增加导出、重建和最小备份能力 |
| AI 输出不稳定 | 高 | Provider 抽象、降级策略、必要时回退固定规则 |

---

## 十四、推荐结论

当前项目应采用如下策略：

- **现在**：本地优先实施，快速打通学习闭环 MVP
- **以后**：在接口和模型不大改的前提下迁移到 CloudBase

接下来的工程重点不再是继续堆页面，而是：

- 建立本地 FastAPI
- 建立本地数据库
- 让前端对接真实状态流
- 完成学习目标、路线、会话、复习的真实闭环
