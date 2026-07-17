#!/usr/bin/env bash
# SessionStart proactive-worktree nudge (spec 80ebc2ab, A2). Asks the daemon
# whether another LIVE agent is already working in this git checkout and, if so,
# emits a systemMessage recommending `commitmind worktree new` BEFORE any edit —
# the proactive complement to the Stop-hook collision nudge, which only fires
# after a sweep has already happened.
#
# Fail-open by design, like auto-prime.sh:
#   - Not in a git repo → silent exit 0.
#   - commitmind binary not on PATH → silent exit 0.
#   - No daemon / no peer / any error → the command itself exits 0 and prints
#     nothing.
# It must NEVER block or noise up a session; a false silence is always
# preferable to a false block.

set -e

# --- Gate 1: cheap skip for non-repo dirs. ---
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi

# --- Gate 2: locate the commitmind binary. ---
binary=""
if command -v commitmind >/dev/null 2>&1; then
    binary="$(command -v commitmind)"
fi
if [[ -z "$binary" ]]; then
    exit 0
fi

# The SessionStart hook envelope Claude Code pipes to this script is inherited on
# stdin by the binary, which reads session_id from it. A tight timeout so a
# daemon hiccup never slows session start; the command self-gates on everything
# else and stays silent when there's no peer.
timeout 5 "$binary" hook session-peers-check 2>/dev/null || true
