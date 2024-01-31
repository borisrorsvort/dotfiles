# Install Homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew upgrade

brew tap homebrew/cask-versions

# Install packages
xargs brew install < ~/dotfiles/dots/brewfile.txt
xargs brew install < ~/dotfiles/dots/brewcaskfile.txt

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
