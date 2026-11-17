# tldr

A Claude skill that gives you the short version.

## Use it

| Say | Get |
|---|---|
| `tldr` | The previous reply, shortened |
| `tldr` + pasted text, a file, URL, PR, diff or log | A short summary of it |
| `tldr <question>` | A short answer |
| `tldr mode` / `tldr off` | Short replies for the whole session, until you turn it off |

You can also call it directly with `/tldr`.

Every tldr leads with the answer in one line, adds up to 3 bullets only if needed, and keeps exact names, numbers, paths, commands and warnings.

## Install

### Claude Code (as a plugin)

```
/plugin marketplace add josephprasadula/tldr-skill
/plugin install tldr@josephprasadula-plugins
```

### Claude Code (as a plain skill)

```
git clone https://github.com/josephprasadula/tldr-skill
cp -r tldr-skill/skills/tldr ~/.claude/skills/
```

### claude.ai

Zip the `skills/tldr` folder and upload it in **Settings → Capabilities → Skills**.

## License

MIT
