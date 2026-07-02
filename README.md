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

### Option 1: Use the repository setup helper (recommended)

If you have the CrossOver app bundle in this repository or in your Downloads folder, run:

```bash
git clone https://github.com/Kanha-Dev/crossover-patch.git
cd crossover-patch
bash setup.sh
```

This command will:
- copy CrossOver.app into `$HOME/Applications`
- run the patch script automatically

### Option 2: Install CrossOver manually

If you want the latest official version, download it from the official CrossOver website.

If you want a packaged setup bundle from this repository, download the app bundle from the repository assets and place it in your Downloads folder.

Then run these commands in order:

```bash
mkdir -p "$HOME/Applications"
cd "$HOME/Downloads"
cp -R "./CrossOver.app" "$HOME/Applications/CrossOver.app"
```

If you installed CrossOver from the official website instead of from the repo assets, the app will already be in `/Applications`. In that case, copy it to your home Applications folder with:

```bash
mkdir -p "$HOME/Applications"
cp -R "/Applications/CrossOver.app" "$HOME/Applications/CrossOver.app"
```

Then run the patch script from the repository folder:

```bash
cd "$HOME/crossover-patch"
bash patch.sh
```

### Option 3: One-command curl option

If you want the simplest path, download the patch script directly and let it fetch the needed patch files automatically:

```bash
curl -fsSL https://raw.githubusercontent.com/Kanha-Dev/crossover-patch/main/patch.sh -o /tmp/crossover-patch.sh && bash /tmp/crossover-patch.sh
```

This works because the script will download its own `pco.sh` and `hook.m` assets from GitHub when they are not already present locally.

## Sandbox testing

For safe end-to-end testing, use a copied version of CrossOver instead of your main install:

```bash
rm -rf "$HOME/Applications/CrossOver.app"
mkdir -p "$HOME/Applications"
cp -R /Applications/CrossOver.app "$HOME/Applications/CrossOver.app"
bash patch.sh
open "$HOME/Applications/CrossOver.app"
```

This lets you test the patch flow without altering your primary installation.

## Notes

The script expects CrossOver.app to be available at:

```bash
$HOME/Applications/CrossOver.app/Contents/MacOS
```

If the local patch files are not present, it falls back to a GitHub-based remote source, but the preferred workflow is to use the files in this repository.
