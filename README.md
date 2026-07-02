# CrossOver Patch

This repository contains a patch script for applying a local CrossOver macOS patch that replaces the bundled executable with a patched launcher workflow.

## Usage

1. Install CrossOver into /Applications.
2. Copy it to your home Applications folder:
   ```bash
   mkdir -p "$HOME/Applications"
   cp -R /Applications/CrossOver.app "$HOME/Applications/"
   ```
3. Run the patch script from the repo directory:
   ```bash
   bash patch.sh
   ```

## Notes

The script expects CrossOver.app to be available at:

```bash
$HOME/Applications/CrossOver.app/Contents/MacOS
```
