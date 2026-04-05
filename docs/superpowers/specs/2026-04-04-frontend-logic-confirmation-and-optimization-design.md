# 智学AI 前端逻辑确认与稳定性优化设计

## 1. 文档目的

本文件定义 Flutter 前端进入“可用性强化阶段”后的工作边界、优先级和验收标准。

这一阶段的目标不是继续盲目加页面，而是把当前已经做出的一级页和二级页，从“可演示的前端原型”推进到“逻辑清晰、行为稳定、不会出现奇怪错误的应用前端”。

本文档默认以以下事实为前提：

- 技术架构以 [02-technical-architecture.md](/Users/xia/program/Learn/docs/02-technical-architecture.md) 为准
- 前端框架为 `Flutter + Riverpod + GoRouter`
- 当前页面结构以 [2026-04-03-learning-app-page-structure-design.md](/Users/xia/program/Learn/docs/superpowers/specs/2026-04-03-learning-app-page-structure-design.md) 为准
- 当前视觉来源以 `stitch_ai/` 中的设计稿与 HTML 为准
- 当前应用仍以本地 mock 数据驱动，尚未接入正式本地后端与本地持久化
- 后续真实数据接入默认以 **本地 FastAPI** 为第一目标，而不是直接接云端
- 当前实施与未来迁移关系见 [2026-04-05-local-first-backend-and-cloud-migration-design.md](/Users/xia/program/Learn/docs/superpowers/specs/2026-04-05-local-first-backend-and-cloud-migration-design.md)

---

## 2. 当前阶段结论

### 2.1 当前是否可以进入下一阶段

结论：`可以`

原因：

- 5 个一级页面已经完成可运行版本
- 关键二级页面和状态页已经具备基础路由与视觉实现
- 应用已经支持中英文切换
- `flutter analyze`、`flutter test`、`flutter build web` 已通过
- Web 端先前出现的 `SyntaxError: Invalid or unexpected token` 已被修复

### 2.2 当前阶段的真实定位

当前前端已经不再是单纯模板，但也还不是“业务已闭环的正式应用”。

更准确地说，它处于：

`高保真前端原型 + 部分交互可用 + 业务逻辑尚未完全落地`

因此，下一阶段的核心不是“继续堆页面”，而是：

1. 明确页面之间的真实逻辑关系
2. 清除空动作、假动作和隐性异常
3. 让每个关键入口都有可预测行为
4. 为后续接本地数据库和后端 API 预留稳定接口

这里的“后端 API”在当前阶段特指：

- 本地 FastAPI 提供的学习目标、路线、会话、复习接口

而不是当前直接接入 CloudBase。

---

## 3. 当前页面完成度盘点

### 3.1 已完成的一级页面

| 页面 | 当前状态 | 说明 |
| --- | --- | --- |
| Home | 已完成第一版 | 具备总览、学习入口、复习入口、提示卡、主题一致性 |
| Roadmap | 已完成第一版 | 具备路线主视图与知识图谱入口 |
| Review | 已完成第一版 | 具备复习主视图、测验入口、结果入口、错题入口 |
| Socratic Chat | 已完成第一版 | 具备主对话页、专注模式、AI 思考态、多模态入口 |
| Profile & Analytics | 已完成第一版 | 具备统计、成就、设置卡片与语言切换 |

### 3.2 已完成的二级页面

| 页面 | 当前状态 | 说明 |
| --- | --- | --- |
| Focus Mode | 已完成第一版 | 专注输入场景已落地 |
| AI Thinking State | 已完成第一版 | AI 思考态已落地 |
| Multimodal Input Detail | 已完成第一版 | 多模态输入详情页已落地 |
| Mastery Quiz | 已完成第一版 | 测验页面已落地 |
| Quiz Results Summary | 已完成第一版 | 测验结果页已落地 |
| Review Mistakes Detail | 已完成第一版 | 错题解释页已落地 |
| Mistakes Mastered Celebration | 已完成第一版 | 掌握庆祝页已落地 |
| Knowledge Graph View | 已完成第一版 | 图谱视图已落地 |
| Learning Insights Report | 已完成第一版 | 学习报告页已落地 |
| Achievements Gallery | 已完成第一版 | 成就页已落地 |
| New Achievement Notification | 已完成第一版 | 新成就反馈页已落地 |

