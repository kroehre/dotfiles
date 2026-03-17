## dotfiles

Topic-based dotfiles for macOS (Apple Silicon). Each tool gets its own directory
with `*.zsh` files auto-sourced by the shell, `*.symlink` files linked to `$HOME`,
and optional `install.sh` scripts run during bootstrap.

## install

```sh
git clone https://github.com/kroehre/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Run `dot` occasionally to keep homebrew, neovim plugins, and macOS defaults
up to date.

## what's inside

- **Shell:** zsh with git-aware prompt, aliases, and completions
- **Editor:** neovim with vim-plug (tpope essentials, ALE, NERDTree, Fugitive, etc.)
- **Terminal:** ghostty, tmux with vi-mode keys and `Ctrl-z` prefix
- **Ruby:** chruby + ruby-install, gem_home for per-project gems
- **Git:** aliases (`gst`, `gpr`, `gap`, etc.), GitHub CLI
- **Claude Code:** tmux MCP integration, nested container layout via `mux -c`
- **macOS:** sane system defaults applied automatically

## conventions

- **`*.symlink`** — Symlinked to `$HOME` by `script/bootstrap` (extension stripped)
- **`*.zsh`** — Auto-sourced by zshrc. `path.zsh` loads first, `completion.zsh` last
- **`install.sh`** — Per-topic install scripts, run by `script/install`
- **`*.local`** — Machine-specific overrides (gitignored, never automated)

## local overrides

- `~/.zshrc.local` — shell customizations
- `~/.gitconfig.local` — git author info (generated during bootstrap)
- `~/.vimrc.local` — neovim overrides
- `~/.tmux.conf.local` — tmux overrides
