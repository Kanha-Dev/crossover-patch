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
3. Copy it to your home Applications folder:

```bash
mkdir -p "$HOME/Applications"
cp -R "/Applications/CrossOver.app" "$HOME/Applications/CrossOver.app"
```

4. Download this patch script directly and run it:

```bash
curl -fsSL https://raw.githubusercontent.com/Kanha-Dev/crossover-patch/main/patch.sh -o /tmp/crossover-patch.sh && bash /tmp/crossover-patch.sh
```

## Method 2: Patch a CrossOver app you already downloaded manually

1. Place your CrossOver app bundle in your Downloads folder.
2. Copy it into your home Applications folder:

```bash
mkdir -p "$HOME/Applications"
cd "$HOME/Downloads"
cp -R "./CrossOver.app" "$HOME/Applications/CrossOver.app"
```

3. Download this patch script directly and run it:

```bash
curl -fsSL https://raw.githubusercontent.com/Kanha-Dev/crossover-patch/main/patch.sh -o /tmp/crossover-patch.sh && bash /tmp/crossover-patch.sh
```

## Notes

The script expects CrossOver.app to be available at:

```bash
$HOME/Applications/CrossOver.app/Contents/MacOS
```

This one-line curl method downloads the patch script and uses the patch source files from this repository automatically.
