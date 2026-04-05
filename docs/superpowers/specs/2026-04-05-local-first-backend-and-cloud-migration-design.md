# 本地优先后端与 CloudBase 迁移设计

## 文档信息
- 项目：智学AI（LearnAI）
- 日期：2026-04-05
- 状态：Draft
- 目标：在保留 CloudBase 作为未来生产目标的前提下，将当前实施阶段调整为“本地优先后端”

## 1. 背景与决策

当前前端页面和主要交互已经具备进入功能实现阶段的条件，但学习产品的核心能力还停留在前端状态与原型层。为了真正验证“学习目标创建 -> 路线生成 -> 会话推进 -> 复习任务生成 -> 中断恢复”这一主闭环，项目需要尽快具备可运行的后端和持久化数据层。

虽然项目的长期目标仍然是迁移到 CloudBase，但当前阶段直接以 CloudBase 为开发起点会带来几个问题：

- 本地联调成本高，问题定位链路长
- 云端能力、鉴权、部署和资源配置会分散 MVP 验证注意力
- Web 调试与多端联调更容易受到云端接入方式影响
- 当前最需要验证的是业务闭环是否成立，而不是云平台配置是否完善

因此本次决策为：

- 当前实施阶段采用“本地优先后端”方案
- 目标生产阶段继续保留 CloudBase 迁移方向
- 从当前开始就以“可迁移接口、可迁移数据模型、可迁移服务边界”来设计本地实现

## 2. 目标与非目标

### 2.1 当前阶段目标

- 建立可运行的本地 FastAPI 后端
- 建立可持久化的本地数据层
- 打通学习闭环 MVP
- 让前端与真实 API 和真实状态流对接
- 为未来迁移 CloudBase 保留清晰边界

### 2.2 当前阶段非目标

- 不要求当前接入 CloudBase
- 不要求现在实现多设备同步
- 不要求现在实现完整账号体系
- 不要求现在实现推送、对象存储、向量检索和复杂任务队列
- 不要求现在实现正式生产级高可用部署

## 3. 双轨架构说明

本项目的架构将分为两个视角描述：

### 3.1 当前实施架构

- Flutter 前端
- 本地状态管理与本地缓存
- 本地 FastAPI 服务
- 本地关系型数据库
- 本地可替换 AI Provider 层

这个阶段的重点是：低成本联调、快速验证学习闭环、稳定调试、减少外部依赖。

### 3.2 目标生产架构

- Flutter 前端
- 云端 API 服务
- CloudBase Run / 云函数
- CloudBase 数据能力
- CloudBase AI 与后续云端同步能力

这个阶段的重点是：正式部署、云端同步、弹性扩展、多端共享和运维能力。

### 3.3 两条轨道的关系

- 当前实施架构不是未来生产架构的否定，而是其前置验证阶段
- 当前阶段完成后，优先迁移部署层与数据适配层，而不是推翻业务接口与前端结构
- 所有核心领域对象、API 边界和状态机，都应在本地阶段先稳定下来

## 4. 当前实施架构设计

### 4.1 客户端

Flutter 前端继续负责：

- 页面与交互
- Riverpod 状态层
- 草稿状态、离线状态和 UI 反馈
- 本地轻量缓存和会话恢复入口

客户端不直接承载复杂业务规则，不直接以数据库为业务真相来源。

### 4.2 本地后端

本地后端使用 FastAPI，承担以下职责：

- 学习目标创建与管理
- 学习路线生成与确认
- 当前任务卡生成
- 会话推进与回答处理
- 补讲、提示、再次解释
- 掌握度记录
- 复习任务生成与完成
- 中断恢复与当前会话读取

本地后端是当前阶段的业务真相层。

### 4.3 数据库

当前阶段建议：

- 后端主数据库：SQLite 起步
- 前端本地存储：继续保留 SQFlite / Hive / SharedPreferences 角色划分

原因：

- SQLite 对 MVP 来说足够轻量，便于本地开发和自动化测试
- 先打通业务闭环，再评估是否需要开发阶段切到本地 PostgreSQL
- 前端本地存储仍然有价值，因为产品本身要求本地优先与离线恢复

### 4.4 AI Provider 抽象

当前阶段不把任何云平台或厂商模型直接写死在业务层中。后端应先抽象：

- 对话生成接口
- 问题生成接口
- 路线生成接口
- 补讲与提示接口

MVP 可以先接一个本地可用 Provider，或者以 mock/固定策略驱动部分闭环。未来迁移到 CloudBase AI 时，仅替换 Provider 实现。

## 5. 领域边界与可迁移原则

### 5.1 服务边界

必须从一开始明确以下边界：

