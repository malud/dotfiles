#!/usr/bin/env bash
# Start herdr in the {{ .profile }} session: own herdr server, workspaces and
# shell history, {{ .profile }} Claude and Codex logins. herdr config and
# plugins stay shared across sessions.
set -euo pipefail

export CLAUDE_CONFIG_DIR="$HOME/.claude-{{ .profile }}"
{{ if .codexHome -}}
export CODEX_HOME="$HOME/{{ .codexHome }}"
mkdir -p "$CODEX_HOME"
{{ else -}}
unset CODEX_HOME
{{ end -}}
export HISTFILE="$HOME/.bash_history_{{ .profile }}"

exec herdr --session {{ .profile }} "$@"
