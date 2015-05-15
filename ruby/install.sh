#!/bin/sh

if test ! $(which chruby)
then
  echo "  Installing chruby for you."
  brew install chruby > /tmp/chruby_install.log
fi

if test ! $(which gem_home)
then
  echo "  Installing gem_home for you."
  brew install gem_home > /tmp/gem_home_install.log
fi

if test ! $(which ruby-install)
then
  echo "  Installing ruby-install for you."
  brew install ruby-install > /tmp/ruby-install_install.log
fi
