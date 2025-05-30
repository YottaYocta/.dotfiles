#!/bin/bash

# Check if Homebrew is installed, and install it if it's not
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install applications using Homebrew
brew tap homebrew/cask-fonts
brew tap FelixKratz/formulae

brew install --cask firefox iterm2 amethyst font-hack-nerd-font font-monoid
brew install --cask homebrew/cask-fonts/font-monoid
brew install python java git-lfs node coreutils git-quick-stats

# Update npm
npm update -g npm

source $(brew --prefix nvm)/nvm.sh

# Symlink java
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk \
     /Library/Java/JavaVirtualMachines/openjdk.jdk


# Change the shell to Zsh
chsh -s /bin/zsh

echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc

echo "Setup complete! Please restart your terminal for changes to take effect."

