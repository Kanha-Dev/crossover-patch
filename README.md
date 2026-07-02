# CrossOver Patch

This repository contains a local patch workflow for CrossOver on macOS. Instead of depending on a third-party remote repository for the patch assets, this repo carries its own patch source files and uses them when patching a copied CrossOver application.

## What this does

The script:

1. Checks that a copy of CrossOver exists at `$HOME/Applications/CrossOver.app/Contents/MacOS`.
2. Uses the local workspace files `pco.sh` and `hook.m` as the patch source.
3. Builds `hook.dylib` from `hook.m` using `clang`.
4. Signs the patched library and replaces the original CrossOver executable with the patched launcher workflow.
5. Leaves the original executable as a backup file so the app can still be restored if needed.

## Setup and installation

### Method 1: Download the setup from GitHub Releases / assets

1. Download the CrossOver setup bundle from the GitHub releases or assets for this repository.
2. Place the downloaded bundle in your Downloads folder.
3. Run these commands in order:

```bash
mkdir -p "$HOME/Applications"
cd "$HOME/Downloads"
cp -R "./CrossOver.app" "$HOME/Applications/CrossOver.app"
```

4. Patch it:

```bash
git clone https://github.com/Kanha-Dev/crossover-patch.git
cd "$HOME/crossover-patch"
bash patch.sh
```

### Method 2: Download the latest official CrossOver build

1. Download the latest CrossOver version from the official CrossOver website.
2. Install it into `/Applications`.
3. Copy it to your home Applications folder with:

```bash
mkdir -p "$HOME/Applications"
cp -R "/Applications/CrossOver.app" "$HOME/Applications/CrossOver.app"
```

4. Patch it:

```bash
git clone https://github.com/Kanha-Dev/crossover-patch.git
cd "$HOME/crossover-patch"
bash patch.sh
```

### One-command curl option

If you want the simplest path, download the patch script directly and let it fetch the needed patch files automatically:

```bash
curl -fsSL https://raw.githubusercontent.com/Kanha-Dev/crossover-patch/main/patch.sh -o /tmp/crossover-patch.sh && bash /tmp/crossover-patch.sh
```

## Notes

The script expects CrossOver.app to be available at:

```bash
$HOME/Applications/CrossOver.app/Contents/MacOS
```

If the local patch files are not present, it falls back to a GitHub-based remote source, but the preferred workflow is to use the files in this repository.
