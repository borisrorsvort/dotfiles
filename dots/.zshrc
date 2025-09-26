# Zsh Path to your oh-my-zsh configuration.
ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="af-magic"
plugins=(z git aliases brew bundler rbenv node npm gem rails ruby command-not-found ssh-agent nvm direnv)

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

export EDITOR="nvim"
export BUNDLER_EDITOR="nvim"
export CC=/usr/bin/gcc

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.yarn/bin:$PATH"
PATH="/usr/local/sbin:$PATH" # Homebrew
PATH="/usr/local/share/npm/bin:$PATH"
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
alias v='nvim'
alias so='source ~/.zshrc'
alias up="git up"
alias bu="bundle update"
alias sync="up; gp"
alias dotfiles="nvim ~/dotfiles"
alias fixup='gc -am "fix: quickfix"; gp'
alias gs="lazygit"
alias dev="ruby ~/dotfiles/dev_scripts/services.rb"
alias rs='./bin/server'
alias killruby='killall -9 ruby'
alias killnode='killall -9 node'
alias master='git checkout master'
alias main='git checkout main'
alias notes="cd $NOTE_PATH; nvim ./Goals.md"

# TODO: replace with rails db:reset
# alias reset_test='bin/rails db:environment:set RAILS_ENV=test;rake db:drop db:create db:migrate RAILS_ENV=test;bin/rails db:environment:set RAILS_ENV=development'
alias reset_test='rake db:reset RAILS_ENV=test; rake db:migrate RAILS_ENV=test'
alias reset_db="rake 'db:copy[staging, true, true]'; rake db:migrate RAILS_ENV=development"
alias rp="git log \$(git describe --tags \`git rev-list --tags --max-count=1\`)..master --oneline" # Release preview
alias deploy="./bin/deploy"
alias robert='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PGGSSENCMODE="disable" # fix rails-pg

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(rbenv init -)"

