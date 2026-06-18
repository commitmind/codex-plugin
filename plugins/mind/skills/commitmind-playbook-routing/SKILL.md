---
name: commitmind-playbook-routing
description: When the user is starting a non-trivial multi-step task — release / publish / refactor / migrate / debug / scaffold / ship / set up / cut a build / how to approach X / let's plan. Call list_playbooks first to find a vetted workflow before improvising from a Makefile or README.
metadata:
  short-description: CommitMind playbook routing
---

# Playbook-routing — runbooks before improvising

For non-trivial multi-step tasks, call `list_playbooks(context=<task>)` first, then `read_playbook` on the top hit. Playbooks encode the team's vetted sequence of steps and gates — including the ones an agent reliably skips when improvising (smoke tests, verification reads, CHANGELOG entries, pre-flight checks).

## Trigger phrases

Any of these signal a playbook lookup is the right first move:

- "let's plan" / "plan this work" / "design how to ship X" / "what's the approach"
- "I want to refactor Y" / "migrate Z" / "investigate this bug" / "ship this branch"
- "how do we release / publish / cut a build / set this up"
- "review this PR" / "explore this codebase" / "add tests for"
- "multi-step task" / "phases A/B/C" / "todos for each step"

## Failure mode this catches

Agent matches the trigger phrase semantically but reaches for grep / Read on the build script before checking whether a playbook already encodes the runbook. Improvising the workflow from a Makefile / README is the wrong reflex; the playbook is the source of truth for *how* the team does this kind of work.

The cost of one extra `list_playbooks` call is ~200ms; the cost of skipping a verification gate is irreversibly publishing a broken artefact.

## Two-step contract

1. `list_playbooks(context=<task>)` — returns titles + descriptions, ranked by trigger / tag / title match.
2. `read_playbook(<slug>)` — loads the body. Read carefully BEFORE acting; the body is the runbook.

Listing without reading the body is the partial-execution failure mode. Always read the top hit before starting work.
