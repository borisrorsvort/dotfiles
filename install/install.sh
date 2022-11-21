
# Setup macos defaults and add apps to dock
# . "$DOTFILES_DIR/macos/defaults.sh"
# . "$DOTFILES_DIR/macos/dock.sh"

# Clear cache
. "~/.dotfiles/bin/dotfiles" clean

# Replace default hosts file
. "~/.dotfiles/install/hosts.sh"

# Add keys from keychain to ssh agent
ssh-add -A 2>/dev/null;

# Set zsh as default shell
chsh -s /bin/zsh