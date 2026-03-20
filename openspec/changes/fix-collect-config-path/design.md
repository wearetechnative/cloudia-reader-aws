## Context

`collect_commands.yaml` sits at the repo root and defines which AWS API calls the collect command makes. When installed via Nix, the binary is in `/nix/store/.../bin/` but the yaml is not copied there.

## Goals / Non-Goals

**Goals:**
- `collect_commands.yaml` resolvable when installed via Nix
- Still works when running from source directory

**Non-Goals:**
- Moving the yaml file into `commands/` package
- Fixing other relative paths (web/, audit_config.yaml, etc.)

## Decisions

### Copy yaml alongside binary in postInstall
Add `cp $src/collect_commands.yaml $out/bin/` to `postInstall` in `package.nix`.

**Why**: Keeps the yaml at repo root (no file moves), and the binary can find it via `Path(__file__).resolve().parent`.

### Resolve path relative to script location in collect.py
Use the same pattern as the VERSION file — resolve relative to `__file__`:

```python
_script_dir = Path(__file__).resolve().parent.parent
# parent.parent because collect.py is in commands/, yaml is alongside the main script
```

For development (running from source), `__file__` is `commands/collect.py`, so `.parent.parent` is the repo root where the yaml lives. For Nix install, the `commands` package is in site-packages, so `.parent.parent` won't reach `$out/bin/`. Instead, we pass the path from the main script which knows its own location.

Actually simpler: just try both locations. CWD first (development), then script dir (Nix install).

**Revised approach**: Try `collect_commands.yaml` in CWD first, then fall back to `$out/bin/collect_commands.yaml` resolved via the main script's `__file__`. The main script can set a module-level variable with its directory, or we resolve from `sys.argv[0]`.

**Simplest approach**: Use `Path(sys.argv[0]).resolve().parent / "collect_commands.yaml"` — `sys.argv[0]` is the binary path, which is in `$out/bin/` for Nix installs and the repo root for source runs.

Wait — `sys.argv[0]` when running from source is `cloudia-aws-reader.py` in the repo root. When installed via Nix, it's the wrapper script in `$out/bin/`. Both cases: `parent` is where the yaml is. This works.

## Risks / Trade-offs

- **[sys.argv[0] could be relative]** → Using `.resolve()` to get absolute path.
