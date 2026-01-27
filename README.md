# cyarie-claude-plugin

A curated collection of reusable skills, agents, and processes designed to enhance Claude's capabilities for software development.

## Purpose

This plugin provides a systematic approach to software excellence through codified best practices. Each skill captures patterns that improve code quality, testability, and maintainability across projects. Whether you are writing tests, designing architecture, or crafting documentation, these skills guide Claude toward consistent, high-quality output.

## Installation

### Prerequisites

- Python 3.14+
- Claude Code CLI

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/cyarie/cyarie-claude-plugin.git
   cd cyarie-claude-plugin
   ```

2. Add the plugin to your Claude configuration. In your project's `.claude/settings.local.json`:
   ```json
   {
     "plugins": [
       "/path/to/cyarie-claude-plugin"
     ]
   }
   ```

3. Restart Claude Code to load the plugin.

## Process Flow: Design to Implementation

This plugin supports a structured workflow from initial design through implementation. Each phase has dedicated skills and commands.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         DESIGN TO IMPLEMENTATION                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. DESIGN REVIEW              2. C4 DECOMPOSITION                      │
│  ┌─────────────────┐           ┌─────────────────┐                      │
│  │ /review-and-    │           │ /c4-the-design  │                      │
│  │ validate-design │  ───────► │                 │                      │
│  │                 │           │ System →        │                      │
│  │ Validates goals,│           │ Container →     │                      │
│  │ plan, milestones│           │ Component       │                      │
│  └─────────────────┘           └────────┬────────┘                      │
│                                         │                               │
│                                         ▼                               │
│  3. MILESTONE REVIEW           4. WORK PLAN CREATION                    │
│  ┌─────────────────┐           ┌─────────────────┐                      │
│  │ /start-         │           │ /build-work-    │                      │
│  │ milestone-review│  ───────► │ plan            │                      │
│  │                 │           │                 │                      │
│  │ Job stories, AC,│           │ Granular tasks, │                      │
│  │ demos for each  │           │ TDD workflow,   │                      │
│  │ milestone       │           │ test code       │                      │
│  └─────────────────┘           └────────┬────────┘                      │
│                                         │                               │
│                                         ▼                               │
│                                5. EXECUTION                             │
│                                ┌─────────────────┐                      │
│                                │ /execute-work-  │                      │
│                                │ plan            │                      │
│                                │                 │                      │
│                                │ Per-task review │                      │
│                                │ + milestone     │                      │
│                                │ integration     │                      │
│                                └─────────────────┘                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Step-by-Step Guide

#### Phase 1: Design Review

Start with a design document. Validate it covers goals, non-goals, plan, and initial milestones.

```bash
/review-and-validate-design docs/my-feature-design.md
```

**What happens**: Claude reviews the design section by section against the tech spec template, identifying gaps and suggesting improvements.

**Output**: Validated design document with clear goals, plan, and milestone list.

#### Phase 2: C4 Decomposition

Break the system into containers and components using the C4 model.

```bash
/c4-the-design docs/my-feature-design.md
```

**What happens**: Interactive decomposition with approval gates at each level:
1. System context diagram
2. Container diagram (deployable units)
3. Component diagrams (modules within containers)

**Output**: C4 diagrams (Mermaid format) added to the design document.

#### Phase 3: Milestone Review

Flesh out milestones with job stories, descriptions, acceptance criteria, and demos.

```bash
/start-milestone-review docs/my-feature-design.md
```

**What happens**: For each milestone, Claude:
1. Proposes a job story → you approve
2. Proposes a description → you approve
3. Proposes AC (max 5) → you approve
4. Proposes a demo → you approve

**Output**: Milestones with complete definitions ready for task decomposition.

#### Phase 4: Work Plan Creation

Convert milestones into granular, implementable tasks.

```bash
/build-work-plan docs/my-feature-design.md
```

**What happens**:
1. Optional branch setup
2. Codebase investigation (testing patterns, design assumptions)
3. For each milestone:
   - Classify AC as infrastructure, functionality, or integration
   - Create scaffold task (test stubs, module skeletons)
   - Create one task per AC with TDD workflow
   - Interactive review and approval
4. Code review of the plan
5. Write milestone files to disk

**Output**: Work plan files in `docs/work-plans/YYYY-MM-DD-<plan-name>/milestone_##.md`

#### Phase 5: Execution

Execute the work plan task by task with automated code review.

```bash
/execute-work-plan docs/work-plans/2025-01-26-my-feature/
```

**What happens**:
1. Reads milestones just-in-time (preserves context)
2. Dispatches `code-worker` agents for each task
3. Runs code review after every task (catches bugs early)
4. Runs milestone-level review (catches cross-task issues)
5. Fixes all issues before proceeding
6. Three-strike rule: escalates persistent issues to you

**Output**: Fully implemented and reviewed code with commit history.

### Quick Reference

| Phase | Command | Input | Output |
|-------|---------|-------|--------|
| Design Review | `/review-and-validate-design` | Raw design doc | Validated design |
| C4 Decomposition | `/c4-the-design` | Design doc | C4 diagrams |
| Milestone Review | `/start-milestone-review` | Design doc | Fleshed-out milestones |
| Work Plan | `/build-work-plan` | Design with milestones | Task files in `docs/work-plans/` |
| Execution | `/execute-work-plan` | Work plan directory | Implemented code |

## Available Skills

### Code Quality

