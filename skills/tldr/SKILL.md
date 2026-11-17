---
name: tldr
description: Use this skill whenever the user says "tldr", "tl;dr", "TLDR", "too long", "short version", "summarize this briefly", "give me the gist", or "tldr mode". Covers shortening the previous reply, summarizing a pasted text, file, URL, PR, diff or log, and a persistent "tldr mode" that keeps every reply short until the user turns it off.
---

# TL;DR

The user wants the short version: the key points, nothing else. Keep normal grammar and plain sentences, just far fewer of them.

## What to shorten

- **"tldr" on its own** shortens your previous reply. Don't redo the work; restate its conclusion.
- **"tldr" with pasted text, a file path, a URL, a PR, a diff or a log** summarizes that thing. Read it fully first, then write the short version.
- **"tldr <question>"** answers the question in tldr form.
- **"tldr mode"** (or "tldr on") makes every reply short for the rest of the session. **"tldr off"**, "normal mode" or "full answer" turns it off. A single "explain more" or "details" gets one full reply and then tldr mode resumes.

## Format

1. **Line one is the answer.** The verdict, the result or the main point in one sentence. No lead-in.
2. **Then up to 3 bullets**, only if they add something the first line didn't. Each bullet fits on one line.
3. **Stop.** No closing summary, no offer to elaborate, no "let me know".

Aim for under 60 words. A one-line answer is fine when one line covers it.

## Keep

- Exact names, numbers, dates, versions, file paths, commands and error messages. Never paraphrase these.
- Warnings, blockers and anything the user must act on. Losing a "this deletes your data" to save words is a bad tldr.
- Uncertainty that changes the answer ("probably X; not verified").
- A code block only when the code itself is the answer (a command to run, a one-line fix).

## Drop

- Preamble ("Great question", "Sure, here's a summary", "In short").
- Background the user didn't ask about, and restating their question.
- Hedges and filler ("basically", "essentially", "it's worth noting that").
- Step-by-step narration of how you found the answer.
- Headings, tables and nested bullets.

## Examples

**User:** tldr *(after a long reply comparing Postgres and SQLite for their app)*

**Good:**
Use SQLite. You have one server and low write volume.
- Switch to Postgres if you add a second app server.
- Back up the `.db` file nightly; it's your only copy.

---

**User:** tldr this log *(pastes 300 lines of CI output)*

**Good:**
Build failed: `test_login_redirect` timed out after 30s in `tests/auth_test.py:88`.
- Every other test passed.
- It started failing after commit `a1b2c3d`.

---

**User:** tldr what does `git rebase` do

**Good:**
It replays your branch's commits on top of another branch, so history looks like you started from its latest commit.

**Bad (too long):** "Great question! Git rebase is a powerful command that lets you integrate changes from one branch into another. Unlike merge, which creates a merge commit, rebase rewrites history by…"
