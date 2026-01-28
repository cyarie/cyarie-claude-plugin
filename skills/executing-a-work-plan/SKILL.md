---
name: executing-a-work-plan
description: Use when executing a work plan created by building-a-work-plan. Orchestrates milestone-by-milestone implementation using code-worker agents with per-milestone code review.
command: execute-work-plan
---

# Executing a Work Plan

## Overview

This skill orchestrates the execution of work plans created by `building-a-work-plan`. It processes milestones sequentially, dispatching `code-worker` agents for each task, then conducting code review after all tasks in a milestone are complete. The goal is complete, reviewed implementation — not just "code that works."

## Key Principles

### Human Transparency

**After every agent completes, print their full response before taking further action.**

The human cannot see subagent outputs directly. You are their window into the work. Show all details:
- Test counts and results
- Issue lists with locations (file:line for EVERY issue)
- Commit hashes
- Error messages
- Verification evidence

**Never summarize agent output. Print it completely.**

**For code reviews specifically**: Print the ENTIRE structured report including:
- Status (APPROVED/BLOCKED)
- Issue Summary counts
- Verification Evidence (actual command outputs)
- Every issue with Location, Issue, Impact, Fix
- Decision

Do NOT write: "The code review found 2 Important issues..."
DO write: [paste the full markdown report from the code-reviewer]

### Just-in-Time Loading

**Never load all milestones upfront.**

Read one milestone, execute all its tasks, review, then move to the next. This preserves context within token budgets. If you read everything at once, you'll run out of context before finishing.

### Per-Milestone Review

**Review after all tasks in a milestone are complete, not after each individual task.**

Per-milestone review balances thoroughness with efficiency. Reviewing every task individually consumes significant context and time. Milestone-level review catches cross-task integration issues while keeping execution focused.

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
   ◻ Task 1.1: [task title]
   ◻ Task 1.2: [task title]
   ...
   ◻ Milestone 1 Review: Review all tasks → Fix issues
◻ #3 Execute Milestone 2: [title]
   ◻ Task 2.1: [task title]
   ...
   ◻ Milestone 2 Review: Review all tasks → Fix issues
... (repeat for each milestone)
◻ #N Final Review: Full implementation review
◻ #N+1 Complete: Summary and handoff
```

Each task follows: Implement → Record completion → Next Task.
Each milestone ends with: Milestone Review → Fix all issues → Next Milestone.

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

#### 2c. Execute Tasks

For each task in the milestone:

**Step 1: Check dependencies**

If blocked by incomplete tasks, skip and note.

**Step 2: Dispatch `code-worker` agent**

```
Implement this task from the work plan:

Milestone file: [absolute path]
Task: [task number and title]

The task specification is in the milestone file. Read it, implement it following TDD,
run verification, update the work plan file, and commit.

Report back with your completion report.
```

**Step 3: Print the full agent response.** Do not summarize.

**Step 4: Record completion**

Note task number and commit SHA.

**Step 5: Proceed to next task**

Continue until all tasks in the milestone are complete.

#### 2d. Three-Strike Rule (Per Milestone)

If the same issue persists after three review cycles for a milestone:

```
ESCALATION REQUIRED

Milestone: [milestone number and title]
Issue "[issue title]" has persisted through 3 review cycles.

Location: [file:line]
Issue: [description]
Attempted fixes:
  Cycle 1: [what was tried]
  Cycle 2: [what was tried]
  Cycle 3: [what was tried]

This requires human intervention. Please review and advise.
```

Stop and wait for human guidance. Do not continue to next milestone.

#### 2e. Milestone Review

After all tasks in the milestone are complete:

1. **Capture git state**:
```bash
BASE_SHA=$(git rev-parse HEAD~N)  # Before first task's commit (N = number of tasks)
HEAD_SHA=$(git rev-parse HEAD)     # After last task's commit
```

2. **Run milestone-level review** covering all tasks:
   - Use `requesting-code-review` skill
   - Reference the full milestone
   - Include commit range from milestone start to end

3. **This catches**:
   - Issues in individual task implementations
   - Integration problems between tasks
   - Inconsistent patterns across tasks
   - Missing edge cases at boundaries

4. **Handle review results**:
   - **Zero issues**: Mark milestone complete, proceed to next milestone
   - **Any issues**: Dispatch `bug-worker` agent to fix ALL issues (Critical, Important, Minor)

5. **Print full review and fix responses.**

6. **Re-review after fixes.** Loop until zero issues for this milestone.

#### 2f. Proceed to Next Milestone

After milestone completion review passes, mark milestone complete. Move to next milestone's read step.

### Step 3: Final Review

After all milestones are complete:

1. **Run full implementation review** using `requesting-code-review` skill
2. **Fix any remaining issues** with `bug-worker`
3. **Loop until zero issues**

### Step 3a: Update Project Context

After final review passes with zero issues:

1. **Capture the full commit range**:
```bash
# Base: commit before work plan execution started
# HEAD: current commit after all work is done
```

2. **Dispatch `documentarian` agent**:
```
Analyze the changes from this work plan execution and update project context.

Work plan: [absolute path to work plan directory]
Base commit: [commit SHA before execution started]
HEAD: [current HEAD]

Focus on contract-level changes: new modules, API changes, architectural decisions.
Skip internal implementation details.

Present updates for human approval before committing.
```

3. **Print the full agent response.** Human transparency applies here too.

4. **Wait for human approval.** The documentarian agent handles this via AskUserQuestion.

5. **Proceed to completion report** after context updates are committed (or skipped by user choice).

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
| `code-reviewer` | Reviews completed work | After all tasks in a milestone are complete |
| `bug-worker` | Fixes review issues | When any review finds issues |
| `documentarian` | Updates project context files | After final review passes, before completion report |

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|--------------|------------------|
| Reading all milestones upfront | Exhausts context | Just-in-time loading |
| Skipping milestone review | Bugs and cross-task issues missed | Review after ALL tasks in milestone complete |
| Summarizing agent output | Human can't see what happened | Print full responses |
| Skipping functionality tests | Untested code ships bugs | Verify plan includes tests |
| Continuing after 3 strikes | Infinite loop on unfixable issues | Escalate to human |
| Guessing work plan path | Wrong plan, wasted effort | Always ask if not provided |
| Skipping context update | Future agents lack accurate context | Always dispatch documentarian after final review |

## Anti-Rationalizations

- "I'll read all milestones to understand the full scope" — No. Context limits are real. Read just-in-time.
- "I remember what the milestone said" — No. Always read just-in-time. Memory drifts.
- "I'll skip the milestone review since each task was tested" — No. Tests verify individual behavior; review catches cross-task integration issues and code quality problems.
- "The agent response is too long, I'll summarize" — No. Human transparency requires full output.
- "I'll just say how many issues were found" — No. Print every issue with Location, Issue, Impact, Fix. The user needs details to understand what's happening.
- "Minor issues can wait until the end" — No. Fix ALL issues including Minor before proceeding.
- "Three cycles should be enough, I'll try once more" — No. Three strikes means escalate.
- "The code is self-documenting" — No. Contract-level context helps future agents understand intent, not just implementation. Dispatch the documentarian.

## Summary

1. **Just-in-time loading.** Read one milestone at a time.
2. **Print full agent responses.** Human transparency is non-negotiable.
3. **Per-milestone review.** Review after all tasks in a milestone are complete.
4. **Fix ALL issues.** Critical, Important, AND Minor.
5. **Three-strike rule.** Escalate persistent issues to human.
6. **Track progress with tasks.** Survive interruptions.
