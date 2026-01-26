---
name: executing-a-work-plan
description: Use when executing a work plan created by building-a-work-plan. Orchestrates milestone-by-milestone implementation using code-worker agents with per-milestone code review.
command: execute-work-plan
---

# Executing a Work Plan

## Overview

This skill orchestrates the execution of work plans created by `building-a-work-plan`. It processes milestones sequentially, dispatching `code-worker` agents for each task, conducting code review once per milestone, and fixing all issues before proceeding. The goal is complete, reviewed implementation — not just "code that works."

## Key Principles

### Human Transparency

**After every agent completes, print their full response before taking further action.**

The human cannot see subagent outputs directly. You are their window into the work. Show all details:
- Test counts and results
- Issue lists with locations
- Commit hashes
- Error messages
- Verification evidence

Never summarize agent output. Print it completely.

### Just-in-Time Loading

**Never load all milestones upfront.**

Read one milestone, execute all its tasks, review, then move to the next. This preserves context within token budgets. If you read everything at once, you'll run out of context before finishing.

### Per-Milestone Review (Not Per-Task)

**Review once per milestone, not after each task.**

Per-task review wastes context on repeated setup. Execute all tasks in a milestone, then review the complete work. This catches cross-task issues that per-task review would miss.

## When to Use

- After `building-a-work-plan` creates a work plan
- When work plan files exist at `docs/work-plans/YYYY-MM-DD-[plan-name]/`
- When ready to implement (not just plan)

## When NOT to Use

- No work plan exists yet (use `building-a-work-plan` first)
- Work plan needs revision (fix the plan first)
- Single-file fixes that don't need orchestration

## Entry Point

When the user invokes `/execute-work-plan`:

1. **Announce**: "I'm using the executing-a-work-plan skill to implement your work plan."

2. **Get work plan path**:
   - If user provided a path, use it
   - If not, use `AskUserQuestion` to request the path
   - **Never guess the path**

3. **Verify prerequisites**:
   - Work plan directory exists
   - Contains `milestone_##.md` files
   - Working directory is a git repository

4. **Create orchestration tasks** (see Task Tracking)

5. **Execute milestones**

## Task Tracking

Create tasks at session start. Update status as you progress.

```
◻ #1 Discover: List milestones without reading full content
◻ #2 Execute Milestone 1: [title from header]
◻ #3 Review Milestone 1: Code review and fixes
◻ #4 Execute Milestone 2: [title]
◻ #5 Review Milestone 2: Code review and fixes
... (repeat for each milestone)
◻ #N Final Review: Full implementation review
◻ #N+1 Complete: Summary and handoff
```

Use `TaskCreate` and `TaskUpdate` to manage these.

## Core Pattern

### Step 1: Discover Milestones

List milestone files without reading full content:

```bash
ls docs/work-plans/[plan-name]/milestone_*.md
```

Extract headers to get titles and task counts:

```bash
head -20 docs/work-plans/[plan-name]/milestone_01.md
```

Create the task list based on discovered milestones.

### Step 2: Execute Each Milestone

For each milestone M:

#### 2a. Read Milestone (Just-in-Time)

Mark task as `in_progress`. Read only that milestone file:

```bash
cat docs/work-plans/[plan-name]/milestone_0M.md
```

Extract:
- Milestone title and goal
- List of tasks with their types
- Task dependencies (Blocked By / Blocks)

#### 2b. Verify Test Coverage in Plan

Before dispatching any task:

**For Functionality and Integration tasks**, verify the plan includes test specifications. If tests are missing from the plan, stop and report:

```
Plan gap detected: Task M.X ([title]) is type Functionality but has no test specification.
Cannot implement without tests. Please update the work plan.
```

Do not implement functionality without tests specified in the plan.

#### 2c. Execute All Tasks

For each task in the milestone:

1. **Check dependencies.** If blocked by incomplete tasks, skip and note.

2. **Dispatch `code-worker` agent**:

```
Implement this task from the work plan:

Milestone file: [absolute path]
Task: [task number and title]

The task specification is in the milestone file. Read it, implement it following TDD,
run verification, update the work plan file, and commit.

Report back with your completion report.
```

3. **Print the full agent response.** Do not summarize.

4. **Record completion.** Note task number, commit SHA, any issues.

5. **Proceed to next task.**