| Skill | Description | When to Use |
|-------|-------------|-------------|
| `writing-code` | Core engineering principles: correctness, type safety, error handling | Always when writing or refactoring code |
| `writing-useful-tests` | TDD workflow, test pyramid strategy, mocking best practices | Writing or reviewing tests |
| `howto-code-in-python` | Google Python Style Guide for Python 3.12+ | Writing or reviewing Python code |
| `howto-program-functionally-ish` | Separation of pure logic from side effects | Writing or refactoring code |
| `defensive-coding` | Multi-layer validation and observability | Code handling external input or dangerous operations |

### Design and Architecture

| Skill | Description | When to Use |
|-------|-------------|-------------|
| `designing-software` | Property discovery, C4 Model, SOLID principles | Planning features or system design |
| `breaking-apart-systems` | C4 decomposition (System → Container → Component) with approval gates | Decomposing systems into buildable components |
| `reviewing-design-docs` | Structured review against tech spec template | Reviewing design documents before implementation |
| `performing-milestone-reviews` | Interactive refinement with job stories, AC, demos | Reviewing or creating milestones |
| `writing-effective-acceptance-criteria` | Testable AC with proper scoping and grain | Writing acceptance criteria for milestones |

### Work Planning

| Skill | Description | When to Use |
|-------|-------------|-------------|
| `building-a-work-plan` | Orchestrates work plan creation: setup, investigation, planning, handoff | Converting design docs to implementation tasks |
| `writing-a-work-plan` | Task decomposition patterns, TDD templates, validation rules | Defining granular tasks from milestones |

### Documentation and Process

| Skill | Description | When to Use |
|-------|-------------|-------------|
| `technical-writing` | Clarity, consistency, global accessibility (8th-grade reading level) | Jira issues, docs, READMEs, design docs |
| `writing-skills` | Creating and testing Claude skills | Developing new skills for this plugin |
| `discovering-skills` | Interactive prototyping to discover skill patterns | When you sense a pattern but cannot articulate it |

## Commands

Commands provide structured workflows for common tasks:

| Command | Description | Phase |
|---------|-------------|-------|
| `/review-and-validate-design` | Iterate through a design document section by section against the tech spec template | Design Review |
| `/c4-the-design` | Decompose a design document into C4 model (System → Container → Component) | C4 Decomposition |
| `/start-milestone-review` | Review and refine milestones with job stories, AC, and demos | Milestone Review |
| `/build-work-plan` | Convert milestones into granular tasks with TDD workflow | Work Plan Creation |
| `/execute-work-plan` | Execute a work plan with per-task code review | Execution |

### Example Usage

```bash
# Full workflow for a new feature
/review-and-validate-design docs/designs/user-auth.md
/c4-the-design docs/designs/user-auth.md
/start-milestone-review docs/designs/user-auth.md
/build-work-plan docs/designs/user-auth.md
/execute-work-plan docs/work-plans/2025-01-26-user-auth/
```

## Project Structure

```
cyarie-claude-plugin/
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata and configuration
├── skills/                      # 19 skill definitions
│   ├── breaking-apart-systems/  # C4 decomposition
│   ├── building-a-work-plan/    # Work plan orchestration
│   ├── defensive-coding/        # Input validation, error handling
│   ├── designing-software/      # Architecture and design patterns
│   ├── discovering-skills/      # Skill pattern discovery
│   ├── howto-code-in-python/    # Python style guide
│   ├── howto-program-functionally-ish/  # Pure/impure separation
│   ├── performing-milestone-reviews/    # Milestone refinement
│   ├── reviewing-design-docs/   # Design doc validation
│   ├── technical-writing/       # Documentation clarity
│   ├── writing-a-work-plan/     # Task decomposition patterns
│   ├── writing-code/            # Core engineering principles
│   ├── writing-effective-acceptance-criteria/  # AC patterns
│   ├── writing-skills/          # Skill authoring
│   └── writing-useful-tests/    # TDD and testing
├── commands/                    # User-facing entry points
│   ├── build-work-plan.md       # Work plan creation
│   ├── c4-the-design.md         # C4 decomposition
│   ├── execute-work-plan.md     # Execution (coming soon)
│   ├── review-and-validate-design.md  # Design review
│   └── start-milestone-review.md      # Milestone review
├── docs/
│   ├── examples/                # Real-world examples
│   │   ├── trackman-scraper.md          # Complete design doc
│   │   ├── trackman-component-design.md # Component design notes
│   │   ├── trackman-scraper-c4-diagrams.md      # C4 diagrams
│   │   └── trackman-scraper-milestones-review.md  # Milestone review
│   └── work-plans/              # Generated work plans (gitignored)
├── pyproject.toml               # Python project configuration
├── CLAUDE.md                    # Instructions for Claude
└── README.md
```

## Contributing

Contributions are welcome. Please follow these guidelines:

1. **Fork** the repository
2. **Create a branch** for your changes (`git checkout -b feature/your-feature`)
3. **Follow existing patterns** in the codebase
4. **Use conventional commits** for commit messages:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `refactor:` for code refactoring
   - `test:` for test additions or changes
5. **Submit a pull request** with a clear description of your changes

### Creating New Skills

See the `writing-skills` skill for guidance on creating new skills. New skills should:

- Capture patterns that aren't intuitively obvious
- Apply across multiple projects
- Follow the RED-GREEN-REFACTOR testing methodology
- Include pressure testing scenarios

## License

MIT License. See [LICENSE](LICENSE) for details.
