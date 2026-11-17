# tldr

A Claude skill that gives you the short version, at three levels, once or by default.

## Levels

| Level | What you get | Reply tokens saved* |
|---|---|---|
| `min` | The full answer at about half length. Optional sections dropped. | ~41% |
| `normal` | The answer in one line plus up to 3 bullets. Balanced: clarity beats brevity. | ~75% |
| `max` | One line, fragments OK, under 25 words. | ~85% |

\*Measured on 10 chat questions with Claude Opus 5.5. See [bench/RESULTS.md](bench/RESULTS.md), including why savings are much smaller in tool-heavy coding sessions.

At every level, exact names, numbers, paths, commands, errors and warnings are kept as-is. Code, files, tool calls and commit messages are never shortened.

## Use it

| Say | Get |
|---|---|
| `tldr` | The previous reply, shortened (`normal`) |
| `tldr min` / `tldr max` | Same, at that level |
| `tldr` + pasted text, a file, URL, PR, diff or log | A short summary of it |
| `tldr <question>` | A short answer |
| `tldr mode [level]` / `tldr off` | Short replies for this session |
| `tldr default <min\|normal\|max>` | Short replies by default in every new session |
| `tldr default off` | Back to normal replies by default |
| `tldr status` | Current level and saved default |

You can also call it directly with `/tldr`.

## Making tldr the default

`tldr default normal` writes `~/.claude/tldr.json`:

```json
{"default": "normal"}
```

The plugin's SessionStart hook reads that file and loads the level's rules at the start of every session, and again after compaction. You can also edit the file by hand. `"off"`, or deleting the file, turns it off.

Without the plugin (skill folder only), add this line to `~/.claude/CLAUDE.md` instead:

```
Reply using the tldr skill at normal level unless I ask for detail.
```

## Install

### Claude Code (plugin: includes the default-mode hook)

```
/plugin marketplace add josephprasadula/tldr-skill
/plugin install tldr@josephprasadula-plugins
```

### Claude Code (skill folder only)

```
git clone https://github.com/josephprasadula/tldr-skill
cp -r tldr-skill/skills/tldr ~/.claude/skills/
```

### claude.ai

Zip the `skills/tldr` folder and upload it in **Settings → Capabilities → Skills**.

## Layout

```
.claude-plugin/        plugin + marketplace manifests
skills/tldr/SKILL.md   commands and rules
skills/tldr/levels/    min.md, normal.md, max.md (one source of truth per level)
hooks/                 SessionStart hook that applies the saved default
bench/                 token benchmark: run.sh, prompts, RESULTS.md
```

## Benchmark

```
bench/run.sh            # ~40 headless calls, roughly $1
bench/run.sh sonnet     # or pick a model
```

## License

MIT