Execute all tasks sequentially. Do not review between tasks.

#### 2d. Code Review for Milestone

After all tasks in the milestone are complete:

1. **Capture git state**:
```bash
BASE_SHA=$(git log --oneline | grep -m1 "before milestone M" | cut -d' ' -f1)
HEAD_SHA=$(git rev-parse HEAD)
```

2. **Use `requesting-code-review` skill**:
   - Provide what was implemented (list tasks completed)
   - Reference the milestone file
   - Include base and head commit SHAs

3. **Handle review results**:
   - **Zero issues**: Mark milestone review complete, proceed to next milestone
   - **Any issues**: Dispatch `bug-worker` agent to fix ALL issues (Critical, Important, Minor)

4. **Print full review and fix responses.**

5. **Re-review after fixes.** Loop until zero issues.

#### 2e. Three-Strike Rule

If the same issue persists after three review cycles:

```
ESCALATION REQUIRED

Issue "[issue title]" has persisted through 3 review cycles.

Location: [file:line]
Issue: [description]
Attempted fixes:
  Cycle 1: [what was tried]
  Cycle 2: [what was tried]
  Cycle 3: [what was tried]

This requires human intervention. Please review and advise.
```

Stop and wait for human guidance. Do not continue attempting fixes.

#### 2f. Proceed to Next Milestone

Mark milestone review task complete. Move to next milestone's read step.

### Step 3: Final Review

After all milestones are complete:

1. **Run full implementation review** using `requesting-code-review` skill
2. **Fix any remaining issues** with `bug-worker`
3. **Loop until zero issues**

### Step 4: Complete

Provide completion report:

```markdown
## Work Plan Execution Complete

### Summary

| Milestone | Tasks | Review Cycles | Status |
|-----------|-------|---------------|--------|
| M1: [title] | N | X | Complete |
| M2: [title] | N | X | Complete |
| ... | ... | ... | ... |

**Total tasks implemented**: [count]
**Total review cycles**: [count]
**Escalations**: [count or "None"]

### Commits

[List of commit SHAs with messages]

### Files Changed

[Summary of files created/modified]

### Verification Evidence

- Tests: [final test count and status]
- Linter: [status]
- Type checker: [status]

### Next Steps

The implementation is complete and reviewed. Consider:
1. Manual testing of the full feature
2. Creating a PR for review
3. Updating documentation if needed
```

## Resumption

If interrupted mid-execution:

1. Ask for the work plan directory path
2. Read milestone files to determine progress (look for ✓ markers)
3. Identify which milestone/task is next
4. Resume from that point

## Integration with Agents

| Agent | Role | When Dispatched |
|-------|------|-----------------|
| `code-worker` | Implements individual tasks | For each task in a milestone |
| `code-reviewer` | Reviews completed milestone | After all tasks in milestone complete |
| `bug-worker` | Fixes review issues | When review finds any issues |

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|--------------|------------------|
| Reading all milestones upfront | Exhausts context | Just-in-time loading |
| Reviewing after each task | Wastes context on repeated setup | Review once per milestone |
| Summarizing agent output | Human can't see what happened | Print full responses |
| Skipping functionality tests | Untested code ships bugs | Verify plan includes tests |
| Continuing after 3 strikes | Infinite loop on unfixable issues | Escalate to human |
| Guessing work plan path | Wrong plan, wasted effort | Always ask if not provided |

## Anti-Rationalizations

- "I'll read all milestones to understand the full scope" — No. Context limits are real. Read just-in-time.
- "I remember what the milestone said" — No. Always read just-in-time. Memory drifts.
- "I'll review after each task for faster feedback" — No. Per-milestone review is more efficient.
- "The agent response is too long, I'll summarize" — No. Human transparency requires full output.
- "Minor issues can wait until the end" — No. Fix ALL issues including Minor before proceeding.
- "Three cycles should be enough, I'll try once more" — No. Three strikes means escalate.

## Summary

1. **Just-in-time loading.** Read one milestone at a time.
2. **Print full agent responses.** Human transparency is non-negotiable.
3. **Per-milestone review.** Not per-task.
4. **Fix ALL issues.** Critical, Important, AND Minor.
5. **Three-strike rule.** Escalate persistent issues to human.
6. **Track progress with tasks.** Survive interruptions.
