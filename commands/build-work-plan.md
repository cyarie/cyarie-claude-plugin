---
name: build-work-plan
---

Activate the `building-a-work-plan` skill to orchestrate work plan creation.

**What this does**:
1. Validates the design document has fleshed-out milestones
2. Optionally sets up a feature branch
3. Investigates the codebase (testing patterns, design assumptions)
4. Decomposes each milestone into granular tasks (TDD-aligned)
5. Reviews and validates the plan
6. Writes milestone files to `docs/work-plans/`

**Required input**: Path to design document with approved milestones.

**If milestones are vague**: Run `/start-milestone-review` first to flesh them out.
