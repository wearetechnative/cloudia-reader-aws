## Why

When `cloudia-aws-reader` is installed via Nix flake and run from outside the source tree, it fails with two errors: (1) VERSION file not found — the script resolves VERSION relative to `__file__`, which is `/nix/store/.../bin/`, where VERSION doesn't exist; (2) commands not discovered — `pkgutil.iter_modules(["commands"])` uses a relative path that only works when CWD is the source directory.

## What Changes

- Bake version string into the script at Nix build time via `substituteInPlace` in `package.nix`, keeping the runtime file read as a fallback for development
- Fix command discovery to use package-relative paths (`__path__` on the `commands` module) instead of string-based relative paths
- Ensure `commands/` is properly installed as a Python package in the Nix build

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `version-ssot`: Version reading must work both in development (read VERSION file) and when installed via Nix (baked-in at build time)
- `nix-installable-cli`: The installed binary must discover and load command modules from the installed package, not from a relative CWD path

## Impact

- `cloudia-aws-reader.py` — version reading and command discovery logic
- `package.nix` — build-time version substitution and ensuring commands package is installed
