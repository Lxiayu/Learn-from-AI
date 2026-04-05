from __future__ import annotations

class MockRoadmapProvider:
    def generate_roadmap(self, *, topic: str, target_outcome: str) -> dict[str, object]:
        return {
            "title": f"{topic} 学习路线",
            "summary": f"围绕“{target_outcome}”分阶段建立概念、方法和应用能力。",
            "estimated_duration_minutes": 420,
            "stages": [
                {
                    "title": "建立核心概念图景",
                    "objective": f"先理解 {topic} 的基本概念和常见场景。",
                    "completion_criteria": "能用自己的话解释核心概念并给出一个简单例子。",
                },
                {
                    "title": "掌握典型问题模式",
                    "objective": "识别常见题型与推理路径。",
                    "completion_criteria": "能比较两类常见模式并说明适用条件。",
                },
                {
                    "title": "迁移到真实问题",
                    "objective": "将概念迁移到新的练习或项目场景。",
                    "completion_criteria": "能在新场景里选择正确方法并解释原因。",
                },
            ],
        }

    def generate_hint(self, *, topic: str, phase: str) -> str:
        hints = {
            "explain": f"先说出 {topic} 最关键的一条特征，不用一开始就把所有细节说全。",
            "example": f"先想一个你见过的 {topic} 场景，再把概念套进去。",
            "compare": f"试着说出 {topic} 和相近概念最明显的不同点。",
            "transfer": f"把 {topic} 放到一个新问题里，看看它是否还适用。",
        }
        return hints.get(phase, f"先抓住 {topic} 的关键词再回答。")

    def explain_again(self, *, topic: str, objective: str) -> str:
        return f"换个方式理解：{topic} 的核心目标是 {objective}"
