# Zsh Path to your oh-my-zsh configuration.
ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="af-magic"
plugins=(z git aliases brew bundler rbenv node npm gem rails ruby command-not-found ssh-agent nvm)

# For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=20000
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

unsetopt correct_all
unsetopt correct

source $ZSH/oh-my-zsh.sh

export EDITOR="nvim"
export BUNDLER_EDITOR="nvim"
export CC=/usr/bin/gcc

# For compilers to find openssl@3 you may need to set:
# export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
# For pkg-config to find openssl@3 you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"

# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# export PATH="/usr/local/opt/openssl@3/bin:$PATH"
#  export PATH="$HOME/.local/bin:$PATH"
#  export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:/usr/local/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/X11/bin:/usr/local/share/npm/bin:$PATH:`yarn global bin`"
#  export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.yarn/bin:$PATH"
PATH="/usr/local/sbin:$PATH" # Homebrew
PATH="/usr/local/share/npm/bin:$PATH"
PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$PATH:`yarn global bin`"

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
alias dotfiles="nvim ~/.dotfiles"
alias fixup='gc -am "fix: quickfix"; gp'
alias gs="lazygit"
alias dev="ruby ~/.dotfiles/dev_scripts/services.rb"
alias rs='./bin/server'
alias killruby='killall -9 ruby'
alias killnode='killall -9 node'
alias master='git checkout master'
# TODO: replace with rails db:reset
# alias reset_test='bin/rails db:environment:set RAILS_ENV=test;rake db:drop db:create db:migrate RAILS_ENV=test;bin/rails db:environment:set RAILS_ENV=development'
alias reset_test='rake db:reset RAILS_ENV=test; rake db:migrate RAILS_ENV=test'
alias reset_db="rake 'db:copy[staging, true, true]'; rake db:migrate RAILS_ENV=development"
alias rp="git log \$(git describe --tags \`git rev-list --tags --max-count=1\`)..master --oneline" # Release preview
alias deploy="./bin/deploy"

# NVM detection
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# Automatically call nvm use
# autoload -U add-zsh-hook
# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"
#
#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
#
#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc

export PGGSSENCMODE="disable" # fix rails-pg

eval "$(starship init zsh)"
eval "$(rbenv init -)"
