## dotfiles

My dotfiles based on [Zach Holman](https://github.com/holman)'s [dotfiles](https://github.com/holman/dotfiles) philosophy. However, there's plenty of stuff from [Hashrocket](https://github.com/hashrocket)'s [dotmatrix](https://github.com/hashrocket/dotmatrix).

Designed for Apple Silicon Macs running modern macOS.

## what's included

- **Shell:** zsh with git-aware prompt, aliases, and completions
- **Editor:** neovim with vim-plug and 40+ plugins (tpope essentials, ALE, NERDTree, Rails, Fugitive, etc.)
- **Terminal multiplexer:** tmux with vi-mode keys and `Ctrl-z` prefix
- **Ruby:** chruby + ruby-install for version management, gem_home for per-project gems
- **Git:** aliases (`gst`, `gpr`, `gap`, etc.), LFS support, GitHub CLI (`gh`)
- **macOS:** sane system defaults applied automatically

## install

Run this:

```sh
git clone https://github.com/kroehre/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

`dot` is a simple script that installs some dependencies, sets sane macOS
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## local overrides

Machine-specific configuration goes in `*.local` files, which are not tracked by git:

- `~/.zshrc.local` — shell customizations for this machine
- `~/.gitconfig.local` — git author info (generated during bootstrap)
- `~/.vimrc.local` — neovim overrides
- `~/.tmux.conf.local` — tmux overrides

## what's inside

A lot of what's inside is just aliases: `gst` for `git status`, `gpr` for `git
pull --rebase --prune`, for example. You can browse the `aliases.zsh` files in
each topic directory. There's also a collection of scripts in `bin` you can
browse.

## thanks

I forked [Zach Holman](http://github.com/holman)'s
[dotfiles](http://github.com/holman/dotfiles) and basically adopted his philosophy
but made it work with my preferred environment tools.
A decent amount of the code in these dotfiles stems either from Hashrocket's Dotmatrix, Holman's dotfiles or by extension,
Ryan Bates' original dotfiles.