### 3.3 尚未完全独立的页面

| 页面 | 当前状态 | 说明 |
| --- | --- | --- |
| Review Schedule | 未独立拆页 | 当前信息被并入 `Review` 一级页，不是独立路由 |
| Settings Center | 未独立拆页 | 当前设置集中在 `Profile & Analytics` 卡片区 |

结论：

- 页面数量层面，当前已经足够支撑下一阶段
- 页面逻辑层面，仍需把“视觉完成”提升到“行为完成”

---

## 4. 当前最大风险

### 4.1 空动作风险

当前前端仍存在一批 `onPressed: () {}` 形式的空动作按钮。

这些按钮如果继续保留为空实现，会带来两个问题：

1. 用户会误以为功能已经可用
2. 后续接真实逻辑时，入口行为不一致，容易引入错误

当前需要重点收敛的空动作包括但不限于：

- 顶部壳层的通知按钮
- 顶部壳层的设置/调节按钮
- `Roadmap` 页的 `Continue Learning`
- `Chat` 页的 `Send Reflection`
- `Multimodal Input` 页的 `Analyze with AI`
- `AI Thinking State` 页右上角更多按钮
- `Mastery Quiz` 页的 `Skip Question`
- `Mastery Quiz` 页的 `Submit Answer`
- `Quiz Results Summary` 页的两个操作按钮
- `Review Mistakes Detail` 页的 `Got It, Next Mistake`
- `Mistakes Mastered Celebration` 页的 `Continue Journey`
- `Knowledge Graph` 页的 `Continue Learning`
- `New Achievement Notification` 页的 `Share Achievement`

### 4.2 Mock 数据与真实逻辑断层风险

当前页面大多依赖本地 mock 数据。

这本身没有问题，但如果不明确“哪些地方是 mock、哪些地方是未来真实状态入口”，会导致以下问题：

- 页面切换看起来正常，但状态没有真正变化
- 用户完成一个动作后，前后页数据不同步
- 某些卡片文案与页面详情无法保持一致

### 4.3 缺少统一异常边界风险

当前虽然已经通过分析和测试，但应用层还没有形成一套统一的异常处理策略。

如果下一阶段直接接入数据层或接口层，而不先补以下内容，后面很容易再次出现 Web 端运行时异常：

- 页面级异常兜底
- 空数据态
- 加载态
- 错误态
- 离线态
- 用户可理解的重试反馈

---

## 5. 下一阶段的总目标

下一阶段名称建议定为：

`前端逻辑确认与稳定性优化阶段`

总目标：

> 在不增加大量新页面的前提下，把现有前端从“高保真视觉原型”升级为“行为明确、状态一致、异常可控、支持后续接入真实数据层”的应用前端。

这一阶段必须优先保证：

- 所有关键入口都有明确行为
- 所有页面切换符合用户预期
- 所有关键页面都有空/错/加载兜底
- 不允许保留会让用户困惑的假动作
- 不允许在 Web/Chrome 下再出现明显运行时崩溃

---

## 6. 页面逻辑确认

### 6.1 Home

`Home` 的职责是学习总控台，不是内容承载页。

必须确认的逻辑：

- `Continue Learning`：应打开当前活跃学习会话
- `View Schedule`：应进入复习主入口或未来独立的 `Review Schedule`
- 当前学习卡：应与 `Roadmap` 当前进行中节点保持一致
- 今日目标卡：应与复习状态、会话状态联动，而不是静态展示

当前阶段要求：

- 即使仍使用 mock 数据，也要保证 `Home -> Chat`、`Home -> Review`、`Home -> Roadmap` 的含义一致
- 不允许 Home 展示“已完成”但详情页仍显示“未开始”

### 6.2 Roadmap

`Roadmap` 的职责是回答“学什么、学到哪里、下一步学什么”。

必须确认的逻辑：

