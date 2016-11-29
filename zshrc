# Zsh-
# Path to your oh-my-zsh configuration.
ZSH="$HOME/.dotfiles/oh-my-zsh"

# Autocomplete
COMPLETION_WAITING_DOTS="true"

# Save a ton of history
HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=20000

# Editor
export EDITOR="atom"
export BUNDLER_EDITOR="atom"

# Theme
# Set name of the theme to load.
# Look in $HOME/.dotfiles/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="pure"

# Plugins
# Plugins can be found in $HOME/.dotfiles/oh-my-zsh/plugins/
# Custom plugins may be added to $HOME/.dotfiles/oh-my-zsh/custom/plugins/
#
# Which plugins would you like to load?
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(atom ant z zsh-syntax-highlighting git brew bundler gem git-flow history-substring-search rails ruby ssh-agent cap zeus boris k)

# Options
unsetopt correct_all
unsetopt correct

# Oh My Zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/dev_scripts/k.sh

# Aliases/functions
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions

export PATH="$HOME/.rbenv/shims:$HOME/.linuxbrew/bin:$PATH:/usr/bin:/usr/local/bin:/bin"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
