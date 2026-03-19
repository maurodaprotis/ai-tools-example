#!/bin/bash

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$REPO_ROOT/skills"
AGENTS_SOURCE="$REPO_ROOT/agents"

SETUP_CURSOR=false
SETUP_CLAUDE=false
SETUP_GEMINI=false
SETUP_CODEX=false
SETUP_OPENCODE=false
SETUP_COPILOT=false

show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --all       Configure all supported assistants"
  echo "  --cursor    Configure Cursor"
  echo "  --claude    Configure Claude Code"
  echo "  --gemini    Configure Gemini"
  echo "  --codex     Configure Codex"
  echo "  --opencode  Configure OpenCode"
  echo "  --copilot   Configure GitHub Copilot"
  echo "  --help      Show this help message"
}

relative_path() {
  local source="$1"
  local target_dir="$2"
  local source_path="${source#/}"
  local target_path="${target_dir#/}"
  local -a source_parts target_parts relative_parts
  local i=0
  local j
  local IFS='/'

  read -r -a source_parts <<< "$source_path"
  read -r -a target_parts <<< "$target_path"

  while [ "$i" -lt "${#source_parts[@]}" ] && [ "$i" -lt "${#target_parts[@]}" ] && [ "${source_parts[$i]}" = "${target_parts[$i]}" ]; do
    ((i += 1))
  done

  for ((j = i; j < ${#target_parts[@]}; j += 1)); do
    relative_parts+=("..")
  done

  for ((j = i; j < ${#source_parts[@]}; j += 1)); do
    relative_parts+=("${source_parts[$j]}")
  done

  if [ "${#relative_parts[@]}" -eq 0 ]; then
    echo "."
    return
  fi

  local relative="${relative_parts[0]}"
  for ((j = 1; j < ${#relative_parts[@]}; j += 1)); do
    relative="$relative/${relative_parts[$j]}"
  done

  echo "$relative"
}

link_dir() {
  local source="$1"
  local target="$2"
  local target_dir
  local relative_source

  target_dir="$(dirname "$target")"
  relative_source="$(relative_path "$source" "$target_dir")"

  mkdir -p "$target_dir"

  if [ -L "$target" ] || [ -f "$target" ]; then
    rm "$target"
  elif [ -d "$target" ]; then
    rm -rf "$target"
  fi

  ln -s "$relative_source" "$target"
}

link_agents_alias() {
  local alias_name="$1"
  local target="$REPO_ROOT/$alias_name"

  if [ -L "$target" ] || [ -f "$target" ]; then
    rm "$target"
  fi

  ln -s "AGENTS.md" "$target"
}

setup_shared() {
  local shared_dir="$REPO_ROOT/.agents"

  if [ -L "$shared_dir" ] || [ -f "$shared_dir" ]; then
    rm "$shared_dir"
  elif [ -d "$shared_dir" ]; then
    rm -rf "$shared_dir"
  fi

  mkdir -p "$shared_dir"
  link_dir "$AGENTS_SOURCE" "$shared_dir/agents"
  link_dir "$SKILLS_SOURCE" "$shared_dir/skills"
}

setup_cursor() {
  link_dir "$SKILLS_SOURCE" "$REPO_ROOT/.cursor/skills"
  link_dir "$AGENTS_SOURCE" "$REPO_ROOT/.cursor/agents"
}

setup_claude() {
  link_dir "$SKILLS_SOURCE" "$REPO_ROOT/.claude/skills"
  link_dir "$AGENTS_SOURCE" "$REPO_ROOT/.claude/agents"
  link_agents_alias "CLAUDE.md"
}

setup_gemini() {
  link_dir "$SKILLS_SOURCE" "$REPO_ROOT/.gemini/skills"
  link_dir "$AGENTS_SOURCE" "$REPO_ROOT/.gemini/agents"
  link_agents_alias "GEMINI.md"
}

setup_codex() {
  link_dir "$SKILLS_SOURCE" "$REPO_ROOT/.codex/skills"
  link_dir "$AGENTS_SOURCE" "$REPO_ROOT/.codex/agents"
}

setup_opencode() {
  link_dir "$AGENTS_SOURCE" "$REPO_ROOT/.opencode/agents"
  link_dir "$SKILLS_SOURCE" "$REPO_ROOT/.opencode/skills"
}

setup_copilot() {
  mkdir -p "$REPO_ROOT/.github"
  cp "$REPO_ROOT/AGENTS.md" "$REPO_ROOT/.github/copilot-instructions.md"
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --all)
      SETUP_CURSOR=true
      SETUP_CLAUDE=true
      SETUP_GEMINI=true
      SETUP_CODEX=true
      SETUP_OPENCODE=true
      SETUP_COPILOT=true
      shift
      ;;
    --cursor)
      SETUP_CURSOR=true
      shift
      ;;
    --claude)
      SETUP_CLAUDE=true
      shift
      ;;
    --gemini)
      SETUP_GEMINI=true
      shift
      ;;
    --codex)
      SETUP_CODEX=true
      shift
      ;;
    --opencode)
      SETUP_OPENCODE=true
      shift
      ;;
    --copilot)
      SETUP_COPILOT=true
      shift
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

if [ "$SETUP_CURSOR" = false ] && [ "$SETUP_CLAUDE" = false ] && [ "$SETUP_GEMINI" = false ] && [ "$SETUP_CODEX" = false ] && [ "$SETUP_OPENCODE" = false ] && [ "$SETUP_COPILOT" = false ]; then
  show_help
  exit 0
fi

setup_shared

if [ "$SETUP_CURSOR" = true ]; then
  setup_cursor
fi

if [ "$SETUP_CLAUDE" = true ]; then
  setup_claude
fi

if [ "$SETUP_GEMINI" = true ]; then
  setup_gemini
fi

if [ "$SETUP_CODEX" = true ]; then
  setup_codex
fi

if [ "$SETUP_OPENCODE" = true ]; then
  setup_opencode
fi

if [ "$SETUP_COPILOT" = true ]; then
  setup_copilot
fi

echo "AI setup complete."
