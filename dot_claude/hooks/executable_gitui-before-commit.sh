#!/bin/bash
# Opens gitui for review before Claude commits

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

if [[ "$COMMAND" =~ ^git[[:space:]]+commit ]]; then
  gitui
fi

exit 0
