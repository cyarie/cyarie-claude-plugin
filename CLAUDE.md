# CLAUDE.md

Instructions for Claude when working in this repository.

## Overview

This is a Claude plugin containing reusable skills for software development. When working here, use the skills defined in this plugin to maintain consistency and quality.

## Working in This Repository

### Activate Relevant Skills

When performing tasks in this codebase, activate the appropriate skills:

**Code Quality**
- **Writing or modifying skills**: Use `/writing-skills` for guidance on skill structure and testing
- **Writing Python code**: Use `/howto-code-in-python` for style conventions
- **Writing tests**: Use `/writing-useful-tests` for TDD workflow and testing patterns
- **Writing documentation**: Use `/technical-writing` for clarity and accessibility standards
- **Refactoring code**: Use `/howto-program-functionally-ish` to separate pure logic from side effects

**Design and Architecture**
- **Designing systems**: Use `/designing-software` for C4 model and architecture patterns
- **Decomposing designs**: Use `/c4-the-design` command to break down a design into containers and components
- **Reviewing milestones**: Use `/start-milestone-review` command to refine milestone definitions
- **Writing acceptance criteria**: Use `/writing-effective-acceptance-criteria` for testable AC

**Design-to-Implementation Workflow**

The full workflow from design to implementation follows this sequence:

```
/review-and-validate-design → /c4-the-design → /start-milestone-review → /build-work-plan → /execute-work-plan
```

Each command hands off to the next with clear instructions. Run `/clear` between steps to maintain fresh context.

### Skill Development Guidelines

When creating or modifying skills:

1. Skills should capture patterns that aren't intuitively obvious
2. Skills should apply across multiple projects, not be project-specific
3. Follow the RED-GREEN-REFACTOR testing methodology for skills
4. Include pressure testing scenarios to validate skill effectiveness

### File Structure

- Skills live in `skills/<skill-name>/`
- Each skill directory contains a `SKILL.md` file with directives and optional reference files
- Commands live in `commands/` and provide user-facing entry points
- Plugin configuration is in `.claude-plugin/plugin.json`
- Examples live in `docs/examples/` demonstrating end-to-end workflows

### Conventions

- Use conventional commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`)
- Follow existing patterns in the codebase
- Keep skill directives clear and actionable
- Target 8th-grade reading level for documentation (Flesch-Kincaid 60-70)
