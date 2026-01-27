---
name: update-context
---

Dispatch the `documentarian` agent to update project context documentation.

**What this does**:
1. Analyzes recent code changes (git diff)
2. Categorizes changes as contract or internal
3. Identifies which CLAUDE.md files need updates
4. Drafts updates following technical-writing standards
5. Presents proposed changes for your approval
6. On approval, commits documentation separately from code

**Required input**: None (uses current git state). Optionally provide a base commit SHA.

**Key behaviors**:
- **Contract focus**: Only documents API changes, new modules, and architectural decisions. Skips bug fixes and refactoring.
- **Human approval**: You approve all changes before they are committed.
- **Separate commits**: Documentation changes are committed separately from code changes.
- **Verbose output**: Full proposed content is shown, not summaries.

**When to use**:
- After completing a work plan execution
- After significant refactors
- When new domains or modules are created
- When APIs or interfaces change
