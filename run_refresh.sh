#!/bin/sh

#!/bin/bash

# Check if Homebrew is installed, and install it if it's not
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check if Sketchybar is installed
if brew list --formula | grep -q "sketchybar"; then
    # Sketchybar is already installed; refresh it
    brew upgrade sketchybar
else
    # Sketchybar is not installed; install it
    brew tap FelixKratz/formulae
    brew install sketchybar
fi

# Start Sketchybar as a service
brew services start sketchybar
sketchybar --reload

