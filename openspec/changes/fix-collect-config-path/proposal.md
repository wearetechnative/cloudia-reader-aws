## Why

`collect_commands.yaml` is opened via a relative CWD path, which fails when the binary is installed via Nix and run from a different directory. The file is a static config shipped with the package and must be resolvable regardless of CWD.

## What Changes

- Copy `collect_commands.yaml` alongside the binary in `package.nix` `postInstall`
- Update `commands/collect.py` to resolve `collect_commands.yaml` relative to the main script location (same directory as the binary) instead of CWD

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `nix-installable-cli`: The Nix package must include `collect_commands.yaml` alongside the installed binary

## Impact

- `commands/collect.py` — path resolution for `collect_commands.yaml`
- `package.nix` — copy yaml file in `postInstall`
