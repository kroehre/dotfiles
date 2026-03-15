# Dotfiles Project Guide

## Structure

This is a topic-based dotfiles repo. Each tool/topic gets its own directory (e.g., `git/`, `ruby/`, `tmux/`).

### Conventions

- **`*.symlink`** — Files/directories with this extension are symlinked to `$HOME` by `script/bootstrap` (extension stripped). Example: `git/gitconfig.symlink` → `~/.gitconfig`
- **`*.zsh`** — Automatically sourced by zshrc. Loading order: `path.zsh` first, then everything else, then `completion.zsh` last.
- **`install.sh`** — Per-topic install scripts, run by `script/install` during bootstrap.
- **`*.local`** — Machine-specific overrides (e.g., `~/.gitconfig.local`, `~/.zshrc.local`). These are gitignored and should never be created or modified by automation.

## Bootstrap & Installation

- `script/bootstrap` — Main setup script. Creates symlinks, generates `~/.gitconfig.local`, runs installers.
- `script/install` — Finds and runs all `install.sh` files.
- `bin/dot` — Ongoing maintenance entry point. Runs OS defaults, homebrew, and vim bundle installs.
- `homebrew/install.sh` — Installs brews listed in the `BREWS` array.

## Style & Preferences

- **Indentation:** 2 spaces (no tabs) for all config files and scripts.
- **Shell:** zsh. Write shell-compatible code accordingly.
- **Editor:** neovim/vim. Vim plugins are managed with Pathogen. Plugin config lives in `vim/vim.symlink/plugin/`.
- **Ruby tooling:** chruby for version management, ruby-install for installing rubies, gem_home for per-project gems.
- **Tmux:** vi-mode keybindings, `Ctrl-z` prefix.

## Guidelines

- Follow the existing topic-based organization. New tools get their own directory.
- Prefer editing existing files over creating new ones.
- Do not modify or generate `*.local` files — those are machine-specific and user-managed.
- Keep config minimal and readable. Avoid over-commenting.
- When adding a new homebrew package, add it to the `BREWS` array in `homebrew/install.sh`.
- When adding a new symlinked config, use the `*.symlink` naming convention so bootstrap picks it up automatically.
