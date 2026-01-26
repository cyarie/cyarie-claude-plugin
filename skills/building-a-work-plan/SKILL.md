---
name: building-a-work-plan
description: Use when orchestrating the creation of a work plan from a design document. Manages branch setup, codebase investigation, milestone planning, and execution handoff.
command: build-work-plan
---

# Building a Work Plan

## Overview

This skill orchestrates the end-to-end process of converting a design document into an executable work plan. It coordinates branch setup, codebase investigation, milestone-by-milestone planning, and handoff to execution. Think of it as the "conductor" that invokes sub-skills and agents in the right order.

## Required Sub-Skills

Load these during execution:

| Skill | Purpose | When Loaded |
|-------|---------|-------------|
| [writing-a-work-plan](../writing-a-work-plan/SKILL.md) | Task decomposition patterns, templates | Phase 2 |
| [writing-code](../writing-code/SKILL.md) | Engineering principles (via writing-a-work-plan) | Phase 2 |

## Entry Point

When the user invokes `/build-work-plan`:

1. **Announce**: "I'm using the building-a-work-plan skill to create a work plan from your design document."

2. **Get design document path**:
   - If user provided a path, use it
   - If not, use `AskUserQuestion` to request the path
   - **Never guess the path**

3. **Create orchestration tasks** (see Task Tracking section)

4. **Proceed through phases**

## Task Tracking

Create these tasks at the start of each session. Update status as you progress.

```
◻ #1 Setup: Confirm design doc and optional branch setup
◻ #2 Investigate: Codebase testing patterns
◻ #3 Investigate: Design assumptions verification
◻ #4 Plan: Write milestone tasks (one sub-task per milestone)
◻ #5 Verify: Post-planning codebase check
◻ #6 Review: Code review of plan
◻ #7 Approve: User approval
◻ #8 Write: Save plan to disk
◻ #9 Handoff: Execution instructions
```

**Dependencies**:
- #2 blocked by #1
- #3 blocked by #2
- #4 blocked by #3
- #5 blocked by #4
- #6 blocked by #5
- #7 blocked by #6
- #8 blocked by #7
- #9 blocked by #8

Use `TaskCreate` and `TaskUpdate` to manage these. Mark each task `in_progress` when starting, `completed` when done.

## Phases

### Phase 0: Setup (Task #1)

**Step 1: Confirm design document**

Read the design document. Verify it contains:
- [ ] Fleshed-out milestones (job stories, descriptions, AC, demos)
- [ ] Milestone count ≤ 8

If milestones are vague or missing AC, stop and suggest running `/start-milestone-review` first.

**Step 2: Optional branch setup**

Ask the user:

```
Do you need to set up a branch for this work?
- Yes, create a new branch
- No, I'm already on the correct branch
```

If yes:
1. Determine base branch (`main` or `master`)
2. Generate branch name from design doc title (e.g., `feat/trackman-scraper`)
3. Create and checkout branch: `git checkout -b <branch-name>`
4. Confirm branch created

Mark Task #1 complete.

### Phase 1: Codebase Investigation (Tasks #2, #3)

**Task #2: Testing patterns**

Dispatch `codebase-investigator` agent:

```
Investigate the testing patterns in this codebase:
- How are tests structured? (tests/, test/, colocated?)
- What testing framework is used? (pytest, jest, etc.)
- What mocking patterns exist?
- What fixtures are available?
- Any test utilities or helpers?

Report findings in a structured format.
```

Document findings. Mark Task #2 complete.

**Task #3: Design assumptions** (sequential after #2)

Dispatch `codebase-investigator` agent:

```
Verify these design assumptions against the current codebase:

Design doc: [path]
Milestones: [list milestone titles]

Check:
- Do files exist where the design expects them?
- Do expected features/dependencies exist?
- Is there drift between design doc and current code?
- What naming conventions should we follow?

Report any mismatches or concerns.
```

Document findings. Mark Task #3 complete.

### Phase 2: Milestone Planning (Task #4)

**Load sub-skill**: Activate `writing-a-work-plan` skill.

**Process each milestone** following the `writing-a-work-plan` Core Pattern:

For each milestone M:
1. Create sub-task: "Plan: Milestone M - [title]"
2. Read milestone from design doc
3. Classify each AC (infrastructure, functionality, integration)
4. Create scaffold task if needed
5. Create one task per AC with implementation steps
6. Present to user for approval
7. Mark sub-task complete
8. Proceed to next milestone

