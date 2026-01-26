---
name: writing-a-work-plan
description: Use when converting design documents and milestones into granular implementation tasks. Covers scope validation, codebase verification, task decomposition by type (infrastructure, functionality, integration), and TDD-aligned workflows.
---

# Writing Work Plans

## Overview

Work plans bridge design intent and implementation. A design document describes *what* to build and *why*; a work plan tells implementers (human engineers or LLM agents) exactly *how* — which files to create, what code to write, what tests to run, and how to verify correctness. This skill guides the conversion of milestone-level acceptance criteria into bite-sized, TDD-aligned tasks.

## Required Sub-Skills

Always load these when writing work plans:

| Skill | Purpose |
|-------|---------|
| [writing-code](../writing-code/SKILL.md) | Engineering principles, sub-skill loading |
| [writing-useful-tests](../writing-useful-tests/SKILL.md) | TDD workflow, Arrange/Act/Assert, single-assertion tests |
| [writing-effective-acceptance-criteria](../writing-effective-acceptance-criteria/SKILL.md) | AC testability and grain checks |

## When to Use

- After design review and milestone approval
- When milestones have job stories, descriptions, AC, and demos defined
- When C4 diagrams exist (at least container level, preferably component level)
- When you need to hand off implementation to another engineer or agent

## When NOT to Use

- During design exploration (use design skills first)
- When milestones are vague or lack AC (use `performing-milestone-reviews` first)
- For single-file fixes that don't need planning

## Entry Point

When the user invokes this skill or requests a work plan:

1. **Locate the design document.** Ask for the path if not provided.
2. **Validate scope.** Check milestone count (see Phase 1).
3. **Choose review mode.** Ask user:
   - Interactive: plan one milestone, review, proceed
   - Batch: plan all milestones, then review all
4. **Process milestones.** Follow the Core Pattern below.

## Core Pattern

### Phase 1: Validate Scope

Count milestones in the design document.

| Count | Action |
|-------|--------|
| ≤8 | Proceed |
| >8 | Stop. Ask user to split the design doc or justify why this scope is necessary. |

The 8-milestone limit is a smell detector. Larger scope often indicates the design covers multiple features that should be planned separately.

### Phase 2: Codebase Verification (Pre-Planning)

Before writing any tasks, verify the codebase matches design assumptions.

**Step 1**: Dispatch `codebase-investigator` agent to investigate **testing patterns**:
- How are tests structured in this codebase?
- What mocking patterns exist?
- What fixtures are available?
- Where do tests live (`tests/`, `test/`, colocated)?

**Step 2** (Sequential, after Step 1): Dispatch `codebase-investigator` agent to verify **design assumptions**:
- Do files exist where the design expects them?
- Do expected features/dependencies exist?
- Is there drift between design doc and current code?
- Are there naming conventions to follow?

Document findings in the milestone plan header.

### Phase 3: Write Milestone Plan (Interactive)

Process milestones one at a time. For each milestone:

#### 3A: Read the Milestone

Extract from design doc:
- Job story
- Description
- Acceptance criteria (list)
- Demo
- Components covered

#### 3B: Classify Each AC

| Type | Characteristics | Verification |
|------|-----------------|--------------|
| **Infrastructure** | Creates files, config, scaffolding | Operational (builds, runs, imports) |
| **Functionality** | Implements behavior, core logic | Unit tests (TDD) |
| **Integration** | Wires components together | Integration tests (TDD) |

#### 3C: Create Scaffold Task (if applicable)

For functionality or integration milestones, create a scaffold task first:

```markdown
**Task N.1: Scaffold [Component] with test stubs**

| Field | Value |
|-------|-------|
| **Job Story** | When I start implementing [Component], I want the module structure in place. |
| **Description** | Create module file with class skeleton and test file with test stubs. |
| **AC** | Module and test files exist; pytest runs without errors |
| **Type** | Infrastructure |

**Implementation Steps**:
1. Create `src/[path]/[module].py` with class skeleton
2. Create `tests/[path]/test_[module].py` with test stubs:
   - `test_[ac_1_behavior]`
   - `test_[ac_2_behavior]`
   - ...
3. Verify: `pytest tests/[path]/test_[module].py` runs
4. Commit: "feat(mN): scaffold [Component] with test stubs"
```

#### 3D: Create One Task Per AC

**For Infrastructure AC**:

```markdown
**Task N.X: [Description]**

| Field | Value |
|-------|-------|
| **Job Story** | When [situation], I want [motivation], so [outcome]. |
| **Description** | [What this task creates/configures] |
| **AC** | [The specific AC being addressed] |
| **Type** | Infrastructure |

**Implementation Steps**:
1. Create/modify [file]
2. [Additional steps...]
3. Verify: [Operational check — command runs, builds succeed, import works]
4. Commit: "[type](mN): [description]"
```

**For Functionality AC** (TDD):

```markdown
**Task N.X: [Description] (TDD)**

| Field | Value |
|-------|-------|
| **Job Story** | When [situation], I want [motivation], so [outcome]. |
| **Description** | TDD implementation of [behavior]. |
| **AC** | [The specific AC being addressed] |
| **Type** | Functionality |

**Implementation Steps**:
1. **Red**: Write failing test:
   ```python
   def test_[behavior](fixtures...):
       # Arrange
       [setup code]

       # Act
       result = [call under test]

       # Assert
       assert [single assertion]
   ```
2. Verify: Test **fails**
3. **Green**: Implement minimal code to pass the test
4. Verify: Test **passes**
5. Commit: "feat(mN): [description]"
```

**For Integration AC** (TDD):

