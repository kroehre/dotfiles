#!/bin/sh
#
# Codex CLI
#
# Installs the Codex CLI and registers the tmux MCP server.

# Install Codex via the native installer
if ! command -v codex > /dev/null 2>&1; then
  echo "  Installing Codex"
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

# Ensure ~/.codex exists (mux writes per-session prompt files here)
mkdir -p "$HOME/.codex"

# Register the tmux MCP server idempotently
if command -v codex > /dev/null 2>&1; then
  if codex mcp get tmux > /dev/null 2>&1; then
    echo "  Codex tmux MCP already registered"
  else
    echo "  Registering Codex tmux MCP"
    codex mcp add tmux --env TMUX= -- npx -y tmux-mcp
  fi
fi
