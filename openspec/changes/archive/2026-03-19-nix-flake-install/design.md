## Context

The project currently uses `scripts=['cloudia-aws-reader.py']` in `setup.py`, which installs the script with the `.py` extension. The Nix `package.nix` works around this with a `postInstall` step that copies the file without the extension. The script already has a `main()` function and `if __name__ == "__main__"` guard at line 74.

## Goals / Non-Goals

**Goals:**
- `cloudia-aws-reader` binary available on PATH via `nix shell .`
- `cloudia-aws-reader` binary available when this flake is added as an input to another flake
- Clean setuptools packaging without filename hacks

**Non-Goals:**
- Renaming the script file itself
- Changing the Python module structure (no new packages/modules)
- Supporting pip install outside of Nix

## Decisions

### Use `console_scripts` entry point instead of `scripts=`

**Choice**: Replace `scripts=['cloudia-aws-reader.py']` with `entry_points={'console_scripts': ['cloudia-aws-reader=cloudia-aws-reader:main']}` (using importlib-friendly module reference).

**Rationale**: `console_scripts` generates a wrapper that calls `main()` directly, installing the binary with the exact name specified. No post-install rename needed.

**Complication**: The module name `cloudia-aws-reader.py` contains hyphens, which are not valid Python identifiers. The entry point must reference it in a way setuptools can resolve. Two options:

1. **Rename the file** to `cloudia_aws_reader.py` and use `cloudia_aws_reader:main` as the entry point. Update `package.nix` `src` filtering if needed.
2. **Keep the file**, use `importlib` in a thin wrapper, or keep using `scripts=` but fix the name in Nix.

**Decision**: Keep using `scripts=` (since the file has hyphens and is a standalone script, not a module), and fix the Nix packaging to handle the binary name properly. The `postInstall` in `package.nix` already does this — the real issue is that `buildPythonPackage` format may not be ideal for a standalone script. Switch to `installPhase` that installs the script directly as `cloudia-aws-reader`.

**Revised approach**: Use `pkgs.writeScriptBin` or a simpler `installPhase` in `package.nix` that wraps the Python script with the correct name, OR keep `buildPythonPackage` with `postInstall` but also add `postFixup` to remove the `.py` suffixed version. The simplest correct fix: keep `postInstall` copy and add `rm $out/bin/cloudia-aws-reader.py` to avoid confusion.

### Keep flake.nix structure as-is

The flake already exposes `packages.default` which is what `nix shell .` uses. No changes needed to `flake.nix`.

## Risks / Trade-offs

- [Hyphenated filename] → Cannot use `console_scripts` entry point directly. Mitigation: keep `scripts=` directive and handle naming in Nix `postInstall`.
- [postInstall hack remains] → Acceptable trade-off given the hyphenated filename constraint. The hack is small and well-understood.
