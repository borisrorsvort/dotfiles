# Dotfiles

Dotfiles I use with MacOS.

Contains:

1. [Git config](https://github.com/mihaliak/dotfiles/blob/master/dots/.gitconfig), [Git global ignore](https://github.com/mihaliak/dotfiles/blob/master/dots/.gitignore_global)
2. iTerm2 profile
3. Packages / CLI (brew, brew cask, dockutil, htop, iftop, openssl, git, node, python, wget, yarn)
4. Applications (google-chrome, slack, spotify, sublime-text, postman, iterm2, spectacle, appcleaner, ...)

## Install

On fresh installation of MacOS:

    sudo softwareupdate -i -a
    xcode-select --install

Clone and install dotfiles:
```
git clone https://github.com/grsmto/dotfiles.git ~/dotfiles
chmod +wx ~/dotfiles/install/install.sh
chmod -R +wx ~/dotfiles/bin
~/dotfiles/install/install.sh
```

## Additional steps

### Iterm

1. In iterm `Preferences > General > Load preferences from a custom folder or URL` and set it to `~/dotfiles/iterm`
2. `sudo reboot`
3. Enjoy

### VScode

1. Copy settings from ./~/dotfiles/vscode/settings.json

## The `dots` command

    $ dots
    ￫ Usage: dots <command>

    Commands:
       help             This help message
       install          Run the master install script to bootstrap the system
       backup           Dump current brew packages, commit changes, and push to git
       clean            Clean up caches (brew, npm, yarn, composer)
       symlinks         Run symlinks script
       brew             Run brew script

## Credits

All credits for the scripts and ideas from [mihaliak dotfiles](https://github.com/mihaliak/dotfiles). Thanks!

## TODO

- [ ] Add `/Sites` folder