Mark Task #4 complete when all milestones are planned.

### Phase 3: Post-Planning Verification (Task #5)

Dispatch `codebase-investigator` agent:

```
Verify the planned tasks are implementable:

Work plan location: [path]

Check:
- Do target directories exist (or can be created)?
- Are import paths valid?
- Any conflicts with existing code?
- Are test file locations correct?

Report any issues that would block implementation.
```

If issues found:
- Present to user
- Update tasks to match reality, or
- Flag as known issues in the plan

Mark Task #5 complete.

### Phase 4: Code Review (Task #6)

Dispatch `code-reviewer` agent over all milestone plan files:

```
Review these work plan files for quality:

Files: [list of milestone_##.md files]

Check:
- All AC have corresponding tasks
- Tasks include concrete test code where applicable
- Verification steps are explicit
- Commit messages follow conventions
- Dependencies are noted
- No ambiguous or vague steps

Report issues by file and task number.
```

**Review mode** (ask user at session start):
- **Fix before presenting**: Automatically fix issues
- **Present issues to user**: Let user decide what to fix

Mark Task #6 complete.

### Phase 5: User Approval (Task #7)

Present the complete work plan summary:

```markdown
## Work Plan Summary

**Design doc**: [path]
**Plan location**: [path]
**Milestones**: [count]

| Milestone | Tasks | Type Breakdown |
|-----------|-------|----------------|
| M1: [title] | N tasks | X infra, Y func, Z integ |
| M2: [title] | N tasks | ... |
| ... | ... | ... |

**Total tasks**: [count]

**Codebase verification**: [status]
**Code review**: [status]

Ready to write to disk?
```

Get explicit approval. Mark Task #7 complete.

### Phase 6: Write to Disk (Task #8)

Create directory and files:

```
docs/work-plans/YYYY-MM-DD-<plan-name>/
├── milestone_01.md
├── milestone_02.md
├── ...
└── milestone_NN.md
```

Verify files written:
```bash
ls -la docs/work-plans/YYYY-MM-DD-<plan-name>/
```

Mark Task #8 complete.

### Phase 7: Execution Handoff (Task #9)

**Capture absolute paths**:
```bash
git rev-parse --show-toplevel  # Working root
```

**Present handoff instructions**:

```markdown
## Work Plan Complete

Your work plan is ready at:
`[absolute-path-to-plan-directory]`

### Next Steps

Execution support is coming in a future skill (`/execute-work-plan`).

For now, you can:
1. Review the milestone files in `[plan-directory]`
2. Implement tasks manually, following the TDD workflow in each task
3. Use the task list in each milestone to track progress

### To Resume Later

If you need to resume work on this plan in a new session:
1. Run `/clear` to reset context
2. Point Claude to the plan directory
3. Pick up where you left off

### Files Created

[List all milestone_##.md files with paths]
```

Mark Task #9 complete.

## Resumption

If the user returns to continue a work plan:

1. Ask for the plan directory path
2. Read existing milestone files
3. Identify which milestones are complete vs pending
4. Resume from the next pending milestone

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|--------------|------------------|
| Guessing design doc path | Wrong file, wasted effort | Always ask if not provided |
| Skipping codebase investigation | Tasks may not be implementable | Always investigate before planning |
| Not tracking orchestration tasks | Lose progress on interruption | Create tasks at session start |
| Relative paths in handoff | Paths break across sessions | Always use absolute paths |
| Batch planning all milestones | Early mistakes compound | Interactive milestone-by-milestone |

## Anti-Rationalizations

- "I know where the design doc is" — Ask anyway. Confirmation prevents errors.
- "Codebase investigation is slow" — It's faster than planning tasks for nonexistent files.
- "Task tracking is overhead" — It's insurance against interruption. Do it.
- "The user knows the paths" — Capture absolute paths explicitly. Context resets.

## Summary

1. **Announce the skill.** User knows what's happening.
2. **Create orchestration tasks.** Track progress through phases.
3. **Investigate before planning.** Codebase reality grounds the plan.
4. **Interactive milestone review.** Approve each before proceeding.
5. **Capture absolute paths.** Handoff survives context reset.
6. **Execution is future work.** Plan is the deliverable for now.
