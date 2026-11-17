#!/usr/bin/env bash
# Prints the saved tldr level's rules so they load into the session context.
# Config: ~/.claude/tldr.json  ->  {"default": "min" | "normal" | "max" | "off"}
config="${TLDR_CONFIG:-$HOME/.claude/tldr.json}"
[ -f "$config" ] || exit 0

level=$(grep -oE '"default"[[:space:]]*:[[:space:]]*"[a-z]+"' "$config" | grep -oE '"[a-z]+"$' | tr -d '"')
case "$level" in
  min|normal|max) ;;
  *) exit 0 ;;
esac

rules="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}/skills/tldr/levels/$level.md"
[ -f "$rules" ] || exit 0

echo "The user set tldr as their default reply style. Apply these rules to every reply in this session, unless they say \"tldr off\", change level, or ask for detail. Rules apply to prose only; code, tool calls, files and commit messages stay full quality."
cat "$rules"
