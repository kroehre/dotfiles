#!/bin/sh
#
# Claude Code
#
# Installs Claude Code and merges managed settings into ~/.claude/settings.json.

DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Install Claude Code via Homebrew cask
if ! brew list --cask claude-code > /dev/null 2>&1; then
  echo "  Installing Claude Code"
  brew install --cask claude-code
fi

# Ensure ~/.claude exists
mkdir -p "$HOME/.claude"

# Merge dotfiles-managed settings into user settings
MANAGED="$DOTFILES_ROOT/claude/settings.json"
TARGET="$HOME/.claude/settings.json"

if [ ! -f "$TARGET" ]; then
  cp "$MANAGED" "$TARGET"
  echo "  Created Claude Code settings"
else
  # Deep merge: dotfiles settings take precedence, user-only keys preserved
  jq -s '.[0] * .[1]' "$TARGET" "$MANAGED" > "$TARGET.tmp" && mv "$TARGET.tmp" "$TARGET"
  echo "  Merged Claude Code settings"
fi
