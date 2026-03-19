#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /tmp/homebrew-install.log

  # Add Homebrew to PATH for the rest of this session (Apple Silicon)
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

brew update

# Install homebrew 'essential' packages
BREWS=(ack universal-ctags chruby gh ghostty git-delta jq markdown neovim redis ruby-install the_silver_searcher tmux wget)
for b in ${BREWS[@]}; do
  brew list $b > /dev/null 2>&1
  if [[ "$?" -eq "1" ]]; then
    echo "Installing $b"
    brew install $b
  fi
done

brew upgrade
brew cleanup

exit 0
