---
name: commitmind-parallel-worktree
description: When two top-level sessions are about to collide on the same git checkout — different active tasks, unfamiliar files in git status, or the user wants to fan out work in parallel. Branch the second session into its own git worktree to isolate before any tool call.
metadata:
  short-description: CommitMind parallel-session worktree
---

# Parallel sessions — split via git worktree

When two top-level sessions are about to collide on the same working tree, branch the second one into its own worktree:

```sh
git worktree add ../<repo>-<task-id> -b task/<task-id>
cd ../<repo>-<task-id>
commitmind init --mcp-config-only=<editor>
```

Token / cache / hooks are inherited via the shared `.git/`, so re-running `commitmind init --mcp-config-only` only writes the per-developer editor config, not new credentials.

## Cleanup

```sh
git worktree remove ../<repo>-<task-id>
```

## Distinct from subagent isolation

This is **procedural setup for a parallel top-level session**, not the same as Claude Code's `Agent` tool with `isolation: "worktree"` (which is subagent fan-out within a single session — different problem, different mechanism).

## When to do it

- Two sessions about to write to the same files for different tasks.
- Unfamiliar files showing up in `git status` (a sign another session is mid-edit).
- Repo-wide refactors / sweeps where you want N agents working independent slices.

When in doubt, branch first — the cleanup is cheap.
