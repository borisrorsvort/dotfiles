#!/usr/bin/env bash

# Detect OS
OS="$(uname -s)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
DOTS_DIR="$DOTFILES_DIR/dots"

# ---------------------------------------------------------
# Declarative Configuration Lists
# ---------------------------------------------------------
# Format: "src_path" OR "src_path:dst_path"
# Paths are relative to both the dots/ directory and $HOME.

COMMON_LINKS=(
  ".gitconfig"
  ".gitignore_global"
  ".zshrc"
  ".config/opencode"
  # Install Neovim as a side-config everywhere to preserve defaults
  ".config/nvim-astro"
)

MAC_LINKS=(
  ".config/gh"
  ".config/git"
  ".config/karabiner"
)

LINUX_LINKS=(
  # Add your Omarchy/Linux specific paths here when ready
)

# ---------------------------------------------------------

# Helper function to create symlinks safely
link_safely() {
  local src="$1"
  local dst="$2"

  # Ensure the parent directory of the destination exists
  mkdir -p "$(dirname "$dst")"

  # If the destination exists and is NOT a symlink, back it up
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up existing $dst to ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  # Create or update the symlink
  ln -sfn "$src" "$dst"
  echo "Linked $dst -> $src"
}

# Helper to parse and link items
process_links() {
  local items=("$@")
  for item in "${items[@]}"; do
    local src_item="$item"
    local dst_item="$item"
    
    # Check if item contains a colon for custom destination mapping
    if [[ "$item" == *":"* ]]; then
      src_item="${item%%:*}"
      dst_item="${item#*:}"
    fi
    
    link_safely "$DOTS_DIR/$src_item" "$HOME/$dst_item"
  done
}

echo "Linking shared dotfiles..."
process_links "${COMMON_LINKS[@]}"

if [ "$OS" = "Darwin" ]; then
  echo "Linking macOS specific dotfiles..."
  process_links "${MAC_LINKS[@]}"
elif [ "$OS" = "Linux" ]; then
  echo "Linking Linux specific dotfiles..."
  process_links "${LINUX_LINKS[@]}"
fi

echo "Symlinking complete!"
