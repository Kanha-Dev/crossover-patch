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

## Method 1: Patch a CrossOver app copied from your Downloads folder

1. Download CrossOver and place the app bundle in your Downloads folder.
2. Copy it into your home Applications folder:

```bash
mkdir -p "$HOME/Applications"
cd "$HOME/Downloads"
cp -R "./CrossOver.app" "$HOME/Applications/CrossOver.app"
```

3. Clone this repository and run the patch script:

```bash
git clone https://github.com/Kanha-Dev/crossover-patch.git
cd "$HOME/crossover-patch"
bash patch.sh
```

## Method 2: Patch the official CrossOver install from /Applications

1. Install CrossOver normally into `/Applications`.
2. Copy it to your home Applications folder:

```bash
mkdir -p "$HOME/Applications"
cp -R "/Applications/CrossOver.app" "$HOME/Applications/CrossOver.app"
```

3. Clone this repository and run the patch script:

```bash
git clone https://github.com/Kanha-Dev/crossover-patch.git
cd "$HOME/crossover-patch"
bash patch.sh
```

## Notes

The script expects CrossOver.app to be available at:

```bash
$HOME/Applications/CrossOver.app/Contents/MacOS
```

If the patch source files are missing locally, the script will try to use the repository version from this folder.

## Notes

The script expects CrossOver.app to be available at:

```bash
$HOME/Applications/CrossOver.app/Contents/MacOS
```

If the local patch files are not present, it falls back to a GitHub-based remote source, but the preferred workflow is to use the files in this repository.
