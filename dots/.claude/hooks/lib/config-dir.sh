#!/usr/bin/env sh

resolve_claude_config_dir() {
  configured="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  configured="${configured#${configured%%[![:space:]]*}}"
  configured="${configured%${configured##*[![:space:]]}}"
  if [ "$configured" != "/" ]; then
    configured="${configured%/}"
  fi
  case "$configured" in
    \~)
      printf '%s\n' "$HOME"
      ;;
    \~/*)
      configured="${configured#\~/}"
      printf '%s/%s\n' "$HOME" "$configured"
      ;;
    \~\\*)
      configured="${configured#\~}"
      configured="${configured#\\}"
      printf '%s/%s\n' "$HOME" "$configured"
      ;;
    *)
      printf '%s\n' "$configured"
      ;;
  esac
}
