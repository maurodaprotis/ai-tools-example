---
name: typescript
description: Guidance for TypeScript typing and module patterns.
---

# TypeScript Conventions

Use this file for TypeScript-specific guidance that should only apply when the assistant is editing TypeScript code.

## Rules

- Prefer explicit types when they improve readability
- Avoid `any` unless there is a strong reason
- Keep types close to the code that uses them
- Prefer named exports for reusable modules
- Model domain concepts with types instead of stringly-typed data

## Why This Lives In `agents/`

These conventions are valuable, but they are too specific to live at the top level. Putting them here keeps `AGENTS.md` shorter and easier to scan.
