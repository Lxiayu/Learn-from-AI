from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]
SKILL_DIR = ROOT / "skills" / "guided-learning-coach"
SKILL_FILE = SKILL_DIR / "SKILL.md"
OPENAI_YAML = SKILL_DIR / "agents" / "openai.yaml"
INTERACTION_REF = SKILL_DIR / "references" / "interaction-patterns.md"
OUTPUT_REF = SKILL_DIR / "references" / "output-templates.md"
REVIEW_REF = SKILL_DIR / "references" / "review-schedules.md"
USAGE_GUIDE = ROOT / "docs" / "guided-learning-coach-usage.md"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def test_skill_structure_exists():
    assert SKILL_DIR.is_dir()
    assert SKILL_FILE.is_file()
    assert OPENAI_YAML.is_file()
    assert INTERACTION_REF.is_file()
    assert OUTPUT_REF.is_file()
    assert REVIEW_REF.is_file()
    assert USAGE_GUIDE.is_file()
    assert not any(SKILL_DIR.rglob(".DS_Store"))


def test_skill_frontmatter_and_sections_cover_core_behavior():
    content = read(SKILL_FILE)

    assert content.startswith("---\n")
    assert "name: guided-learning-coach" in content
    assert "description: Use when" in content
    assert "# Guided Learning Coach" in content
    assert "## When to Use" in content
    assert "## Core Workflow" in content
    assert "## Question Ladder" in content
    assert "## Correction and Re-Teaching" in content
    assert "## Output Contract" in content
    assert "## Mastery Model" in content
    assert "## Boundaries" in content
    assert "学习路线图" in content
    assert "苏格拉底" in content or "Socratic" in content

    referenced_files = set(re.findall(r"references/[a-z0-9-]+\.md", content))
    assert referenced_files == {
        "references/interaction-patterns.md",
        "references/output-templates.md",
        "references/review-schedules.md",
    }


def test_openai_yaml_exposes_interface_metadata():
    content = read(OPENAI_YAML)

    assert 'display_name: "Guided Learning Coach"' in content
    assert 'short_description: "Plan guided study sessions with questioning and spaced review"' in content
    assert "default_prompt:" in content


def test_reference_files_cover_outputs_interactions_and_review_rules():
    interaction = read(INTERACTION_REF)
    output = read(OUTPUT_REF)
    review = read(REVIEW_REF)

    assert "# Interaction Patterns" in interaction
    assert "认知唤起" in interaction
    assert "解释 -> 举例 -> 比较 -> 迁移" in interaction
    assert "先鼓励，再拆解" in interaction
    assert "提示 + 重讲" in interaction

    assert "# Output Templates" in output
    assert "学习路线图" in output
    assert "当前任务卡" in output
    assert "复习计划" in output
    assert "可选学习评价" in output

    assert "# Review Schedules" in review
    assert "1 天后" in review
    assert "3 天后" in review
    assert "7 天后" in review
    assert "14 天后" in review
    assert "基础掌握" in review


def test_usage_guide_covers_platform_support_and_installation():
    content = read(USAGE_GUIDE)

    assert "# Guided Learning Coach 使用指南" in content
    assert "Codex" in content
    assert "OpenClaw" in content
    assert "Claude" in content
    assert "Cline" in content
    assert "Cursor" in content
    assert "Windsurf" in content
    assert "GitHub Copilot" in content
    assert "~/.codex/skills" in content
    assert "~/.openclaw/skills" in content
    assert "~/.claude/skills" in content
    assert "~/.cline/skills" in content
    assert "SKILL.md" in content
    assert "agents/openai.yaml" in content
    assert "触发示例" in content
