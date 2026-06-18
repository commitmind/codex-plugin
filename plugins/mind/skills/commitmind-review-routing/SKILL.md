---
name: commitmind-review-routing
description: When the user wants their pending changes reviewed or sanity-checked before a commit or PR — INCLUDING a bare "review the code" / "run a code review" / "do a code review" / "review this" — or asks "is this ready to ship / did I break anything / find issues in what I changed" — AND when they want a finding fixed or turned into a rule. Routes to review_changes / review_ai / propose_fix / draft_rule instead of eyeballing the diff or reaching for the generic built-in code-review skill. (The user typing the explicit /code-review slash command still invokes Claude Code's built-in generic review — only that explicit slash bypasses this routing.)
metadata:
  short-description: CommitMind AI review routing
---

# Review-routing — use the review tools, don't eyeball the diff

There are four review tools. Reach for them before reading the diff yourself — they are grounded (structural diff + project rules + linters + cross-file caller impact) and the AI ones run on the metered mind tier, not your own context.

## "code review" means THIS, not the built-in skill

A bare natural-language "code review" / "review the code" / "run a code review" / "review this" routes HERE — `review_changes` (or `review_ai` for a pre-PR judgment pass). Do NOT reach for Claude Code's generic built-in `code-review` skill for those phrasings: it's a diff-only bug/cleanup pass with none of the project grounding (rules, decisions, caller impact, the metered judgment layer) these tools carry. The ONLY time the built-in generic review is intended is when the user types the explicit `/code-review` slash command themselves — that explicit invocation is their deliberate opt-out and bypasses this routing.

## Routing

| Moment | Call |
| --- | --- |
| "review my changes" / "what did I touch?" / proactively after a multi-file edit turn | `review_changes` first — deterministic, fast, free. Use it liberally. |
| "is this ready to ship?" / "did I break anything?" / before a commit or PR / a risky change | `review_ai` — the same deterministic pass PLUS a grounded judgment layer (logic bugs, missing edge cases, breaking changes the diff hunks don't show). Metered — escalate to it when judgment matters. |
| The user wants a specific finding fixed | `propose_fix(file, message, [line])` — preview first (apply omitted); call again with `apply=true` only AFTER the user agrees to modify the file. |
| A finding represents a recurring class worth enforcing ("we keep doing this — make it a rule") | `draft_rule(file, message, [line])` — show the draft; call again with `record=true` only after the user agrees. |

## The loop

`review_ai` → for each finding worth acting on → `propose_fix` (fix it) or `draft_rule` (prevent it next time). Report the findings to the user and propose the action; don't apply edits or record rules without agreement.

## Cost discipline

`review_changes` is free and deterministic — default to it for "what changed?". `review_ai` / `propose_fix` / `draft_rule` spend the user's metered AI budget — use them when the *judgment* is the point (pre-PR confidence, a real fix, a durable rule), not for every trivial edit.

## Failure mode this catches

Agent re-reads the diff and free-hands a "looks fine to me" review, missing the breaking change a removed/renamed symbol causes downstream — exactly what `review_ai`'s cross-file caller-impact context surfaces. The deterministic + grounded path is the source of truth; your own read is the fallback.
