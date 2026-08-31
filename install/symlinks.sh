#!/usr/bin/env bash

# Home directory dots
ln -sfn "$HOME/dotfiles/dots/.gitconfig" "$HOME/.gitconfig"
ln -sfn "$HOME/dotfiles/dots/.gitignore_global" "$HOME/.gitignore_global"
ln -sfn "$HOME/dotfiles/dots/.zshrc" "$HOME/.zshrc"

# .config directories
ln -sfn "$HOME/dotfiles/dots/.config/nvim" "$HOME/.config/nvim"
ln -sfn "$HOME/dotfiles/dots/.config/gh" "$HOME/.config/gh"
ln -sfn "$HOME/dotfiles/dots/.config/git" "$HOME/.config/git"
ln -sfn "$HOME/dotfiles/dots/.config/karabiner" "$HOME/.config/karabiner"
ln -sfn "$HOME/dotfiles/dots/.config/opencode" "$HOME/.config/opencode"
