#!/usr/bin/env bash
# Save or show the default tldr level for new sessions.
# Usage: set-default.sh <min|normal|max|off|status>
config="${TLDR_CONFIG:-$HOME/.claude/tldr.json}"
current=$(grep -oE '"default"[[:space:]]*:[[:space:]]*"[a-z]+"' "$config" 2>/dev/null | grep -oE '"[a-z]+"$' | tr -d '"')

case "${1:-status}" in
  min|normal|max|off)
    mkdir -p "$(dirname "$config")"
    printf '{"default": "%s"}\n' "$1" > "$config"
    echo "saved: default=$1 (was ${current:-off}) in $config"
    ;;
  status)
    echo "default=${current:-off} ($config)"
    ;;
  *)
    echo "usage: set-default.sh <min|normal|max|off|status>" >&2
    exit 1
    ;;
esac
