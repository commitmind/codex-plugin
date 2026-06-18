---
name: commitmind-rule
description: When the user wants to turn a review finding into a reusable project rule (the CommitMind /rule workflow) — e.g. "make a rule out of this", "capture this as a rule". Routes to the draft_rule tool with a preview-then-confirm contract.
metadata:
  short-description: Turn a review finding into a project rule
---

# CommitMind rule — capture a review finding as a reusable rule

Codex plugins can't bundle slash commands, so this is the skill form of
the Claude `/rule` command. Use it when the user wants to turn a finding
into a durable project rule.

Use the `draft_rule` tool for the finding the user described.

Show the drafted rule — the soft rule (title / body / file globs) and any
structural pattern it proposes. Only call again with `record=true` after
the user confirms. Note that a structural pattern can't be recorded from
here (only humans add deterministic patterns, in the dashboard) — surface
it as a suggestion.
