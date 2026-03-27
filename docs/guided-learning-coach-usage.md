# Guided Learning Coach 使用指南

## 1. 这是什么

`guided-learning-coach` 是一个用于“引导式学习”的 Skill。它不把学习做成单次讲解，而是把学习拆成：

- 学习路线图
- 当前任务卡
- 分段讲解
- 苏格拉底式提问
- 纠错与补讲
- 复习计划
- 可选学习评价

它最适合概念理论型主题，例如历史、哲学、经济学、心理学、计算机基础、方法论、商业认知等。  
如果你希望从“看懂了”走到“能讲清楚、能举例、能迁移”，这个 Skill 就适合。

## 2. Skill 能力总览

这个 Skill 目前提供的核心能力：

1. 把“想学什么”和“想达到什么结果”拆成学习路线图
2. 为当前阶段生成可执行的任务卡
3. 在每个知识点上先讲解，再按 `解释 -> 举例 -> 比较 -> 迁移` 的梯度提问
4. 当用户答错或说不会时，先鼓励，再拆解，再补讲
5. 当用户反复卡壳时，切换到“提示 + 重讲”模式
6. 每轮结束后输出已掌握点、模糊点和复习计划
7. 支持受控的发散学习，不让主线完全跑丢

当前边界：

- 默认中文交互
- 第一版优先概念理论型学习
- 不做长期数据库或永久记忆
- 学习评价默认可选，不强制打分

## 3. Skill 包结构

当前包结构如下：

```text
guided-learning-coach/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    ├── interaction-patterns.md
    ├── output-templates.md
    └── review-schedules.md
```

说明：

- `SKILL.md` 是跨平台最核心的文件，绝大多数 Skill 宿主都至少依赖它。
- `references/*.md` 是补充资料，Skill 被触发后，模型再按需读取。
- `agents/openai.yaml` 是面向 Codex / OpenAI Skills UI 的元数据。其他平台通常会忽略它，不影响使用。

## 4. 当前适配情况

下面是基于当前文档与本 Skill 结构做出的适配判断。

### 高适配

#### Codex / OpenAI Skills

适配度：高

原因：

- 当前 Codex 运行环境原生支持 Skill 目录、`SKILL.md` 和按需加载。
- OpenAI 官方说明 Codex app 内建 Skills，并且 OpenAI Skills 遵循 Agent Skills open standard。
- OpenAI Skills 也支持在 ChatGPT 与 API 生态中创建、上传和安装，只是不同产品之间暂不自动同步。
- `agents/openai.yaml` 可以为 Codex / OpenAI 的 Skills UI 提供额外展示元数据。

建议安装位置：

- 全局：`~/.codex/skills/guided-learning-coach/`
- 如果环境设置了 `CODEX_HOME`，则放在 `$CODEX_HOME/skills/guided-learning-coach/`

#### OpenClaw

适配度：高

原因：

- OpenClaw 官方文档明确说明它使用 AgentSkills-compatible 技能目录。
- 支持 `SKILL.md` + 支持文件的技能目录形式。
- 支持工作区级 `skills/` 和全局 `~/.openclaw/skills/`。

建议安装位置：

- 工作区：`<workspace>/skills/guided-learning-coach/`
- 全局：`~/.openclaw/skills/guided-learning-coach/`

OpenClaw 还支持：

- `skills.load.extraDirs`
- 会话刷新或新会话重新加载技能
- 通过 `openclaw skills list` / `openclaw skills check` 排查可用性

#### Claude Code / Claude Skills / Claude Agent SDK / Claude.ai

适配度：高

原因：

- Claude 官方明确支持目录型 Skill，核心文件就是 `SKILL.md`。
- Claude Code 支持个人技能与项目技能。
- Claude.ai 还支持上传自定义 Skills。

建议安装位置：

- 个人：`~/.claude/skills/guided-learning-coach/`
- 项目：`.claude/skills/guided-learning-coach/`

说明：

- `agents/openai.yaml` 对 Claude 不是必需文件，可保留也可忽略。

#### Windsurf

适配度：高

原因：

- Windsurf 官方已经支持 `Skills`，并且使用 `SKILL.md` + 支持文件目录。
- 支持工作区级和全局级 Skill。
- 文档还明确提到，为跨代理兼容，它也会发现 `.agents/skills/`、以及在开启 Claude Code config 读取时的 `.claude/skills/`。

建议安装位置：

- 工作区：`.windsurf/skills/guided-learning-coach/`
- 全局：`~/.codeium/windsurf/skills/guided-learning-coach/`
- 跨代理兼容位置：`.agents/skills/guided-learning-coach/`

#### Cline

适配度：中高

原因：

- Cline 官方支持实验性 Skills，结构也是 `SKILL.md` 目录。
- 支持按需加载和附加支持文件。
- 需要先在设置中开启 Skills 功能。

建议安装位置：

- 工作区：`.cline/skills/guided-learning-coach/`
- 全局：`~/.cline/skills/guided-learning-coach/`

注意：

- Cline 文档更常用 `docs/`、`templates/`、`scripts/` 作为支持目录示例。
- 本 Skill 目前使用 `references/`，这在大多数支持相对文件读取的实现里通常没问题；如果某个环境只对 `docs/` 做特殊支持，可以把 `references/` 改名为 `docs/`，并同步更新 `SKILL.md` 中的相对路径。

### 低适配 / 需要转换

#### Cursor

适配度：低到中

原因：

- Cursor 原生主路径是 `Rules` 和 `AGENTS.md`，不是通用 `SKILL.md` 包加载。
- 它支持 `.cursor/rules`、`AGENTS.md` 和被引用文件，但不会把这个 Skill 目录直接当成原生 Skill 自动管理。

