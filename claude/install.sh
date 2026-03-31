#!/bin/sh
#
# Claude Code
#
# Installs Claude Code and merges managed settings into user config files.

DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Install Claude Code via native installer
if ! command -v claude > /dev/null 2>&1; then
  echo "  Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

# Ensure ~/.claude exists
mkdir -p "$HOME/.claude"

# Deep-merge a dotfiles-managed JSON file into a target.
# Dotfiles keys take precedence; user-only keys are preserved.
merge_json() {
  local managed="$1" target="$2" label="$3"

  if [ ! -f "$target" ]; then
    cp "$managed" "$target"
    echo "  Created $label"
  else
    jq -s '.[0] * .[1]' "$target" "$managed" > "$target.tmp" && mv "$target.tmp" "$target"
    echo "  Merged $label"
  fi
}

merge_json "$DOTFILES_ROOT/claude/settings.json" "$HOME/.claude/settings.json" "Claude Code settings"
merge_json "$DOTFILES_ROOT/claude/claude.json" "$HOME/.claude.json" "Claude Code user config"
