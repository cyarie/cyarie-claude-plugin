---
name: performing-code-reviews
description: Use when reviewing code for quality, security, and maintainability. Enforces verification tooling as table stakes, loads skill-based review lenses, and produces structured actionable output.
---

# Performing Code Reviews

## Overview

Code review ensures quality gates are met before integration. This skill enforces verification tooling (tests, linter, type checker) as non-negotiable infrastructure, loads domain skills as review lenses, and produces structured output with categorized issues.

## When to Use

- After implementing a feature or fix, before merge
- When reviewing pull requests
- When auditing existing code for quality
- When a numbered step from a plan is complete

## Core Pattern

### Step 1: Load Skills

Load skills in this order to create review lenses:

1. `designing-software` — architecture, separation of concerns
2. `defensive-coding` — boundary validation, error handling
3. `writing-useful-tests` — test quality, coverage analysis
4. Language-specific skill based on file types:
   - Python: `howto-code-in-python`
5. `technical-writing` — clear review output

### Step 2: Run Verification Commands

Run and document results for each:

| Tool | Required | If Missing |
|------|----------|------------|
| Test suite | Yes | Critical issue |
| Linter (ruff/eslint) | Yes | Critical issue |
| Type checker (mypy/tsc) | Yes | Critical issue |
| Build | If applicable | Report result |

**Missing verification tooling blocks the review.** These tools are table stakes for maintainable code.

### Step 3: Review Implementation

Apply each loaded skill as a lens:

**From `designing-software`**:
- Is architecture appropriate?
- Are concerns separated?
- Are abstractions at the right level?

**From `defensive-coding`**:
- Inputs validated at boundaries?
- Error handling appropriate?
- Resources properly managed?

**From language skill**:
- Style conventions followed?
- Idioms used correctly?
- Language-specific gotchas avoided?

**Cross-file patterns**:
- Duplication across similar files?
- Inconsistent patterns in related components?

### Step 4: Review Tests

For each source file:
1. Verify corresponding test file exists
2. List public methods/functions
3. Check each has test coverage
4. Verify tests test real behavior (not mocks)
5. Check error paths and edge cases

### Step 5: Categorize Issues

| Category | Criteria |
|----------|----------|
| **Critical** | Failing tests, security issues, missing verification tooling, data corruption risk |
| **Important** | Code organization, performance, missing tests, documentation gaps |
| **Minor** | Style preferences, naming, refactoring opportunities |

**Any Critical issue = review blocked.**

### Step 6: Produce Structured Output

Use this exact template:

```markdown
# Code Review: [Component/Feature Name]

## Status
**[APPROVED / BLOCKED - CHANGES REQUIRED]**

## Issue Summary
**Critical: [count] | Important: [count] | Minor: [count]**

## Verification Evidence
- Tests: [command] → [results]
- Linter: [command] → [results]
- Type checker: [command] → [results]

## Skills Applied
- [skill name]: [what it checked]

## Critical Issues (count: N)
### N. [Issue title]
**Location**: `file:line`
**Issue**: [What's wrong]
**Impact**: [Why it matters]
**Fix**: [How to resolve]

## Important Issues (count: N)
[Same format]

## Minor Issues (count: N)
[Same format]

## Decision
**[APPROVED / BLOCKED - CHANGES REQUIRED]**
```

## Quick Reference

```
1. Load skills: designing-software → defensive-coding → writing-useful-tests → language skill
2. Run verification: tests, linter, type checker (missing = Critical)
3. Review with skill lenses + cross-file patterns
4. Review test coverage (file-to-test mapping)
5. Categorize: Critical (blocks) / Important / Minor
6. Output structured report
```

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|--------------|------------------|
| Skipping verification tools | Misses entire categories of issues | Run tests, linter, type checker first |
| Reviewing without skill lenses | Ad-hoc, inconsistent coverage | Load skills systematically |
| Generic "looks good" | No actionable feedback | Use structured template with Location/Issue/Impact/Fix |
| Only reviewing within files | Miss duplication, inconsistency | Compare similar files across module |
| Approving with Critical issues | Quality gates not enforced | Any Critical = blocked, no exceptions |
| Missing verification = "note it" | Tooling is table stakes | Missing tooling is Critical, blocks review |

## Anti-Rationalizations

- "The code works, tooling can come later" — Tooling is infrastructure. Without it, you can't verify the code keeps working. Block until configured.
- "It's a small change, full review is overkill" — Small changes still need verification evidence. Use the template.
- "I'll note the test gaps as follow-up" — Missing tests for implemented code is Important. Track it in the review, don't defer.
- "The linter/type errors are false positives" — Fix the configuration or suppress with comments. Passing tools is the baseline.

## Summary

1. **Verification tooling is non-negotiable.** Missing linter, type checker, or tests = Critical issue, review blocked.
2. **Load skills as review lenses.** Each skill provides specific questions to ask.
3. **Compare similar files.** Cross-file patterns reveal duplication and inconsistency.
4. **Use the structured template.** Every issue needs Location, Issue, Impact, Fix.
5. **Any Critical issue blocks the review.** No exceptions.