```markdown
**Task N.X: Wire and test [command/flow]**

| Field | Value |
|-------|-------|
| **Job Story** | When [user action], I want [end-to-end behavior]. |
| **Description** | Wire [components] together; test full flow. |
| **AC** | [The specific AC being addressed] |
| **Type** | Integration |

**Implementation Steps**:
1. **Red**: Write integration test:
   ```python
   def test_[flow](cli_runner, fixtures...):
       # Arrange
       [mock setup]

       # Act
       result = cli_runner.invoke(app, ["command", "args"])

       # Assert
       assert result.exit_code == 0
       assert [expected output]
   ```
2. Verify: Test **fails**
3. **Green**: Wire components in command handler
4. Verify: Test **passes**
5. Commit: "feat(mN): wire [command]"
```

#### 3E: Check for Compound AC

If an AC implies multiple assertions or behaviors, split into multiple tasks. Each test should have a **single assertion** following Arrange/Act/Assert.

#### 3F: Review with User

Present the task breakdown for approval:
- List all tasks with types
- Highlight any assumptions made
- Note any issues or open questions

Get explicit approval before proceeding to the next milestone.

### Phase 4: Codebase Verification (Post-Planning)

After writing tasks for a milestone:

1. Dispatch `codebase-investigator` to verify **tasks are implementable**:
   - Do target files/directories exist?
   - Are import paths valid?
   - Any conflicts with existing code?

2. If issues found:
   - Update tasks to match reality
   - Or flag for user decision

### Phase 5: Code Review

Run `code-reviewer` agent over the milestone plan.

**Review mode** (user chooses at session start):
- **Fix before presenting**: Automatically fix issues; user sees clean plan
- **Present issues to user**: Show issues for user decision

### Phase 6: Write to Disk

Create directory structure:
```
docs/work-plans/YYYY-MM-DD-<plan-name>/
├── milestone_01.md
├── milestone_02.md
├── ...
└── milestone_NN.md
```

## Document Format

### Milestone Plan Header

```markdown
# Milestone N: [Title]

## Context

**Goal**: [One sentence describing what this milestone achieves]

**Architecture**: [Which C4 container/component this covers; relevant design decisions]

**Tech Stack**: [Technologies used in this milestone]

**Scope**: [Design doc phase this covers; reference to design doc]

**Codebase Verification**:
- Last verified: [timestamp]
- Testing patterns: [summary of findings]
- Design assumptions: [confirmed/issues found]

**References**:
- Design doc: [path]
- C4 diagrams: [path]
- Related code: [paths]

---

## Tasks

[Tasks follow here]
```

### Task Template

```markdown
### Task N.X: [Title]

| Field | Value |
|-------|-------|
| **Job Story** | When [situation], I want [motivation], so [outcome]. |
| **Description** | [What this task does] |
| **AC** | [The acceptance criterion being addressed] |
| **Type** | Infrastructure / Functionality / Integration |
| **Blocks** | [Tasks that cannot start until this completes] |
| **Blocked By** | [Tasks that must complete before this can start] |

**Implementation Steps**:
1. [Step 1]
2. [Step 2]
3. Verify: [How to verify this task is complete]
4. Commit: "[type](mN): [message]"
```

## Validation Checklist

Before finalizing each milestone plan:

- [ ] All AC have corresponding tasks
- [ ] No compound AC (each task tests one behavior)
- [ ] Scaffold task exists for functionality/integration milestones
- [ ] Each functionality/integration task includes test code
- [ ] Verification steps are explicit (not assumed)
- [ ] Commit messages follow conventions
- [ ] Task dependencies noted (blocks/blocked by)
- [ ] Codebase verification completed (pre and post)

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|--------------|------------------|
| Skipping scaffold task | Tests have nowhere to live | Always scaffold first |
| Multiple assertions per test | Unclear which behavior failed | One assertion per test |
| Assuming verification | Implementers skip verification | Explicit verify steps |
| Copying code from design doc | Design docs get stale | Generate fresh code based on codebase investigation |
| Batch planning without review | Early mistakes compound | Interactive milestone-by-milestone |
| Skipping codebase verification | Tasks may not be implementable | Verify before AND after planning |

## Anti-Rationalizations

- "This milestone is simple, skip scaffolding" — Simple milestones still benefit from structure. Scaffold anyway.
- "The design doc has the code" — Design docs are directional. Generate fresh code based on current codebase.
- "I'll combine these tasks to save time" — Granular tasks provide clearer progress signals. Keep them separate.
- "Codebase verification is overhead" — Verification prevents planning tasks for files that don't exist. Do it.
- "The implementer will figure out verification" — They won't, or they'll do it inconsistently. Be explicit.

## Task Tracking

When working through this skill, create tasks for your own progress:

```
Phase NA: Read milestone N from design doc
Phase NB: Investigate codebase (testing patterns)
Phase NC: Investigate codebase (design assumptions)
Phase ND: Write milestone N tasks
Phase NE: Post-planning verification
Phase NF: Code review
Phase NG: User approval
```

Use `TaskCreate` and `TaskUpdate` to track progress. Note blocking dependencies.

## Summary

1. **Verify codebase before planning.** Design docs drift; ground your plan in reality.
2. **One AC = one task.** Granular tasks provide clear completion signals.
3. **Three task types.** Infrastructure (operational), Functionality (unit TDD), Integration (integration TDD).
4. **Always scaffold first.** Test files and module skeletons before TDD cycles.
5. **Include test code.** Concrete examples guide implementers.
6. **Explicit verification.** Never assume implementers will verify or commit.
7. **Interactive review.** Approve each milestone before proceeding to the next.
