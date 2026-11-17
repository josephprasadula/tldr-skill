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
| `tldr on [level]` / `/tldr on [level]` | **Save** tldr as the default (level defaults to `normal`) and use it now. Applies to this and every new session. |
| `tldr off` / `/tldr off` | **Save** tldr as off and stop using it now. |
| `tldr min` / `normal` / `max` while tldr is on | Switch level and save it. |
| `tldr mode [level]` | This session only, nothing saved. `tldr mode off` ends it. |
| `normal mode` / `full answer` | Stop tldr for this session only; the saved default is unchanged. |
| `explain more` / `details` while tldr is on | Give one full reply, then go back to tldr. |
| `tldr status` / `/tldr status` | Say the current level and the saved default. |

`tldr default <level|off>` is an alias for `tldr on <level>` / `tldr off`.

## Saving the default

The saved default is a marked block in the user's `~/.claude/CLAUDE.md`, which Claude Code loads into every session and reloads after compaction. Edit only the text between the markers. Leave everything else in that file untouched, and create the file if it doesn't exist.

**On / level change:** replace the block, or append it if there isn't one, with:

```
<!-- tldr:start -->
## tldr: on (<level>)
Reply in tldr style by default, unless I say "tldr off", change level, or ask for detail. Applies to prose only; code, tool calls, files and commit messages stay full quality.
<full contents of levels/<level>.md>
<!-- tldr:end -->
```

**Off:** delete the block, markers included.

**Status:** read the block. No block means off.

Then follow the new setting from this reply onward, and confirm in one line, e.g. "tldr on (normal), saved for new sessions." or "tldr off, saved."

On claude.ai there is no CLAUDE.md. Give the user the block text and tell them to paste it into their personal preferences in Settings.

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
