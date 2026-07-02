# CrossOver Patch

This repository contains a local patch workflow for CrossOver on macOS. Instead of depending on a third-party remote repository for the patch assets, this repo carries its own patch source files and uses them when patching a copied CrossOver application.

## What this does

The script:

1. Checks that a copy of CrossOver exists at `$HOME/Applications/CrossOver.app/Contents/MacOS`.
2. Uses the local workspace files `pco.sh` and `hook.m` as the patch source.
3. Builds `hook.dylib` from `hook.m` using `clang`.
4. Signs the patched library and replaces the original CrossOver executable with the patched launcher workflow.
5. Leaves the original executable as a backup file so the app can still be restored if needed.

## Usage

1. Install CrossOver normally into `/Applications`.
2. Copy it to your home Applications folder:
   ```bash
   mkdir -p "$HOME/Applications"
   cp -R /Applications/CrossOver.app "$HOME/Applications/"
   ```
3. Run the patch script from this repository directory:
   ```bash
   bash patch.sh
   ```

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
