---
name: react
description: Guidance for React component and hook patterns.
---

# React Conventions

Use this file for React-specific guidance that does not belong in root `AGENTS.md`.

## Rules

- Prefer function components
- Keep components small and focused
- Use clear prop names
- Keep business logic out of presentational components when possible
- Handle loading, error, and empty states explicitly

## Why This Lives In `agents/`

This guidance is narrower than the repo-wide rules in `AGENTS.md`, so it belongs in a focused file that an assistant can load when it is working in React code.
