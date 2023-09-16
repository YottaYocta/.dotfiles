#!/bin/bash

# Check if Homebrew is installed, and install it if it's not
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install applications using Homebrew
brew install --cask blender musescore firefox iterm2
brew tap FelixKratz/formulae
brew install sketchybar

# Start Sketchybar as a service
brew services start sketchybar

# Change the shell to Zsh
chsh -s /bin/zsh

echo "Setup complete! Please restart your terminal for changes to take effect."

