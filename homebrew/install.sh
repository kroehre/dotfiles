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
fi

brew update

# Install homebrew 'essential' packages
BREWS=(ack ctags-exuberant chruby gh macvim markdown neovim proctools redis ruby-install the_silver_searcher tmux wget)
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
