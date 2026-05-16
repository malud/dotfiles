#!/bin/bash
# Intercepts git commit to always prompt for user approval (review with gitui first)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

if [[ "$COMMAND" =~ git[[:space:]]+commit ]]; then
  P='\033[38;2;250;179;135m'  # Catppuccin Peach
  R='\033[0m'
  printf >&2 "\n${P}  󰊤  Review before commit!${R}\n"
  printf >&2 "${P}  ─────────────────────────${R}\n"
  printf >&2 "${P}  Open another terminal and${R}\n"
  printf >&2 "${P}  run ${R}gitui${P} to inspect${R}\n"
  printf >&2 "${P}  the staged changes.${R}\n\n"
  jq -n --arg cmd "$COMMAND" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      updatedInput: { command: $cmd }
    }
  }'
  exit 0
fi

exit 0
