---
name: tldr
description: Use this skill whenever the user says "tldr", "tl;dr", "TLDR", "too long", "short version", "give me the gist", "tldr mode", "tldr min/normal/max", "tldr default", or asks for shorter replies by default. Covers shortening the previous reply, summarizing pasted text, files, URLs, PRs, diffs or logs, a session-long tldr mode, three levels (min, normal, max), and setting tldr as the default way Claude communicates across sessions.
---

# TL;DR

The user wants the short version. There are three levels. Read the matching file in `levels/` before replying and follow it exactly:

| Level | File | In one line |
|---|---|---|
| `min` | [levels/min.md](levels/min.md) | Full answer, padding removed. |
| `normal` | [levels/normal.md](levels/normal.md) | Answer line + up to 3 bullets. Clarity beats brevity. **Default level.** |
| `max` | [levels/max.md](levels/max.md) | One line, fragments OK, under 25 words. |

`normal` is the balanced level: shorten, but never so far that the point gets ambiguous or a warning gets lost. `min` trims less, `max` trims more.

## Commands

| User says | Do |
|---|---|
| `tldr` (alone) | Shorten your previous reply at `normal`. Don't redo the work. |
| `tldr min` / `tldr max` | Same, at that level. |
| `tldr` + text, file, URL, PR, diff or log | Read it fully, then summarize it at the level given (default `normal`). |
| `tldr <question>` | Answer the question at `normal`. |
| `tldr mode [level]` / `tldr on [level]` | Use that level (default `normal`) for every reply for the rest of this session. |
| `tldr off` / `normal mode` / `full answer` | Turn session mode off. |
| `explain more` / `details` while a mode is on | Give one full reply, then go back to the mode. |
| `tldr default <min\|normal\|max>` | Make tldr the default for every new session. See below. |
| `tldr default off` | Stop using tldr by default. |
| `tldr status` | Say the current session level and the saved default. |

## Setting the default

The default lives in `~/.claude/tldr.json`, for example `{"default": "normal"}`. The tldr plugin's SessionStart hook reads it and loads that level's rules into every new session (and again after the context is compacted).

- To set it, write the file with the requested level, e.g. `echo '{"default":"max"}' > ~/.claude/tldr.json`, then switch this session to that level too.
- To turn it off, write `{"default":"off"}`.
- Confirm in one line: "tldr default set to max; applies to new sessions."
- If the skill was installed without the plugin (no hook), say so and offer to add this line to `~/.claude/CLAUDE.md` instead: `Reply using the tldr skill at <level> level unless I ask for detail.`

## What tldr does not touch

Tldr changes only the prose written to the user. Keep these at full quality at every level:
- Code, file contents, diffs, commit messages, PR descriptions and documents you write.
- Tool calls and their arguments.
- Questions you must ask the user to proceed: short, but unambiguous.
- Anything the user explicitly asked to be detailed.

## Examples

**User:** tldr *(after a long reply comparing Postgres and SQLite)*

- **min:** Keeps the comparison, drops the intro and the "let me know" ending.
- **normal:**
  Use SQLite. You have one server and low write volume.
  - Switch to Postgres if you add a second app server.
  - Back up the `.db` file nightly; it's your only copy.
- **max:** SQLite. One server, low writes. Postgres if 2nd server. Back up `.db` nightly.

---

**User:** tldr this log *(300 lines of CI output)*

**normal:**
Build failed: `test_login_redirect` timed out after 30s in `tests/auth_test.py:88`.
- Every other test passed.
- It started failing after commit `a1b2c3d`.

---

**Bad at any level:** "Great question! Git rebase is a powerful command that lets you integrate changes from one branch into another…"
