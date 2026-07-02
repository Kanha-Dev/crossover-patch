#!/bin/bash

TARGET_APP_PATH="${1:-}"
if [ -z "$TARGET_APP_PATH" ]; then
    if [ -d "/Applications/CrossOver.app/Contents/MacOS" ]; then
        TARGET_APP_PATH="/Applications/CrossOver.app"
    elif [ -d "$HOME/Applications/CrossOver.app/Contents/MacOS" ]; then
        TARGET_APP_PATH="$HOME/Applications/CrossOver.app"
    else
        echo "CrossOver.app was not found."
        echo "Pass the app path as an argument, or install/copy CrossOver to /Applications or $HOME/Applications/."
        exit 1
    fi
fi

if [ ! -d "$TARGET_APP_PATH" ]; then
    echo "The specified CrossOver.app path does not exist: $TARGET_APP_PATH"
    echo "Use /Applications/CrossOver.app or $HOME/Applications/CrossOver.app."
    exit 1
fi

TARGET_APP_PATH="$(cd "$TARGET_APP_PATH" 2>/dev/null && pwd)"
CROSSOVER_MACOS_PATH="$TARGET_APP_PATH/Contents/MacOS"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_REPO_PATH="$SCRIPT_DIR/local_patch_source"
WORKSPACE_PATCH_SCRIPT="$SCRIPT_DIR/pco.sh"
WORKSPACE_HOOK_SOURCE="$SCRIPT_DIR/hook.m"
REPO_URL="https://github.com/Kanha-Dev/crossover-patch.git"
RAW_BASE_URL="https://raw.githubusercontent.com/Kanha-Dev/crossover-patch/main"

if [ ! -d "$CROSSOVER_MACOS_PATH" ]; then
    echo "CrossOver.app was found at $TARGET_APP_PATH, but it does not contain Contents/MacOS"
    echo "Please verify the app path and try again."
    exit 1
fi

echo "Patching app at $TARGET_APP_PATH"
cd "$CROSSOVER_MACOS_PATH" || exit 1

if [ ! -f "$WORKSPACE_PATCH_SCRIPT" ] || [ ! -f "$WORKSPACE_HOOK_SOURCE" ]; then
    echo "Patch assets were not found locally. Downloading them from GitHub..."
    if command -v curl >/dev/null 2>&1; then
        mkdir -p "$SCRIPT_DIR"
        curl -fsSL "$RAW_BASE_URL/pco.sh" -o "$WORKSPACE_PATCH_SCRIPT"
        curl -fsSL "$RAW_BASE_URL/hook.m" -o "$WORKSPACE_HOOK_SOURCE"
    else
        echo "curl is required to download the patch assets."
        exit 1
    fi
fi

if [ -f "$WORKSPACE_PATCH_SCRIPT" ] && [ -f "$WORKSPACE_HOOK_SOURCE" ]; then
    echo "Using local workspace patch files"
    rm -rf crossover_patch
    mkdir -p crossover_patch
    cp "$WORKSPACE_PATCH_SCRIPT" crossover_patch/pco.sh
    cp "$WORKSPACE_HOOK_SOURCE" crossover_patch/hook.m
    cd crossover_patch || exit 1
    echo "building hook.dylib because this contains the logic"
    if clang -dynamiclib -framework Foundation -framework AppKit -o hook.dylib hook.m; then
        echo "Build successful."
    else
        echo "Build failed and no fallback patch binary is available locally."
        exit 1
    fi
elif [ -d "$LOCAL_REPO_PATH/.git" ]; then
    echo "Using local patch source from $LOCAL_REPO_PATH"
    rm -rf crossover_patch
    mkdir -p crossover_patch
    cp -R "$LOCAL_REPO_PATH"/. crossover_patch/
    cd crossover_patch || exit 1
    echo "building hook.dylib because this contains the logic"
    if clang -dynamiclib -framework Foundation -framework AppKit -o hook.dylib hook.m; then
        echo "Build successful."
    else
        echo "Build failed and no fallback patch binary is available locally."
        exit 1
    fi
elif git clone "$REPO_URL" crossover_patch; then
    cd crossover_patch || exit 1
    echo "building hook.dylib because this contains the logic"
    if clang -dynamiclib -framework Foundation -framework AppKit -o hook.dylib hook.m; then
        echo "Build successful."
    else
        echo "Build failed and no fallback patch binary is available locally."
        exit 1
    fi
else
    echo "No local patch source files were found and git is unavailable, so the patch cannot continue."
    exit 1
fi

# ok well if it doesnt exist, you've clearly done something wrong
if [ ! -f hook.dylib ]; then
    echo "how the hell is hook.dylib not there?"
    cd ..
    rm -rf crossover_patch
    exit 1
fi

echo "signing it because macos is specal like that"
codesign -f -s - hook.dylib

echo "blah blah moving it to where it belongs"
mv hook.dylib ..
mv ../CrossOver ../CrossOver.o
echo "gotta resign crossover as well because something about macos doing hardened runtime"
codesign -f -s - ../CrossOver.o
mv pco.sh ../CrossOver
chmod +x ../CrossOver

cd ..
rm -rf crossover_patch

echo "uh sure try it out"
