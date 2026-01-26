---
name: execute-work-plan
---

Activate the `executing-a-work-plan` skill to implement a work plan.

**What this does**:
1. Reads milestones just-in-time (one at a time to preserve context)
2. Dispatches `code-worker` agents for each task
3. Runs code review once per milestone (not per-task)
4. Fixes ALL issues (Critical, Important, Minor) before proceeding
5. Loops until zero issues, then moves to next milestone
6. Provides full implementation report when complete

**Required input**: Path to work plan directory (e.g., `docs/work-plans/2026-01-15-my-feature/`)

**Prerequisites**:
- Work plan created by `/build-work-plan`
- Working directory is a git repository
- Milestone files exist (`milestone_01.md`, `milestone_02.md`, etc.)

**Key behaviors**:
- **Human transparency**: Full agent responses are printed (you can see all work)
- **Three-strike rule**: If same issue persists after 3 review cycles, escalates to you
- **Just-in-time loading**: Reads one milestone at a time to stay within context limits
