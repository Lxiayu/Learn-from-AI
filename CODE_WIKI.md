# Guided Learning Coach - Code Wiki

## 1. 项目概述

Guided Learning Coach 是一个用于 AI IDE / openclaw 的引导式学习教练技能，通过苏格拉底式提问、间隔复习和主动学习策略帮助用户系统掌握概念性知识。

### 1.1 核心功能

- **学习路线规划**：根据用户目标和基础，生成个性化的学习路线图
- **苏格拉底式提问**：通过引导性问题帮助用户主动思考，而非被动接受知识
- **理解验证**：使用"解释 → 举例 → 比较 → 迁移"的问题阶梯验证理解深度
- **智能纠错**：识别误解并提供针对性的重新讲解
- **间隔复习**：基于遗忘曲线生成复习计划（1天、3天、7天、14天）
- **多语言支持**：默认中文，可根据需求切换语言

### 1.2 适用场景

- 系统学习概念性主题（算法、数据结构、设计模式等）
- 获得个性化的学习路线图
- 通过主动思考而非被动阅读来学习
- 检验自己是否真正理解了某个概念
- 使用主动回忆法进行复习

## 2. 项目架构

### 2.1 目录结构

```
/Users/xia/program/Learn/
├── docs/
│   └── guided-learning-coach-usage.md  # 使用指南
├── skills/
│   └── guided-learning-coach/          # 主技能目录
│       ├── SKILL.md                    # 技能定义文件
│       ├── agents/
│       │   └── openai.yaml             # Agent 配置
│       └── references/
│           ├── interaction-patterns.md # 交互模式（问题阶梯、纠错策略）
│           ├── output-templates.md     # 输出模板（路线图、任务卡、复习计划）
│           └── review-schedules.md     # 复习计划生成规则
├── tests/
│   └── test_guided_learning_skill.py   # 测试文件
├── .gitignore
└── README.md                           # 项目说明
```

### 2.2 模块划分与职责

