#!/bin/bash

NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_PLUG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
DOTFILES_NVIM_DIR="$(cd "$(dirname "$0")" && pwd)"

# Symlink nvim config directory
if [ ! -d "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
  echo "  Linking nvim config to $NVIM_CONFIG_DIR"
  mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
  ln -s "$DOTFILES_NVIM_DIR" "$NVIM_CONFIG_DIR"
elif [ -L "$NVIM_CONFIG_DIR" ]; then
  echo "  nvim config symlink already exists, skipping"
else
  echo "  nvim config directory exists and is not a symlink, skipping"
fi

# Install vim-plug for neovim
if [ ! -f "$NVIM_PLUG_DIR/plug.vim" ]; then
  echo "  Installing vim-plug for neovim"
  mkdir -p "$NVIM_PLUG_DIR"
  cp "$DOTFILES_NVIM_DIR/../vim/vim.symlink/autoload/plug.vim" "$NVIM_PLUG_DIR/plug.vim"
fi
