## Why

The script is installed as `cloudia-aws-reader.py` by setuptools (`scripts=` directive). The Nix `package.nix` works around this with a `postInstall` copy, but `nix shell .` and flake-based installs don't expose `cloudia-aws-reader` on PATH cleanly because the package relies on a filename-based hack rather than a proper console_scripts entry point.

## What Changes

- Convert `setup.py` from `scripts=['cloudia-aws-reader.py']` to a `console_scripts` entry point so the binary is natively installed as `cloudia-aws-reader`
- Remove the `postInstall` copy hack from `package.nix`
- Ensure the flake's `packages.default` output works with `nix shell .` and as a flake input

## Capabilities

### New Capabilities

- `nix-installable-cli`: Proper console_scripts entry point and Nix packaging so `cloudia-aws-reader` is available via `nix shell .` or as a flake input dependency

### Modified Capabilities

_(none)_

## Impact

- `setup.py`: switch from `scripts=` to `entry_points.console_scripts`
- `cloudia-aws-reader.py`: may need a `main()` function extracted for the entry point
- `package.nix`: remove `postInstall` hack, switch to proper Python package format
- `flake.nix`: no structural changes needed (already exposes `packages.default`)
