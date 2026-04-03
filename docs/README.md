# 智学AI（LearnAI）- 开发文档索引

## 文档概览

欢迎使用智学AI开发文档！这是一套完整的开发文档体系，涵盖了从产品设计到运维部署的各个阶段，为项目开发提供全面指导。

## 文档列表

### 核心开发文档（按开发流程顺序）

| 序号 | 文档名称 | 文件名 | 角色视角 | 说明 |
|------|---------|--------|---------|------|
| 1 | 产品需求文档 | [01-product-requirements-document.md](file:///Users/xia/program/Learn/docs/01-product-requirements-document.md) | 产品经理 | 详细的产品需求、功能规格、用户目标、质量标准 |
| 2 | 技术架构文档 | [02-technical-architecture.md](file:///Users/xia/program/Learn/docs/02-technical-architecture.md) | 技术架构师 | 系统架构设计、技术选型、服务划分、安全设计 |
| 3 | 开发规范文档 | [03-development-standards.md](file:///Users/xia/program/Learn/docs/03-development-standards.md) | 开发负责人 | 代码规范、Git工作流、API规范、测试规范 |
| 4 | 测试计划文档 | [04-test-plan.md](file:///Users/xia/program/Learn/docs/04-test-plan.md) | 测试经理 | 测试策略、测试用例、性能测试、安全测试 |
| 5 | 项目计划文档 | [05-project-plan.md](file:///Users/xia/program/Learn/docs/05-project-plan.md) | 项目经理 | 项目计划、团队组织、里程碑、风险管理 |
| 6 | 运营方案文档 | [06-operation-plan.md](file:///Users/xia/program/Learn/docs/06-operation-plan.md) | 运营负责人 | 运营策略、用户运营、内容运营、商业化 |
| 7 | 数据库设计文档 | [07-database-design.md](file:///Users/xia/program/Learn/docs/07-database-design.md) | 数据库工程师 | 完整的表结构设计、索引策略、数据安全 |
| 8 | API接口文档 | [08-api-documentation.md](file:///Users/xia/program/Learn/docs/08-api-documentation.md) | API工程师 | 完整的RESTful API定义、请求响应示例 |
| 9 | 部署文档 | [09-deployment-guide.md](file:///Users/xia/program/Learn/docs/09-deployment-guide.md) | 运维工程师 | 部署流程、K8s配置、监控告警、灾难恢复 |

### 补充文档

| 文档名称 | 文件名 | 说明 |
|---------|--------|------|
| 前端设计提示词（完整版） | [frontend-design-prompt.md](file:///Users/xia/program/Learn/docs/frontend-design-prompt.md) | 详细的前端设计要求和规范 |
| 前端设计提示词（精简版） | [frontend-design-prompt-concise.md](file:///Users/xia/program/Learn/docs/frontend-design-prompt-concise.md) | 精简版前端设计提示词 |
| Guided Learning Coach使用指南 | [guided-learning-coach-usage.md](file:///Users/xia/program/Learn/docs/guided-learning-coach-usage.md) | 原有技能的使用指南 |

## 项目概述

### 项目信息
- **项目名称**：智学AI（LearnAI）
- **项目周期**：24周（5-6个月）
- **团队规模**：10人+
- **目标用户**：全年龄段学习者，侧重学生群体

### 核心功能
1. **智能学习对话系统**：苏格拉底式提问、问题阶梯、智能纠错
2. **个性化学习路线**：基于用户目标生成学习计划
3. **间隔复习系统**：基于遗忘曲线的科学复习
4. **学习数据看板**：学习统计、成就系统
5. **用户系统**：注册登录、个人中心、权限管理

### 技术栈
- **前端**：Flutter（跨平台）
- **后端**：Python + FastAPI
- **数据库**：PostgreSQL、Redis、MongoDB
- **AI服务**：OpenAI API + LangChain
- **部署**：Docker + Kubernetes
- **监控**：Prometheus + Grafana
- **日志**：ELK Stack

## 开发流程指南

### 阶段一：项目启动（第1-4周）
1. 阅读 [产品需求文档](file:///Users/xia/program/Learn/docs/01-product-requirements-document.md)
2. 参考 [技术架构文档](file:///Users/xia/program/Learn/docs/02-technical-architecture.md)
3. 遵循 [开发规范文档](file:///Users/xia/program/Learn/docs/03-development-standards.md)
4. 参考 [数据库设计文档](file:///Users/xia/program/Learn/docs/07-database-design.md)

### 阶段二：开发阶段（第5-18周）
1. 参考 [API接口文档](file:///Users/xia/program/Learn/docs/08-api-documentation.md)
2. 遵循 [测试计划文档](file:///Users/xia/program/Learn/docs/04-test-plan.md)
3. 参考 [项目计划文档](file:///Users/xia/program/Learn/docs/05-project-plan.md)

### 阶段三：测试上线（第19-24周）
1. 参考 [测试计划文档](file:///Users/xia/program/Learn/docs/04-test-plan.md)
2. 遵循 [部署文档](file:///Users/xia/program/Learn/docs/09-deployment-guide.md)
3. 参考 [运营方案文档](file:///Users/xia/program/Learn/docs/06-operation-plan.md)

## 角色分工

| 角色 | 主要文档 | 职责 |
|------|---------|------|
| 产品经理 | 产品需求文档、运营方案文档 | 需求管理、产品设计 |
| 技术架构师 | 技术架构文档、数据库设计文档 | 架构设计、技术选型 |
| 开发负责人 | 开发规范文档、API接口文档 | 代码规范、接口设计 |
| 测试经理 | 测试计划文档 | 测试策略、质量把控 |
| 项目经理 | 项目计划文档 | 进度管理、团队协调 |
| 运营负责人 | 运营方案文档 | 用户运营、商业化 |
| 数据库工程师 | 数据库设计文档 | 数据库设计、性能优化 |
| API工程师 | API接口文档 | API设计、文档维护 |
| 运维工程师 | 部署文档 | 部署配置、监控运维 |

## 快速导航

### 开发快速开始
1. 了解产品：阅读 [产品需求文档](file:///Users/xia/program/Learn/docs/01-product-requirements-document.md)
2. 技术设计：参考 [技术架构文档](file:///Users/xia/program/Learn/docs/02-technical-architecture.md)
3. 数据库：查看 [数据库设计文档](file:///Users/xia/program/Learn/docs/07-database-design.md)
4. API接口：使用 [API接口文档](file:///Users/xia/program/Learn/docs/08-api-documentation.md)
5. 开发规范：遵循 [开发规范文档](file:///Users/xia/program/Learn/docs/03-development-standards.md)

### 测试快速开始
1. 测试策略：阅读 [测试计划文档](file:///Users/xia/program/Learn/docs/04-test-plan.md)
2. 测试用例：参考测试计划中的详细用例

### 运维快速开始
1. 部署流程：阅读 [部署文档](file:///Users/xia/program/Learn/docs/09-deployment-guide.md)
2. 架构拓扑：参考部署文档中的架构图
3. 监控告警：参考部署文档中的监控配置

## 项目关键指标

### 技术指标
- 服务可用性：> 99.9%
- API响应时间：< 500ms
- 代码覆盖率：> 80%
- P0/P1 Bug数：0

### 产品指标
- 用户满意度：> 4.0/5.0
- 次日留存率：> 40%
- DAU（上线3个月）：10,000

## 注意事项

1. **版本控制**：所有文档都应跟随项目迭代更新
2. **文档同步**：当需求或设计发生变更时，请及时更新相关文档
3. **反馈机制**：发现文档问题或需要补充内容，请及时反馈
4. **保密要求**：文档中包含敏感信息，请遵守保密规定

## 联系与反馈

如有任何问题或建议，请联系相关角色负责人。

---

**文档最后更新**：2026-04-03  
**文档版本**：v1.0