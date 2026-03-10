# AGENTS.md

This repo demonstrates a simple, maintainable pattern for sharing instructions with multiple AI coding assistants.

## Purpose

The goal is to avoid duplicating the same guidance across tool-specific files like `CLAUDE.md`, `GEMINI.md`, `.cursor/skills/`, and `.github/copilot-instructions.md`.

Instead:

- `AGENTS.md` is the root source of truth
- `agents/` stores topic-specific guidance
- `skills/` stores reusable task workflows
- `ai-setup.sh` links or copies everything into tool-specific locations

## Project Rules

- Keep project-wide guidance here
- Keep focused technical conventions in `agents/`
- Keep repeatable workflows in `skills/`
- Prefer symlinks over duplicated files when possible
- Update `AGENTS.md` first, then re-run `ai-setup.sh`

## Stack For This Example

- Shell scripting
- Markdown documentation
- Git and GitHub CLI

## How To Read This Repo

- Start with this file for the high-level idea
- Read `README.md` for the walkthrough
- Check `agents/` for topic-specific conventions
- Check `skills/` for example workflows
- Read `ai-setup.sh` to see how the assistant-specific wiring works
