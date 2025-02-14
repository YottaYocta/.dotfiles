#!/bin/bash

# Ensure that a directory name is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <dirname>"
  exit 1
fi

# Get the directory name from the first argument
DIRNAME=$1

# Change to the specified directory
cd "$DIRNAME" || { echo "Directory $DIRNAME not found"; exit 1; }

# Run dune clean in the directory
dune clean

# Go back to the parent directory
cd ..

# Create a zip file while excluding macOS files like .DS_Store and ._ files
zip -r "${DIRNAME}submission.zip" "$DIRNAME" -x "*/.DS_Store" -x "*/._*" -x "*/MACOS"

echo "Zipping completed. The file is named ${DIRNAME}submission.zip."

