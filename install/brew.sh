# Install Homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew upgrade

brew tap homebrew/cask-versions

# Install packages
brew install ack
brew install autoconf
brew install cmatrix
brew install gcc
brew install geoip
brew install cargo
brew install pip
brew install make
brew install gist
brew install git
brew install graphicsmagick
brew install imagemagick
brew install lazygit
brew install memcached
brew install mongodb
brew install mysql
brew install nginx
brew install node
brew install openssl
brew install ossp-uuid
brew install postgresql
brew install python
brew install rbenv
brew install readline
brew install redis
brew install ruby-build
brew install ruby-install
brew install spark
brew install sqlite
brew install terminal-notifier
brew install tig
brew install watchman
brew install wifi-password
brew install yarn
brew install z
brew install zsh
brew install heroku
brew install htop
brew install neovim
brew install gnu-sed # nvim pluging spectre requirement
brew install ripgrep

# Wait a bit before moving on...
sleep 1

# ...and then.
echo "Success! Basic brew packages are installed."

# Install cask packages
# ...

# Wait a bit before moving on...
sleep 1

# ...and then.
echo "Success! Brew additional applications are installed."
