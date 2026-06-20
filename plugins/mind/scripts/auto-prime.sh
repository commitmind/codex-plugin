#!/usr/bin/env bash
# CommitMind SessionStart hook for OpenAI Codex CLI. When the cwd is a
# CommitMind-linked repo, runs `commitmind prime --hook-envelope` and
# emits the JSON envelope to stdout so Codex injects the project context
# (conventions + recent activity + active task) into the session via
# additionalContext — no manual prime_session call required.
#
# This is the SAME `prime --hook-envelope` path the Claude plugin uses:
# Phase 0 verified Codex injects the {"hookSpecificOutput":{"hookEventName":
# "SessionStart","additionalContext":...},"systemMessage":...} shape
# identically, so no Codex-specific prime mode is needed.
#
# Failure modes are intentionally silent (never block or noise up a
# session outside a CommitMind project):
#   - Not in a git repo / not a CommitMind project → silent exit 0.
#   - `commitmind` binary not on PATH → silent exit 0.
#   - API down / timeout → `prime` prints a fallback block and exits 0.
set -e

# Gate 1: cheap skip for non-repo dirs. `prime` self-gates on the repo's
# agent token, so we only avoid spawning the binary in non-git dirs.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi

# Gate 2: locate the commitmind binary. Silent exit if absent.
if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi

# Run with a tight timeout so a backend hiccup doesn't slow session start.
timeout 12 commitmind prime --hook-envelope --host codex 2>/dev/null || true
