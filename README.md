# AI Tools Example

This repo is a small, working example of a pattern for keeping AI instructions maintainable across multiple coding assistants.

Instead of duplicating the same guidance in several places, it uses:

- `AGENTS.md` as the root source of truth
- `agents/` for focused, topic-specific guidance
- `skills/` for reusable task workflows
- `ai-tools-setup.sh` to create the files and symlinks each assistant expects

## The Big Idea

Different AI tools look for instructions in different places:

- Cursor looks for `.cursor/agents/` and `.cursor/skills/`
- Claude Code often uses `CLAUDE.md` plus `.claude/agents/` and `.claude/skills/`
- Gemini can use `GEMINI.md` plus `.gemini/agents/` and `.gemini/skills/`
- Codex can read `AGENTS.md` directly, but can also benefit from linked `agents/` and `skills/`
- GitHub Copilot reads `.github/copilot-instructions.md`

Maintaining all of those by hand gets messy fast.

This repo keeps one canonical set of instructions, then `ai-tools-setup.sh` wires them into the shape each tool expects.

## Repo Layout

```text
.
├── AGENTS.md
├── agents/
│   ├── react.md
│   └── typescript.md
├── skills/
│   ├── commit/SKILL.md
│   └── review/SKILL.md
└── ai-tools-setup.sh
```

## What Each Part Does

### `AGENTS.md`

This is the top-level guide for the repo.

It should answer things like:

- what the project is
- what stack it uses
- which conventions apply everywhere
- which files or folders contain deeper guidance

Think of it as the first document an AI assistant should read before it starts coding.

### `agents/`

This folder holds narrower instruction files for specific topics.

Examples:

- `agents/react.md` for React component patterns
- `agents/typescript.md` for typing and module conventions

These files are useful when:

- an assistant supports specialized subagents
- you want targeted docs instead of one giant `AGENTS.md`
- you want to evolve conventions by area

### `skills/`

This folder holds reusable task playbooks.

A skill usually answers:

- when should this workflow run?
- what rules must always be followed?
- what steps should the assistant take?

Examples:

- `skills/commit/SKILL.md` for safe commit behavior
- `skills/review/SKILL.md` for code review behavior

Skills are best for repeatable tasks. Agents are best for domain- or technology-specific conventions.

### `ai-tools-setup.sh`

This script is the bridge between your clean source files and each assistant's preferred layout.

It does things like:

- create `.cursor/skills -> ../skills`
- create `.cursor/agents -> ../agents`
- create `CLAUDE.md -> AGENTS.md`
- create `GEMINI.md -> AGENTS.md`
- copy `AGENTS.md` into `.github/copilot-instructions.md`

It uses relative symlinks for linked folders, so the repo can be moved or committed without baking in absolute paths.

That gives every assistant the same guidance without making you edit five copies.

## Why Use Symlinks

Symlinks are the key to keeping the setup maintainable.

Example:

```text
CLAUDE.md -> AGENTS.md
```

That means:

- there is still only one real file to edit
- Claude-compatible tooling sees the filename it expects
- updates to `AGENTS.md` are reflected immediately

The same idea applies to linked `agents/` and `skills/` folders, and those directory links are created as relative symlinks like `../agents` and `../skills`.

## How The Setup Script Works

At a high level, `ai-tools-setup.sh` does four things:

1. Parse CLI flags like `--cursor`, `--claude`, or `--all`
2. Locate the source folders in the repo: `AGENTS.md`, `agents/`, and `skills/`
3. Create assistant-specific relative symlinks or copies
4. Print `AI setup complete.`

Common commands:

```bash
./ai-tools-setup.sh
./ai-tools-setup.sh --all
./ai-tools-setup.sh --claude --cursor
```

## Example Output

After running:

```bash
./ai-tools-setup.sh --all
```

you might end up with:

```text
.cursor/skills -> ../skills
.cursor/agents -> ../agents
.claude/skills -> ../skills
.claude/agents -> ../agents
CLAUDE.md -> AGENTS.md
.gemini/skills -> ../skills
.gemini/agents -> ../agents
GEMINI.md -> AGENTS.md
.codex/skills -> ../skills
.codex/agents -> ../agents
.github/copilot-instructions.md
```

## Recommended Workflow

1. Edit `AGENTS.md`, `agents/`, or `skills/`
2. Re-run `./ai-tools-setup.sh`
3. Restart the assistant if needed

If you need to add support for a new assistant, update `ai-tools-setup.sh` once and keep the rest of the structure unchanged.

## How To Adapt This Pattern

For a real project, you would usually:

- replace the example stack and conventions in `AGENTS.md`
- add more focused docs to `agents/`
- add task-specific workflows to `skills/`
- extend `ai-tools-setup.sh` for whichever assistants your team uses

The core idea stays the same: keep one clean instruction source, then generate or link tool-specific entry points from it.
