

export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

# Clear cache
# . "$DOTFILES_DIR/bin/dots" clean
# Add symlinks
. "$DOTFILES_DIR/bin/dots" brew
. "$DOTFILES_DIR/bin/dots" symlinks



# Add keys from keychain to ssh agent
ssh-add -A 2>/dev/null;

chsh -s /bin/zsh
zsh