- Frontend：负责呈现和交互，不负责业务真相
- API Service：负责业务规则和状态推进
- Repository / Storage：负责底层读写与持久化
- AI Provider：负责大模型能力访问

### 5.2 数据边界

必须区分两类数据：

#### 前端本地体验数据

- 当前输入草稿
- 最近打开的页面状态
- 今日任务摘要缓存
- 语言和主题设置
- 同步开关与本地偏好

#### 后端业务真相数据

- LearningGoal
- Roadmap
- KnowledgeNodeProgress
- LearningSession
- SessionTurn
- MasteryAssessment
- ReviewTask
- ReviewResult

未来迁移时，应优先迁移后端业务真相数据；前端缓存数据可按需重建。

### 5.3 可迁移字段约束

所有核心领域实体从当前阶段开始必须统一具备：

- `id`
- `created_at`
- `updated_at`
- `version`
- `status`
- `source`
- `sync_status`（当前可默认 local）

这样可减少未来迁移到云端时的数据兼容成本。

## 6. 学习闭环 MVP 范围

当前阶段只打通最核心的学习闭环：

1. 创建学习目标
2. 生成学习路线
3. 确认学习路线
4. 进入当前任务卡
5. 开始一次学习会话
6. 处理回答、提示、补讲与掌握度记录
7. 结束会话并生成复习任务
8. 下一次进入时恢复当前状态

### 6.1 P0 API

建议优先实现以下接口：

- `POST /learning-goals`
- `POST /roadmaps/generate`
- `POST /roadmaps/{id}/confirm`
- `GET /sessions/current`
- `POST /sessions/{id}/answer`
- `POST /sessions/{id}/hint`
- `POST /sessions/{id}/explain-again`
- `POST /sessions/{id}/complete`
- `GET /reviews/today`
- `POST /reviews/{id}/complete`

### 6.2 当前阶段明确不做

- 真正的云同步
- CloudBase 接入
- 向量检索与 RAG
- 推送通知
- 复杂权限体系
- 多租户与组织管理
- 生产级异步任务编排

## 7. 文档更新方案

### 7.1 新增文档

新增本文件，作为本次架构转向的决策记录。

### 7.2 修订文档

需要修订以下核心文档：

#### [02-technical-architecture.md](/Users/xia/program/Learn/docs/02-technical-architecture.md)

调整为双轨架构表达：

- 当前实施架构：本地优先
- 目标生产架构：CloudBase 迁移目标

#### [07-database-design.md](/Users/xia/program/Learn/docs/07-database-design.md)

补充：

- 当前开发数据库方案
- 前端本地存储与后端主库分工
- 本地模型到未来云端模型的迁移映射

#### [09-deployment-guide.md](/Users/xia/program/Learn/docs/09-deployment-guide.md)

调整为两阶段部署：

- 当前开发与测试部署
- 未来云端迁移部署

#### [2026-04-04-feature-gap-and-priority-analysis.md](/Users/xia/program/Learn/docs/superpowers/specs/2026-04-04-feature-gap-and-priority-analysis.md)

补充“当前阶段以本地后端打通学习引擎”说明。

#### [2026-04-04-frontend-logic-confirmation-and-optimization-design.md](/Users/xia/program/Learn/docs/superpowers/specs/2026-04-04-frontend-logic-confirmation-and-optimization-design.md)

补充“前端状态层将优先对接本地后端 API”说明。

## 8. 风险与应对

### 8.1 风险：本地实现与未来云实现脱节

应对：

- 强制使用 API 边界
- 强制统一领域模型
- 强制保留迁移字段

### 8.2 风险：MVP 范围失控

应对：

- 当前阶段只做学习闭环 MVP
- 云能力、同步、推荐和推送全部延后

### 8.3 风险：前端继续被 mock 数据拖住

应对：

- 以本地 FastAPI 替换前端 mock 为下一阶段首要任务
- 所有一级页优先接入真实状态来源

## 9. 验收标准

当以下条件满足时，说明本次架构调整完成：

- 文档不再误导团队认为当前必须直接接 CloudBase
- 当前实施架构与目标生产架构边界清晰
- 前端、后端、数据库三方职责明确
- 学习闭环 MVP 的后端范围被收敛
- 后续实现可以直接从本地后端开始，而不是继续停留在纯前端阶段

## 10. 推荐结论

本项目应采用“双轨架构”：

- 当前阶段：本地优先实施
- 未来阶段：迁移到 CloudBase 生产架构

接下来的实施重点不是继续扩展页面，而是开始建设：

- 本地 FastAPI
- 本地数据库
- 学习会话状态机
- 路线与复习任务的真实数据闭环