- `Continue Learning`：必须进入当前活跃知识点对应的对话页
- 路线节点状态：`进行中 / 下一步 / 未解锁` 必须具备明确规则
- `Knowledge Graph View`：应被定义为路线扩展视图，而不是独立学习主线

当前阶段要求：

- 节点状态来源必须统一
- 路线进度与 Home 当前焦点卡必须使用同一份状态定义

### 6.3 Review

`Review` 的职责是回答“今天复习什么、为什么复习、复习后结果如何”。

必须确认的逻辑：

- `Mastery Quiz`：进入测验流程
- `Quiz Results Summary`：展示本轮测验结果
- `Review Mistakes Detail`：解释错误和薄弱点
- `Mistakes Mastered Celebration`：承接正向反馈

当前阶段要求：

- 复习主页必须定义“今日待复习项”的状态来源
- 测验结果必须能反映到复习总览，而不是永远静态
- 若 `Review Schedule` 暂不拆页，则必须明确 `Review` 本页就是阶段性日程页

### 6.4 Socratic Chat

`Socratic Chat` 是产品核心，不允许只是一个漂亮的输入框。

必须确认的逻辑：

- `Send Reflection`：至少要能把用户输入写入本地会话状态
- AI 问题序列：要么来自 mock 会话引擎，要么来自后端；不能只是静态文本
- `Focus Mode`：应视为当前会话的专注输入模式，而不是独立的无关联页面
- `AI Thinking State`：应作为发送回答后的过渡态，而不是孤立页面
- `Multimodal Input`：应为同一会话补充输入，不应脱离当前学习上下文

当前阶段要求：

- 至少建立“本地会话状态”这一层
- 允许暂时不接真实 LLM，但不允许按钮按下后没有任何行为

### 6.5 Profile & Analytics

`Profile & Analytics` 的职责是承接低频但关键的个人信息、统计、成就和设置。

必须确认的逻辑：

- 语言切换：必须可持续生效
- 学习统计：当前允许 mock，但结构必须可替换为真实数据
- 成就：应定义“已解锁 / 未解锁 / 新解锁”三种状态
- 设置：需要明确哪些是本地设置，哪些是未来云同步设置

当前阶段要求：

- 语言切换不能只影响当前页，必须影响整个应用
- `Learning Insights Report`、`Achievements Gallery`、`New Achievement Notification` 的入口与返回路径必须稳定

---

## 7. 本阶段必须补齐的行为规则

### 7.1 所有按钮必须属于以下三类之一

1. `真实跳转`
   例如：进入二级页、返回、切换 Tab

2. `本地可执行动作`
   例如：保存输入、切换语言、切换筛选、切换状态

3. `明确的未开放动作`
   例如：展示 `SnackBar: 功能开发中`

禁止保留：

- 点击无反应
- 看起来可点但没有结果
- 表面成功但状态不变

### 7.2 所有页面必须定义 5 种基础状态

每个关键页面后续都要明确以下状态：

1. `loading`
2. `ready`
3. `empty`
4. `error`
5. `offline`

即使在当前 mock 阶段，也应先设计出承载这些状态的 UI 容器，而不是等接接口后再补。

### 7.3 所有跨页状态必须定义唯一来源

下一阶段必须明确以下状态归属：

| 状态 | 建议来源 |
| --- | --- |
| 当前语言 | `app_language_provider` |
| 当前活跃学习主题 | `learning_session_provider` |
| 当前路线节点 | `roadmap_provider` |
| 今日复习任务 | `review_provider` |
| 用户统计摘要 | `profile_analytics_provider` |
| 设置项 | `settings_provider` |

原则：

- 同一事实只能有一个来源
- 页面只消费状态，不各自复制状态

---

## 8. 与 02 技术架构对齐的前端数据层要求

根据 [02-technical-architecture.md](/Users/xia/program/Learn/docs/02-technical-architecture.md)，前端下一阶段必须按“本地优先”思路准备数据结构。

### 8.1 本地优先原则

应用需要优先支持：

- 本地保存学习路线摘要
- 本地保存当前学习会话
- 本地保存今日复习任务
- 本地保存语言和设置

### 8.2 分层要求

