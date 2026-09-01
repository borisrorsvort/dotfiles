#!/usr/bin/env bash

export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
OS="$(uname -s)"

# Clear cache
# . "$DOTFILES_DIR/bin/dots" clean

# Add symlinks (this script is already cross-platform)
. "$DOTFILES_DIR/bin/dots" symlinks

# Run OS-specific package managers
if [ "$OS" = "Darwin" ]; then
    . "$DOTFILES_DIR/bin/dots" brew
elif [ "$OS" = "Linux" ]; then
    . "$DOTFILES_DIR/bin/dots" linux
fi

# Add keys from keychain to ssh agent
ssh-add -A 2>/dev/null;

chsh -s /bin/zsh
zsh
