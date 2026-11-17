# Token savings: results

Measured 2026-11-17 on `claude-opus-5-5` with Claude Code 2.1.326, by running `bench/run.sh`.

## Method

- 10 typical chat questions (`prompts.txt`): explanations, comparisons, how-tos, a debugging question, a safety question.
- Each one was run headless with tools off, so only the reply prose is measured. It ran once with no style (base) and once per level, with that level's rules injected exactly as the SessionStart hook does it.
- For a noise estimate, base was run 40 times in total (4 per prompt). Mean 1,021 output tokens, standard deviation 387. **The same prompt can vary ±15% in length between runs**, so differences under ~15% are noise.

## Reply length per level

| Level | Avg output tokens | Avg words | Saved vs base |
|---|---|---|---|
| base | 1,021 | 386 | — |
| min | 600 | 233 | **41%** |
| normal | 254 | 95 | **75%** |
| max | 150 | 45 | **85%** |

The first version of `min` only removed padding and saved 10%, which is within noise. It now also drops optional sections (background, edge cases, tables), which brings it to 41%.

Per prompt (output tokens):

| # | Prompt | base | min | normal | max |
|---|---|---|---|---|---|
| 1 | git rebase vs merge | 873 | 512 | 154 | 90 |
| 2 | SQLite or Postgres | 675 | 434 | 166 | 63 |
| 3 | React infinite re-render | 980 | 601 | 325 | 274 |
| 4 | SSH key login setup | 1,220 | 764 | 488 | 274 |
| 5 | How HTTPS works | 1,271 | 750 | 433 | 326 |
| 6 | Process vs thread | 621 | 409 | 135 | 46 |
| 7 | CORS error | 711 | 461 | 195 | 98 |
| 8 | `chmod -R 777` safe? | 910 | 530 | 180 | 140 |
| 9 | Godot vs Unity | 1,754 | 971 | 309 | 113 |
| 10 | Microservices vs monolith | 784 | 565 | 152 | 73 |

Quality check: in #8, both `normal` and `max` still opened with "No" and the security warning, and gave the correct `chown`/`755`/`644` fix. Step-by-step questions (#4, #5) shrink least, because the steps themselves are kept.

## What that's worth in money

Prices were derived from the benchmark's own cost data: output costs about **$20 per 1M tokens**, and re-reading cached context about **$0.40 per 1M**.

A shorter reply saves in two ways:

1. **Output, once:** at `normal`, ~770 fewer tokens ≈ **$0.015 per reply**.
2. **Context, every later turn:** those 770 tokens are no longer re-read on each later turn ≈ $0.0003 per turn. Over 20 later turns that's ≈ $0.006.

So about 70% of the saving is the output itself, and about 30% comes from a smaller context. Shorter context also delays auto-compaction.

The cost of turning tldr on: the hook adds ~150–220 tokens of rules to each session. That's roughly $0.0001 per turn to re-read, which is negligible.

## Chat sessions vs coding sessions

**Chat / Q&A sessions** are almost all prose, so the table above applies directly. Over 20 questions at `normal`: ~20k → ~5k output tokens, ≈ $0.41 → $0.10.

**Agentic coding sessions** are different. In 20 real Claude Code sessions (from local transcripts), the conversation context broke down like this:

| Part of context | Share |
|---|---|
| Tool results (file reads, command output) | 82.8% |
| Assistant tool calls (edits, commands) | 11.9% |
| User messages | 3.3% |
| **Assistant prose to the user** | **2.0%** |

tldr only touches that 2%. Even at `max`, context shrinks by under 2%. Prose was ~15% of assistant output in those sessions, so `normal` saves ~11% of output tokens there. In coding sessions the main gain is readability, not cost; the cost savings are real but small.

On a subscription plan, savings show up as usage-limit headroom rather than dollars.