前端后续建议拆成以下层次：

1. `presentation`
   页面与组件

2. `state/provider`
   Riverpod provider、状态机、动作分发

3. `repository`
   屏蔽 mock、本地数据库和远程 API 差异

4. `local storage`
   `SharedPreferences / Hive / SQFlite`

### 8.3 当前阶段不需要做的事

为了避免过早复杂化，本阶段不要求：

- 直接接入云端生产 API
- 引入完整鉴权逻辑
- 实现正式同步冲突解决
- 接入正式 AI 对话服务

但本阶段必须做到：

- 后续接入真实数据时，不需要推翻当前页面结构
- 状态来源和 UI 事件绑定已具备可替换性

---

## 9. 前端优化优先级

### P0：必须优先完成

1. 清理所有关键空动作
2. 为核心页面建立加载/空/错/离线状态承载
3. 建立 `Chat / Roadmap / Review / Home` 的统一状态来源
4. 明确 `Review Schedule` 是否拆页
5. 明确 `Settings` 是否拆页
6. 保证中文和英文下都不出现明显布局溢出
7. 保证 Web/Chrome 首屏与切页过程不报运行时异常

### P1：紧接着完成

1. 统一卡片间距、边框和信息层级
2. 优化顶部壳层按钮行为
3. 优化二级页返回路径一致性
4. 处理桌面 Web 下的最大宽度和阅读区域
5. 让图谱页、成就页、报告页在大屏下更合理

### P2：后续增强

1. 接入本地持久化
2. 接入真实 AI 会话状态
3. 接入真实复习与路线数据
4. 增加通知、提醒、同步相关完整设置

---

## 10. 下一阶段建议拆解

### Task A：逻辑确认

目标：

- 为每个一级页定义真实业务职责
- 为每个按钮定义最终行为
- 标记哪些入口是跳转、哪些是本地动作、哪些是未开放

输出：

- 页面逻辑矩阵
- 按钮行为矩阵

### Task B：状态层搭建

目标：

- 建立 `learning_session / roadmap / review / profile / settings` 五组基础 provider
- 让关键页面不再直接写死静态文案和状态

输出：

- 本地状态模型
- 页面与状态绑定关系

### Task C：异常与空状态体系

目标：

- 为一级页和关键二级页补齐 `loading / empty / error / offline`

输出：

- 通用状态组件
- 每页状态展示规则

### Task D：交互补齐

目标：

- 把当前空动作变成明确行为
- 对未开放功能使用统一反馈

输出：

- 无死按钮版本
- 关键路径行为一致

### Task E：视觉细修

目标：

- 处理中英文排版差异
- 调整响应式布局
- 强化 Stitch 风格统一性

输出：

- 更稳定的多语言布局
- 更一致的主次信息层级

---

## 11. 验收标准

当前阶段完成后，必须满足以下标准，才可进入“数据接入阶段”：

### 11.1 功能层

- 所有一级页面都能正常进入、返回和切换
- 所有关键二级页面都能从主入口进入
- 所有关键按钮都有明确反馈
- 不存在点击后无响应的主要功能按钮

### 11.2 稳定性层

- `flutter analyze` 通过
- `flutter test` 通过
- `flutter build web` 通过
- Chrome/Web 首屏、切页、语言切换无明显运行时异常

### 11.3 体验层

- 中文下无明显溢出、错行、挤压
- 英文下无明显过稀疏或过拥挤
- 路由层无奇怪转场
- 页面入口与文案语义一致

### 11.4 架构层

- 核心跨页状态具备唯一来源
- 页面能与未来本地数据库 / API 层自然衔接
- 不需要因接后端而大规模推翻现有 UI 架构

---

## 12. 当前建议结论

结论如下：

1. 当前不需要继续新增大量页面
2. 当前最重要的是把现有页面做“真”
3. 应优先进入“逻辑确认 + 稳定性优化 + 状态层搭建”
4. `Review Schedule` 与 `Settings Center` 是否独立拆页，应在下一轮首先确认

这也是后续真正把智学AI做成“可用应用”而不是“好看的原型”的关键分水岭。
