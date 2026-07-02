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

WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/crossover_patch.XXXXXX")"
cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

echo "Patching app at $TARGET_APP_PATH"

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
    cp "$WORKSPACE_PATCH_SCRIPT" "$WORK_DIR/pco.sh"
    cp "$WORKSPACE_HOOK_SOURCE" "$WORK_DIR/hook.m"
elif [ -d "$LOCAL_REPO_PATH/.git" ]; then
    echo "Using local patch source from $LOCAL_REPO_PATH"
    cp -R "$LOCAL_REPO_PATH"/. "$WORK_DIR/"
elif git clone "$REPO_URL" "$WORK_DIR"; then
    echo "Cloned patch source from $REPO_URL"
else
    echo "No local patch source files were found and git is unavailable, so the patch cannot continue."
    exit 1
fi

cd "$WORK_DIR" || exit 1

echo "building hook.dylib because this contains the logic"
if clang -dynamiclib -framework Foundation -framework AppKit -o hook.dylib hook.m; then
    echo "Build successful."
else
    echo "Build failed and no fallback patch binary is available locally."
    exit 1
fi

if [ ! -f "$WORK_DIR/hook.dylib" ]; then
    echo "how the hell is hook.dylib not there?"
    exit 1
fi

echo "signing it because macos is specal like that"
codesign -f -s - "$WORK_DIR/hook.dylib"

echo "moving patch files into the CrossOver app bundle"
cd "$CROSSOVER_MACOS_PATH" || exit 1
if [ -f CrossOver ]; then
    chflags nouchg CrossOver 2>/dev/null || true
    chmod u+w CrossOver 2>/dev/null || true
    if ! mv CrossOver CrossOver.o; then
        echo "Failed to rename CrossOver executable."
        echo "This is often caused by macOS protecting the app bundle or file flags."
        echo "Try removing immutability flags and rerun with sudo, or patch a copy of CrossOver outside /Applications."
        exit 1
    fi
else
    echo "CrossOver executable not found in $CROSSOVER_MACOS_PATH"
    exit 1
fi
cp "$WORK_DIR/pco.sh" CrossOver
cp "$WORK_DIR/hook.dylib" .

echo "gotta resign crossover as well because something about macos doing hardened runtime"
codesign -f -s - CrossOver.o
chmod +x CrossOver

echo "uh sure try it out"
