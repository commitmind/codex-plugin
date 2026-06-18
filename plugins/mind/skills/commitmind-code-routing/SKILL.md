---
name: commitmind-code-routing
description: When the user asks where a Go / TS / TSX / JS / Python / Rust / Java symbol is defined, called from, what is in a file, or wants to find code by content — use xref over grep / Read on indexed code. xref is deterministic and does not load file contents.
metadata:
  short-description: CommitMind code routing
---

# Code-routing — use xref over grep/Read for indexed code

There is one code-navigation tool — `xref` — and the operation is encoded in the argument shape.

## Routing

| Question | Call |
| --- | --- |
| Where is X defined? | `xref(query="X")` |
| Where is X called from? | `xref(query="X<")` |
| What's in this file? | `xref(query="path/to/file.go")` |
| Show me the body of X | `xref(query="path/file.go::X")` (kind defaults to function; pass `kind=type\|class\|const` to override) |
| Code content / cross-cutting pattern | `xref(query="phrase", mode="fts")` or `mode="substring"` for hyphenated / regex-source / partial-literal fragments |
| Find a CODE SHAPE / call pattern (every `eval`, every `os.Getenv`) | `xref(query="eval($X)", mode="structural")` — AST match (`$X` = metavar, `$$$` = ellipsis); binds matches, formatting-resilient, skips comment/string false positives |
| Memory layer (prior decisions, rationale) | `search_memory` |
| String literal in non-code (config, markdown, SQL, deps) | grep / ripgrep / Read |
| Untracked paths (not in `git ls-files`) / non-code / cold cache | grep / ripgrep / Read |

**Mixed case** — a name that appears as BOTH an identifier and a string literal (tool registrations, test fixtures, error message constants): call `xref` FIRST; fall back to grep only if it returns nothing.

## Empty result on xref ≠ "go to grep"

First retry the ladder:

- Name lookup empty → retry `case_sensitive=false`, then `match="prefix"`
- Callers (`Foo<`) empty → pivot to `xref("Foo", mode="substring")` — covers literal mentions / dynamic dispatch
- `mode="fts"` empty → drop tokens (FTS ANDs every token), or retry `mode="substring"` for hyphenated/underscored/regex names, or drop `path_prefix`/`kind`
- Body fetch (`file::Foo`) not_found while `xref("file")` lists Foo → retry `xref(query="Foo")` to disambiguate, then re-issue with the path the name lookup returned. Don't fall through to Read / sed.

## Indexed languages

Go, TypeScript (.ts/.mts/.cts), TSX, JavaScript (.js/.jsx/.mjs/.cjs), Python, Rust, Java. The xref suffix grammar is language-agnostic — same shapes work for all.

## Parallel work

Fan out when edges are independent. For tasks with ≥3 independent edges (repo-wide rule sweeps, multi-package refactors, batched migrations, broad reference-update passes), prefer parallel agents in isolated git worktrees. Worktree isolation lets shared files (go.sum, go.work, package-lock.json) be edited in parallel without races; review each agent's diff independently before merging. Stay sequential when edges share output state, the work is small (<3 edges), or your harness lacks isolation.
