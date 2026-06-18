---
name: commitmind-review
description: When the user wants a grounded AI review of their pending changes (the CommitMind /review workflow) — e.g. "review my changes", "AI review this diff". Routes to the review_ai tool (scope working), then presents findings by severity with confirm-before-act next steps.
metadata:
  short-description: Grounded AI review of pending changes
---

# CommitMind review — grounded AI review of pending changes

Codex plugins can't bundle slash commands, so this is the skill form of
the Claude `/review` command. Use it when the user wants their pending
changes reviewed (deterministic + judgment, metered).

Review the user's pending changes using the `review_ai` tool (scope:
working).

Then present the findings grouped by severity (critical/high first),
each as one line: what's wrong and where. For every high or critical
finding, offer the next step — fix it with `propose_fix` (preview the
diff first) or, if it's a recurring class of mistake, capture it as a
rule with `draft_rule`.

Do NOT apply any fix or record any rule without the user's explicit
go-ahead.
