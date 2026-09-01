#!/usr/bin/env bash

# Linux / Omarchy package list
PACKAGES=(
  direnv
  zsh
  starship
  eza
  fzf
  ripgrep
  fd
  jq
  tmux
  lazygit
)

echo "Installing Linux packages: ${PACKAGES[*]}..."

if command -v omarchy >/dev/null 2>&1; then
  omarchy pkg add "${PACKAGES[@]}"
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"
else
  echo "Unsupported package manager. Please install: ${PACKAGES[*]}"
fi
