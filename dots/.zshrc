# Zsh Path to your oh-my-zsh configuration.
ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="af-magic"
plugins=(z git aliases brew fzf bundler node npm gem rails ruby command-not-found ssh-agent direnv web-search eza)

# For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=20000
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"

unsetopt correct_all
unsetopt correct


source $ZSH/oh-my-zsh.sh

export EDITOR="v"
export BUNDLER_EDITOR="v"
export CC=/usr/bin/gcc

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.yarn/bin:$PATH"
PATH="/usr/local/sbin:$PATH" # Homebrew
PATH="/usr/local/share/npm/bin:$PATH"
PATH="$HOME/dotfiles/scripts/photos:$PATH" # Photo scripts
PATH="$HOME/dotfiles/bin:$PATH" # Dotfiles CLI tools
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"

NOTE_PATH='/Users/ghost/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes'

# Temp fix for legacy webpack
# export NODE_OPTIONS=--openssl-legacy-provider

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias v='NVIM_APPNAME=nvim-astro nvim'
alias so='source ~/.zshrc'
alias up="git up"
alias bu="bundle update"
alias sync="up; gp"
alias dotfiles="cd ~/dotfiles; v ."
alias fixup='gc -am "fix: quickfix"; gp'
alias gs="lazygit"
alias dev="ruby ~/dotfiles/scripts/services.rb"
alias rs='./bin/dev'
alias killruby='killall -9 ruby'
alias killnode='killall -9 node'
alias master='git checkout master'
alias main='git checkout main'
alias photos="photos.rb"
alias create_folders="photos sort" # kept for muscle memory
alias reset_test='rake db:reset RAILS_ENV=test; rake db:migrate RAILS_ENV=test'
alias agy="agy --add-dir ~/.agents"
alias reset_db="rake 'db:copy[staging, true, true]'; rake db:migrate RAILS_ENV=development"
alias rp="git log \$(git describe --tags \`git rev-list --tags --max-count=1\`)..master --oneline" # Release preview
alias deploy="./bin/deploy"
alias services="systemctl list-units --type=service"

export PGGSSENCMODE="disable" # fix rails-pg

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

. "$HOME/.local/share/../bin/env"
alias update-kawai="~/dotfiles/scripts/update-kawai.sh"


# Added by Antigravity CLI installer
export PATH="/home/boris/.local/bin:$PATH"