| 模块 | 主要职责 | 文件位置 | 说明 |
|------|---------|----------|------|
| 技能定义 | 定义技能的核心逻辑和工作流程 | [SKILL.md](file:///Users/xia/program/Learn/skills/guided-learning-coach/SKILL.md) | 包含技能的使用场景、核心工作流程、问题阶梯等定义 |
| Agent配置 | 配置AI代理的行为和接口 | [openai.yaml](file:///Users/xia/program/Learn/skills/guided-learning-coach/agents/openai.yaml) | 定义代理的显示名称、描述和默认提示 |
| 交互模式 | 定义学习过程中的交互策略 | [interaction-patterns.md](file:///Users/xia/program/Learn/skills/guided-learning-coach/references/interaction-patterns.md) | 包含单点学习循环、问题阶梯、纠错模式等 |
| 输出模板 | 定义各种输出的结构和格式 | [output-templates.md](file:///Users/xia/program/Learn/skills/guided-learning-coach/references/output-templates.md) | 包含学习路线图、任务卡、复习计划等模板 |
| 复习计划 | 定义间隔复习的规则和策略 | [review-schedules.md](file:///Users/xia/program/Learn/skills/guided-learning-coach/references/review-schedules.md) | 包含默认复习节奏、基于掌握程度的调整等 |
| 测试 | 验证技能结构和功能 | [test_guided_learning_skill.py](file:///Users/xia/program/Learn/tests/test_guided_learning_skill.py) | 测试技能文件结构和核心功能 |
| 文档 | 提供使用指南 | [guided-learning-coach-usage.md](file:///Users/xia/program/Learn/docs/guided-learning-coach-usage.md) | 说明如何在不同平台上使用该技能 |

## 3. 核心概念与流程

### 3.1 学习流程

1. **需求收集**：了解用户的学习目标、当前水平和期望节奏
2. **路线规划**：生成包含多个阶段的学习路线图
3. **知识点教学**：
   - 认知唤起：了解用户的现有理解
   - 系统讲解：提供核心概念
   - 理解验证：通过问题阶梯验证理解
   - 纠错补讲：针对性纠正误解
4. **复习计划**：生成间隔复习任务

### 3.2 问题阶梯 (Question Ladder)

学习每个知识点时，会依次通过四个层次的问题：

1. **解释**：用自己的话描述概念
2. **举例**：给出具体例子或类比
3. **比较**：与相近概念进行对比
4. **迁移**：在新场景中应用

### 3.3 掌握模型

- **基础掌握**：能解释概念并给出合理例子
- **深层掌握**：能比较、批判或迁移到新场景

### 3.4 间隔复习

基于遗忘曲线的复习节奏：

- 1天后：复述核心概念并举例
- 3天后：与相近概念比较
- 7天后：应用到新场景
- 14天后：总结并连接到更大的知识体系

## 4. 核心功能模块

### 4.1 学习路线生成

**功能**：根据用户的学习目标和当前水平，生成个性化的学习路线图。

**实现**：
- 首先确认用户的具体学习目标
- 基于目标设计多个学习阶段
- 每个阶段包含明确的目标、核心知识点和完成标志
- 使用 [output-templates.md](file:///Users/xia/program/Learn/skills/guided-learning-coach/references/output-templates.md) 中的模板格式化输出

### 4.2 苏格拉底式提问

**功能**：通过引导性问题帮助用户主动思考，而非被动接受知识。

**实现**：
- 使用问题阶梯（解释 → 举例 → 比较 → 迁移）
- 一次只保持一个活跃问题
- 根据用户的回答调整提问难度和方向
- 参考 [interaction-patterns.md](file:///Users/xia/program/Learn/skills/guided-learning-coach/references/interaction-patterns.md) 中的交互模式

### 4.3 智能纠错

**功能**：识别用户的误解并提供针对性的重新讲解。

**实现**：
- 采用"先鼓励，再拆解"的纠错立场
- 首先肯定用户的努力或正确部分
- 明确指出具体的误解
- 用更简单的语言重新讲解
- 提出更小的后续问题来确认理解

### 4.4 间隔复习计划

**功能**：基于遗忘曲线生成科学的复习计划。

**实现**：
- 默认复习节奏：1天、3天、7天、14天
- 根据用户的掌握程度调整复习内容和难度
- 基础掌握：保持所有四个检查点，任务更简短具体
- 深层掌握：保留3天和7天复习，14天复习更综合跨主题
- 参考 [review-schedules.md](file:///Users/xia/program/Learn/skills/guided-learning-coach/references/review-schedules.md) 中的规则

## 5. 技术实现

### 5.1 技能定义

技能定义文件 [SKILL.md](file:///Users/xia/program/Learn/skills/guided-learning-coach/SKILL.md) 包含以下关键部分：

- **Frontmatter**：技能名称和描述
- **When to Use**：使用场景和触发条件
- **Core Workflow**：核心工作流程
- **Question Ladder**：问题阶梯设计
- **Correction and Re-Teaching**：纠错和重新教学策略
- **Output Contract**：输出格式约定
- **Mastery Model**：掌握度模型
- **Boundaries**：功能边界

### 5.2 Agent配置

[openai.yaml](file:///Users/xia/program/Learn/skills/guided-learning-coach/agents/openai.yaml) 配置文件定义了：

- 显示名称："Guided Learning Coach"
- 简短描述："Plan guided study sessions with questioning and spaced review"
- 默认提示：指导AI如何表现为学习教练

### 5.3 参考资料文件

- **interaction-patterns.md**：定义单点学习循环、问题阶梯、纠错模式和鼓励风格
- **output-templates.md**：提供学习路线图、任务卡、复习计划和评价的模板
- **review-schedules.md**：定义复习节奏和基于掌握程度的调整策略

### 5.4 测试实现

[test_guided_learning_skill.py](file:///Users/xia/program/Learn/tests/test_guided_learning_skill.py) 测试文件验证：

- 技能结构是否完整存在
- 技能文件是否包含核心行为定义
- Agent配置是否暴露接口元数据
- 参考文件是否覆盖输出、交互和复习规则
- 使用指南是否覆盖平台支持和安装

## 6. 依赖关系

### 6.1 内部依赖

| 模块 | 依赖文件 | 说明 |
|------|---------|------|
| 技能定义 | references/interaction-patterns.md | 使用交互模式定义 |
| 技能定义 | references/output-templates.md | 使用输出模板 |
| 技能定义 | references/review-schedules.md | 使用复习计划规则 |
| 测试 | SKILL.md, openai.yaml, references/* | 验证所有核心文件 |

### 6.2 外部依赖

- **AI IDE 平台**：Trae IDE、Codex、OpenClaw、Claude、Cline、Cursor、Windsurf、GitHub Copilot
- **YAML 解析器**：用于解析 openai.yaml 配置文件
- **Markdown 渲染器**：用于显示输出模板

## 7. 安装与使用

### 7.1 安装方法

#### 方法一：Trae手动安装

1. 将 `skills/guided-learning-coach` 目录复制到你的项目：

```bash
mkdir -p .trae/skills
cp -r skills/guided-learning-coach .trae/skills/
```

2. 重启 Trae IDE 或重新加载配置

#### 方法二：直接使用

如果你已经克隆了这个仓库，skill 已经在 `.trae/skills/guided-learning-coach/` 目录下，可以直接使用。

你也可以使用其他AI代理，只需要修改配置文件即可。

### 7.2 使用方法

在 Trae IDE 中，直接告诉 AI 你想学习什么：

```
我想学习计算机算法基础
```

或者更具体地：

```
帮我制定一个学习计划，目标是能够完成 LeetCode 中等难度题目
```

AI 会自动识别你的学习需求并启动引导式学习模式。

### 7.3 支持的平台

根据 [guided-learning-coach-usage.md](file:///Users/xia/program/Learn/docs/guided-learning-coach-usage.md)，该技能支持以下平台：

- Codex
- OpenClaw
- Claude
- Cline
- Cursor
- Windsurf
- GitHub Copilot

## 8. 设计原则

1. **主动学习**：通过提问而非讲解，让学习者主动思考
2. **循序渐进**：从简单到复杂，从具体到抽象
3. **及时反馈**：立即识别误解并纠正
4. **个性化**：根据学习者的水平和目标调整内容
5. **科学复习**：基于认知科学的间隔重复策略

## 9. 边界与限制

- 不模拟长期记忆或数据库存储
- 不强制打分，评估是可选的诊断性反馈
- 不适用于纯操作性的技能学习（如游泳、开车）
- 对于医疗、法律、金融等高风险话题，会保持谨慎并建议外部验证

## 10. 示例对话

**用户**：我想学习计算机算法基础

**Coach**：太好了！在开始之前，我需要了解一些信息：

1. 你的具体学习目标是什么？
2. 你目前的编程和算法基础如何？
3. 你希望用什么编程语言来实践？
4. 你期望的学习节奏？

**用户**：

1. 目标是能够完成 LeetCode 中等难度题目
2. 会写代码，但没系统学习过算法
3. Python
4. 快速掌握核心概念

**Coach**：根据你的目标，我为你设计了以下学习路线：

### 学习路线图

**阶段 1：算法基础与复杂度分析**

- 目标：建立算法思维，掌握复杂度分析
- 核心知识点：时间复杂度、空间复杂度、基本算法思想
- 完成标志：能分析任意代码的复杂度

## 11. 贡献与扩展

欢迎提交 Issue 和 Pull Request 来改进这个 skill！

### 11.1 可能的扩展方向

- 支持更多语言的输出模板
- 添加特定领域的学习路线模板
- 实现与外部学习资源的集成
- 开发可视化的学习进度跟踪

## 12. 相关资源

- [Trae IDE 文档](https://trae.ai)
- [苏格拉底式教学法](https://en.wikipedia.org/wiki/Socratic_method)
- [间隔重复](https://en.wikipedia.org/wiki/Spaced_repetition)

## 13. 总结

Guided Learning Coach 是一个基于认知科学原理设计的引导式学习技能，通过苏格拉底式提问和间隔复习策略，帮助用户更有效地掌握概念性知识。它的核心价值在于将被动学习转变为主动思考，通过个性化的学习路线和科学的复习计划，提高学习效果和知识 retention。

该技能的设计遵循了现代教育心理学的原则，强调主动学习、及时反馈和个性化调整，为用户提供了一种结构化、科学的学习方法。通过与各种AI IDE平台的集成，它可以在不同环境中为用户提供一致的学习体验。