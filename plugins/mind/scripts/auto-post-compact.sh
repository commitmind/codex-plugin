#!/usr/bin/env bash
# CommitMind post-compaction reprime for OpenAI Codex CLI. Fires from a
# SessionStart hook with matcher "compact" — Codex re-fires SessionStart
# with source=compact after a context compaction, but the summary tends
# to drop the behavioural contract ("tick task todos as you ship"). This
# re-injects the active-task state + contract reminder via the focused
# `prime --post-compact` payload (not the full prime).
#
# Genuinely a SessionStart event, so `prime --hook-envelope` emits the
# correct hookEventName. Same silent-failure gates as auto-prime.sh.
set -e

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi
if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
timeout 8 commitmind prime --hook-envelope --post-compact --host codex 2>/dev/null || true
