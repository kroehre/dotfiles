#!/bin/bash

GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
DOTFILES_GHOSTTY_DIR="$(cd "$(dirname "$0")" && pwd)"

# Symlink ghostty config
if [ ! -d "$GHOSTTY_CONFIG_DIR" ] && [ ! -L "$GHOSTTY_CONFIG_DIR" ]; then
  echo "  Linking ghostty config to $GHOSTTY_CONFIG_DIR"
  mkdir -p "$(dirname "$GHOSTTY_CONFIG_DIR")"
  ln -s "$DOTFILES_GHOSTTY_DIR" "$GHOSTTY_CONFIG_DIR"
elif [ -L "$GHOSTTY_CONFIG_DIR" ]; then
  echo "  ghostty config symlink already exists, skipping"
else
  echo "  ghostty config directory exists and is not a symlink, skipping"
fi
