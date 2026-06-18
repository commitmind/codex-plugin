---
name: commitmind-fix
description: When the user wants to propose or apply an AI fix for a code-review finding (the CommitMind /fix workflow) — e.g. "fix that finding", "propose a fix for X". Routes to the propose_fix tool with a preview-first, confirm-before-apply contract.
metadata:
  short-description: Propose/apply an AI fix for a review finding
---

# CommitMind fix — propose (and optionally apply) a fix for a review finding

Codex plugins can't bundle slash commands, so this is the skill form of
the Claude `/fix` command. Use it when the user wants to act on a
specific review finding.

Use the `propose_fix` tool for the finding the user described.

Call it WITHOUT apply first and show the proposed diff. Only call again
with `apply=true` after the user confirms. If the apply is refused
(target text missing or not unique), say so — don't guess.
