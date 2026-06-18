#!/usr/bin/env bash
# Generic CommitMind hook launcher for OpenAI Codex CLI. Execs the daemon
# hook subcommand named by the args ($@) with --host codex, which makes
# the subcommand speak Codex's wire format (apply_patch → Edit, path
# lifted out of the patch text, explicit cwd). hooks.json points every
# `commitmind hook X` entry here as `hook.sh X`.
#
# Silent-allow (exit 0) when commitmind isn't installed so a Codex
# session on a machine without the CLI is never blocked or noised up.
if ! command -v commitmind >/dev/null 2>&1; then
    exit 0
fi
exec commitmind hook --host codex "$@"
