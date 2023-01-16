
# Setup macos defaults and add apps to dock
# . "$DOTFILES_DIR/macos/defaults.sh"
# . "$DOTFILES_DIR/macos/dock.sh"
export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

# Clear cache
# . "$DOTFILES_DIR/bin/dotfiles" clean
# Add symlinks
. "$DOTFILES_DIR/bin/dotfiles" symlinks

# Replace default hosts file
# . "$DOTFILES_DIR/install/hosts.sh"

# Add keys from keychain to ssh agent
ssh-add -A 2>/dev/null;

chsh -s /bin/zsh
zsh
