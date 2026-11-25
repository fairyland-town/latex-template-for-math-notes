#!/usr/bin/env bash
# Install the personal-math-notes skill into AI agent skill directories.
# Usage:
#   bash scripts/install.sh                 # auto-detect agents on this machine
#   bash scripts/install.sh --agent all     # install to all supported agents
#   bash scripts/install.sh --agent codex   # install to a specific agent
#   bash scripts/install.sh --check         # verify current installation only
#
# Supported agents and default target directories:
#   codex     -> ~/.codex/skills/
#   claude    -> ~/.claude/skills/
#   workbuddy -> ~/.workbuddy/skills/
#   opencode  -> ~/.config/opencode/skills/
#   openclaw  -> ~/.openclaw/skills/
set -euo pipefail

SKILL_NAME="personal-math-notes"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC="$REPO_ROOT/skills/$SKILL_NAME"

if [ ! -f "$SRC/SKILL.md" ]; then
  echo "ERROR: skill source not found at $SRC/SKILL.md" >&2
  exit 1
fi

AGENT="auto"
CHECK_ONLY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --agent) AGENT="${2:-}"; shift 2 ;;
    --agent=*) AGENT="${1#*=}"; shift ;;
    --check) CHECK_ONLY=1; shift ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# Pick target directories
case "$AGENT" in
  codex)    TARGETS=("$HOME/.codex/skills") ;;
  claude)   TARGETS=("$HOME/.claude/skills") ;;
  workbuddy)TARGETS=("$HOME/.workbuddy/skills") ;;
  opencode) TARGETS=("$HOME/.config/opencode/skills") ;;
  openclaw) TARGETS=("$HOME/.openclaw/skills") ;;
  all)      TARGETS=("$HOME/.codex/skills" "$HOME/.claude/skills" "$HOME/.workbuddy/skills" "$HOME/.config/opencode/skills" "$HOME/.openclaw/skills") ;;
  auto)
    TARGETS=()
    for d in "$HOME/.codex/skills" "$HOME/.claude/skills" "$HOME/.workbuddy/skills" "$HOME/.config/opencode/skills" "$HOME/.openclaw/skills"; do
      if [ -d "$(dirname "$d")" ]; then TARGETS+=("$d"); fi
    done
    if [ ${#TARGETS[@]} -eq 0 ]; then
      echo "No known agent directory detected. Use --agent all or specify one."
      exit 1
    fi
    ;;
  *) echo "Unknown agent: $AGENT (use codex|claude|workbuddy|opencode|openclaw|all|auto)" >&2; exit 1 ;;
esac

fail=0
if [ "$CHECK_ONLY" -eq 1 ]; then
  echo "Checking installation of $SKILL_NAME ..."
  for dest in "${TARGETS[@]}"; do
    if [ -f "$dest/$SKILL_NAME/SKILL.md" ] && [ -d "$dest/$SKILL_NAME/assets/template" ]; then
      echo "  OK   $dest/$SKILL_NAME"
    else
      echo "  MISS $dest/$SKILL_NAME"
      fail=1
    fi
  done
  exit "$fail"
fi

for dest in "${TARGETS[@]}"; do
  mkdir -p "$dest"
  # Copy the whole skill directory (SKILL.md + references + assets + manifest).
  # rm -rf limited to this exact skill folder to make the install idempotent.
  rm -rf "$dest/$SKILL_NAME"
  cp -R "$SRC" "$dest/$SKILL_NAME"
  # Sanity check
  if [ -f "$dest/$SKILL_NAME/SKILL.md" ] && [ -d "$dest/$SKILL_NAME/assets/template" ]; then
    echo "Installed $SKILL_NAME -> $dest/$SKILL_NAME"
  else
    echo "ERROR: verification failed at $dest/$SKILL_NAME" >&2
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then exit 1; fi
echo ""
echo "Done. Start a NEW agent session, then try:"
echo "  Use $SKILL_NAME to write math notes on <topic>."
echo "TeX Live (XeLaTeX) is still required to compile the notes; this installer only installs the skill instructions."
