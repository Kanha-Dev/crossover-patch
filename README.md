# CrossOver Patch

This repository contains a small patch workflow for CrossOver on macOS. It is meant to patch a copied CrossOver app so you can test or use the patched launcher locally.

## What this repository does

The patch flow works like this:

1. It checks that a CrossOver app exists at `$HOME/Applications/CrossOver.app/Contents/MacOS`.
2. It copies the local patch source files from this repository into a temporary folder.
3. It builds a dynamic library from `hook.m` using `clang`.
4. It signs the built library with `codesign`.
5. It replaces the original CrossOver executable with the patched launcher workflow.
6. It leaves the original executable renamed as a backup file so you can compare or restore it if needed.

## Method 1: Download CrossOver from the official website and patch it

1. Download the latest CrossOver build from the official CrossOver website.
2. Install it into `/Applications`.
3. Clone this repository and run the patch script directly against the installed app:

```bash
git clone https://github.com/Kanha-Dev/crossover-patch.git
cd "$HOME/crossover-patch"
bash patch.sh /Applications/CrossOver.app
```

## Method 2: Assume CrossOver is already installed and patch it

1. If CrossOver is already installed, run the patch directly against the app bundle path:

```bash
curl -fsSL https://raw.githubusercontent.com/Kanha-Dev/crossover-patch/main/patch.sh -o /tmp/crossover-patch.sh && bash /tmp/crossover-patch.sh /Applications/CrossOver.app
```

2. If CrossOver is installed in your user Applications folder instead, use:

```bash
curl -fsSL https://raw.githubusercontent.com/Kanha-Dev/crossover-patch/main/patch.sh -o /tmp/crossover-patch.sh && bash /tmp/crossover-patch.sh "$HOME/Applications/CrossOver.app"
```

## Notes

The script will automatically detect CrossOver at either:

```bash
/Applications/CrossOver.app
$HOME/Applications/CrossOver.app
```

If the bundle is installed somewhere else, pass the exact app path as the first argument.

This one-line curl method downloads the patch script and uses the patch source files from this repository automatically.
