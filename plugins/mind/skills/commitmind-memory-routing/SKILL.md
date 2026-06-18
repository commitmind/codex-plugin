---
name: commitmind-memory-routing
description: When the user asks history-shaped questions — what was decided, why something exists, where we left off, what is recent, has X been discussed before. Use search_memory / recent_activity / explain / recall_learning instead of git log + grep + reading code to learn what shipped.
metadata:
  short-description: CommitMind memory routing
---

# Memory-routing — the memory layer answers WHY questions

Code shows what's there NOW; memory shows WHY it's there and what it connects to. For history-shaped questions, the memory layer is the first stop, BEFORE the file reads.

## Routing

| Question | Call |
| --- | --- |
| "Catch me up" / session start / "where did we leave off" | `prime_session` |
| "What's recent" / chronological feed | `recent_activity` |
| "Have we discussed X" / past decisions / rationale | `search_memory` |
| "Did we figure out X before" / durable lessons | `recall_learning` |
| About to edit a named file/symbol / "why does X exist" | `explain(<file or symbol>)` |
| Active task / phase / todos | `task_get_active` |
| "How do we ship/release/publish/refactor X" / runbook | `list_playbooks(context=<task>)` → `read_playbook` |

## When this matters

The trap: history-shaped framings ("we built X", "reflect the new features", "why does Y exist") wrapped in prose-heavy briefs read like flavor text — when the framing points at history, memory is the first stop regardless of how concrete the body looks.

## Capture as you go

The memory layer only stays useful if you write to it.

| Output | Tool |
| --- | --- |
| Decision reached | `promote_decision(title, rationale)` |
| Non-trivial work note | `log_observation(content)` |
| Lesson for FUTURE sessions | `record_learning(title, body)` |
| Project-wide guidance | `record_rule(...)` |
| Multi-step plan / project | `task_create(title)` |
| Plan steps in design phase | `task_todo_add` (one per step, BEFORE advancing to implementation) |

For "where in the CODE does X happen" use the code-search surface (`xref`). Don't conflate "what did we discuss" (memory) with "where does it live" (code).