可行做法：

1. 把 `SKILL.md` 核心流程改写成一个或多个 Cursor Rules
2. 或者把核心规则压缩进项目根目录的 `AGENTS.md`
3. 把 `references/*.md` 作为被引用的辅助文档

#### GitHub Copilot

适配度：低到中

原因：

- GitHub Copilot 当前主路径是 `.github/copilot-instructions.md`、`.github/instructions/*.instructions.md` 和 `AGENTS.md`
- 它不是原生 `SKILL.md` 自动发现体系

可行做法：

1. 把 `When to Use`、主流程和边界改写成 `AGENTS.md`
2. 把更细的输出模板和复习规则拆成补充 Markdown 文档
3. 若按路径分域，可再拆到 `.github/instructions/`

## 5. 总结性适配结论

如果按“无需改包结构，直接装上就用”的标准看：

- `Codex / OpenAI Skills`：高
- `OpenClaw`：高
- `Claude Code / Claude.ai / Claude Agent SDK`：高
- `Windsurf`：高
- `Cline`：中高
- `Cursor`：低到中，需要转成 Rules / AGENTS.md
- `GitHub Copilot`：低到中，需要转成 AGENTS / instructions

也就是说，这个 Skill 现在已经比较适合 Agent Skills 生态；对于“原生是 Rules/Instructions，而不是 Skills”的 AI IDE，还需要做一次格式转换。

## 6. 安装教程

### 通用安装步骤

1. 复制整个 `guided-learning-coach` 目录
2. 放到目标平台的 Skill 目录
3. 重启对应的 AI 客户端，或刷新技能列表
4. 用一条触发提示做测试

### Codex / OpenAI 安装

推荐目录：

```bash
mkdir -p ~/.codex/skills
cp -R guided-learning-coach ~/.codex/skills/
```

如果环境使用 `CODEX_HOME`：

```bash
mkdir -p "$CODEX_HOME/skills"
cp -R guided-learning-coach "$CODEX_HOME/skills/"
```

如果你是在支持 Skills 的 ChatGPT 工作区中使用 OpenAI Skills，也可以把整个 Skill 打包后从 Skills 页面上传安装。

### OpenClaw 安装

全局安装：

```bash
mkdir -p ~/.openclaw/skills
cp -R guided-learning-coach ~/.openclaw/skills/
```

工作区安装：

```bash
mkdir -p ./skills
cp -R guided-learning-coach ./skills/
```

排查命令：

```bash
openclaw skills list
openclaw skills check
```

### Claude Code 安装

个人技能：

```bash
mkdir -p ~/.claude/skills
cp -R guided-learning-coach ~/.claude/skills/
```

项目技能：

```bash
mkdir -p .claude/skills
cp -R guided-learning-coach .claude/skills/
```

### Windsurf 安装

工作区技能：

```bash
mkdir -p .windsurf/skills
cp -R guided-learning-coach .windsurf/skills/
```

全局技能：

```bash
mkdir -p ~/.codeium/windsurf/skills
cp -R guided-learning-coach ~/.codeium/windsurf/skills/
```

### Cline 安装

先在设置里启用 Skills，再安装：

```bash
mkdir -p ~/.cline/skills
cp -R guided-learning-coach ~/.cline/skills/
```

或：

```bash
mkdir -p .cline/skills
cp -R guided-learning-coach .cline/skills/
```

### Cursor / GitHub Copilot 使用方式

这两个不建议直接复制 `SKILL.md` 包期待原生自动触发。更稳妥的方式是：

- Cursor：改写为 `.cursor/rules/*.mdc` 或项目根 `AGENTS.md`
- GitHub Copilot：改写为 `.github/copilot-instructions.md` 或 `AGENTS.md`

## 7. 触发示例

下面这些提示最容易触发这个 Skill 的能力：

- `我想系统学习博弈论，并最终能向别人讲清楚纳什均衡，请你用提问引导我。`
- `帮我为“心理学中的认知偏差”做一条学习路线图，然后按知识点逐个带我学。`
- `不要直接给答案，我想通过苏格拉底式提问真正学会“边际效用”。`
- `我刚学完机会成本，请检查我是不是真的理解了，并给我一个复习计划。`
- `请带我主动学习“TCP 三次握手”，不是填鸭式讲解。`

## 8. 推荐使用姿势

为了让 Skill 发挥最好效果，建议在第一次使用时把输入说具体：

- 你想学什么
- 你最终想达到什么结果
- 你现在大概处于什么水平
- 你想不想要结束评价

例如：

```text
我想学习“康德的认识论”，目标是能向没有哲学背景的人讲清楚先验综合判断。我的基础一般，希望你先给出学习路线图，再按知识点逐个带我学。过程中多提问，少灌输。结束后给我复习计划，但先不要评分。
```

## 9. 二次分发建议

如果你想把这个 Skill 分享给别人，最稳妥的分发方式是：

1. 保留完整目录结构
2. 说明支持的平台和安装路径
3. 标出 `SKILL.md` 是核心文件
4. 标出 `agents/openai.yaml` 是 OpenAI / Codex UI 增强文件，不是所有平台都需要
5. 如果接收方是 Cursor / GitHub Copilot，直接附上一份转换后的 `AGENTS.md` 版本

## 10. 当前已知限制

- 这个 Skill 目前主要优化概念型学习，不是最强的应试刷题器
- 没有长期学习数据库
- 没有自动调度跨会话复习
- 对于不支持 `SKILL.md` 自动发现的宿主，仍然需要人工转换
