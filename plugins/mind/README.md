# CommitMind for OpenAI Codex CLI

The Codex CLI counterpart to `apps/plugin-claude`. Gives Codex sessions
the same deterministic memory, code-intelligence, and task workflows by
reusing the `commitmind` daemon through a **host-adapter** (`commitmind
hook --host codex …`). Requires the `commitmind` CLI installed and the
repo authenticated.

> **Status: functional, validated against codex-cli 0.141.** The full
> hook set (SessionStart / UserPromptSubmit / PreToolUse / PostToolUse /
> Stop), the 5 routing skills + 3 command-skills, the MCP servers, and a
> one-command installer all work end-to-end. Marketplace distribution
> (`codex plugin` validation of the manifest + a publish target) is the
> remaining follow-up (task 952e711 / spec `commitmind-codex-cli-plugin`).

## How it differs from the Claude plugin

Codex's hook system is a near-clone of Claude Code's at the wire level,
with three differences the adapter absorbs:

| | Claude Code | Codex CLI |
|---|---|---|
| Edit tool | `Edit` / `Write` / `MultiEdit` (with `file_path`) | `apply_patch` (path inside the patch text) |
| Hook bundling | hooks ship **inside** the plugin | `plugin_hooks` removed — hooks install to `~/.codex/hooks.json` |
| Trust | trusted on install | hash-pinned; must `/hooks` trust before they fire |

The daemon's `--host codex` flag normalizes the envelope (`apply_patch →
Edit`, lifts the patched path into `file_path`, reads the explicit
`cwd`). SessionStart, the output protocol (`hookSpecificOutput.
additionalContext` injection + exit-2 blocks), and MCP tool names
(`mcp__mind__*`) are byte-identical to Claude and need no translation.

## Install

```bash
commitmind codex install
```

`commitmind init` also **auto-detects Codex** (the `codex` binary or
`~/.codex`) and offers to run this for you; `commitmind update` refreshes
an existing install with new hook entries. Run it directly any time:

This writes `~/.codex/hooks.json` (SessionStart prime + post-compact
reprime, the full PreToolUse/PostToolUse/Stop gate set, and a
SubagentStart anchoring hook — host-adapted for Codex) and
registers the `mind` / `mind-code` MCP servers via the `codex` CLI. Then
**trust the hooks**: in the Codex TUI run `/hooks` and approve them —
Codex hash-pins hook definitions and skips untrusted ones. Re-run with
`--force` to overwrite an existing `~/.codex/hooks.json`.

The installer invokes the `commitmind` binary directly (resolved
absolute path), so no launcher scripts are needed at runtime.

### Manual install (reference)

The `hooks/hooks.json` template + `scripts/` launchers mirror what the
installer generates, for hand-installs or inspection:

1. `codex mcp add mind -- commitmind mcp serve` (and `mind-code` →
   `mcp serve-code`).
2. `ROOT="$(pwd)"; sed "s#__PLUGIN_ROOT__#${ROOT}#g" hooks/hooks.json >
   ~/.codex/hooks.json` (merge by hand if you already have one).
3. `/hooks` in the TUI to trust.

## Verify

Start a Codex session in a CommitMind-connected repo. You should see the
primed context injected at the top, and an edit attempted with no task
pinned is blocked with the anchor-gate message. Headless smoke test:

```bash
codex exec --skip-git-repo-check \
  "Create a file foo.txt with content hi." 
# → blocked by the anchor gate when no task is pinned
```
