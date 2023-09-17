#!/bin/bash

# Get the count of incomplete reminders using AppleScript
REMINDERS_COUNT=$(osascript -e '
  tell application "Reminders"
    set remindersList to list "Reminders"
    set incompleteReminders to (every reminder of remindersList whose completed is false)
    return count of incompleteReminders
  end tell
')

# Define the sketchybar command
SKETCHYBAR_CMD="sketchybar -m --set reminders"

# Set reminders icon and label based on the count
if [[ $REMINDERS_COUNT -gt 0 ]]; then
  $SKETCHYBAR_CMD icon="" label="$REMINDERS_COUNT"
else
  $SKETCHYBAR_CMD icon="" label=""
fi

