#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/Applications"
TARGET_APP="$TARGET_DIR/CrossOver.app"

mkdir -p "$TARGET_DIR"

if [ -d "$TARGET_APP" ]; then
    echo "CrossOver.app already exists at $TARGET_APP"
else
    SOURCE_APP=""

    if [ -d "$SCRIPT_DIR/CrossOver.app" ]; then
        SOURCE_APP="$SCRIPT_DIR/CrossOver.app"
    elif [ -d "$HOME/Downloads/CrossOver.app" ]; then
        SOURCE_APP="$HOME/Downloads/CrossOver.app"
    elif [ -d "/Applications/CrossOver.app" ]; then
        SOURCE_APP="/Applications/CrossOver.app"
    fi

    if [ -z "$SOURCE_APP" ]; then
        echo "CrossOver.app was not found."
        echo "Download the setup bundle from the repo assets or the official CrossOver website, then run this script again."
        exit 1
    fi

    echo "Installing CrossOver from $SOURCE_APP"
    cp -R "$SOURCE_APP" "$TARGET_APP"
fi

if [ -f "$SCRIPT_DIR/patch.sh" ]; then
    echo "Running patch script..."
    bash "$SCRIPT_DIR/patch.sh"
else
    echo "patch.sh was not found in $SCRIPT_DIR"
    exit 1
fi
