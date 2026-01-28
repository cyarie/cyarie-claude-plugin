#!/usr/bin/env bash

# Skill Reinforcement Hook
# Outputs context reminding Claude to evaluate and activate relevant skills

set -euo pipefail

# Determine plugin root directory
CC_SCRIPT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
CC_PLUGIN_ROOT="$(cd "${CC_SCRIPT_DIRECTORY}/.." && pwd)"

cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "<YOU_MUST_READ_THIS>Before responding to this prompt, consider whether you have any skills in <available_skills /> that apply. If you do and they have not been activated in this session, use the Skill tool to activate them.</YOU_MUST_READ_THIS>"
  }
}
EOF

exit 0
