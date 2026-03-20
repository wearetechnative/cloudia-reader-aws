## Context

The script `cloudia-aws-reader.py` was designed to run from the source directory. Two assumptions break when installed via Nix into `/nix/store/`:
1. `Path(__file__).parent / "VERSION"` points to `$out/bin/VERSION` which doesn't exist
2. `pkgutil.iter_modules(["commands"])` uses a relative string path — only works if CWD is the source root

## Goals / Non-Goals

**Goals:**
- VERSION available when installed via Nix and when running from source
- Commands discoverable when installed via Nix and when running from source
- Minimal changes — fix the two bugs, don't restructure the project

**Non-Goals:**
- Proper Python package entry points (future work)
- Removing setup.py scripts-based install

## Decisions

### Version: try runtime file read, fall back to baked-in constant
The script first tries to read `VERSION` relative to `__file__`. If that fails, it falls back to a `_BAKED_VERSION` constant. In `package.nix`, `substituteInPlace` replaces the placeholder with the actual version at build time.

```python
_BAKED_VERSION = "__VERSION_PLACEHOLDER__"

_version_file = Path(__file__).resolve().parent / "VERSION"
if _version_file.exists():
    __version__ = _version_file.read_text().strip()
elif _BAKED_VERSION != "__VERSION_PLACEHOLDER__":
    __version__ = _BAKED_VERSION
else:
    print("ERROR: ...")
    sys.exit(1)
```

**Why**: This keeps the development workflow (reads file) while also working in Nix. The `substituteInPlace` in package.nix replaces the placeholder, so the fallback is always available in installed builds.

### Commands: use importlib to find the commands package path
Instead of `pkgutil.iter_modules(["commands"])` (relative string path), use the actual installed package location:

```python
import commands as commands_pkg
pkgutil.iter_modules(commands_pkg.__path__)
```

This works both from source (where `commands/` is in CWD and importable) and when installed (where `commands/` is in site-packages).

**Why**: `__path__` is the standard Python mechanism for finding submodule locations. It works regardless of installation method.

### package.nix: substituteInPlace for version baking
Add a `postPatch` phase to substitute the version placeholder:

```nix
postPatch = ''
  substituteInPlace cloudia-aws-reader.py \
    --replace-quiet "__VERSION_PLACEHOLDER__" "${version}"
'';
```

**Why**: `postPatch` runs before build, so the substitution is baked into the installed script.

## Risks / Trade-offs

- **[Placeholder string in source]** → Using a distinctive string `__VERSION_PLACEHOLDER__` that won't appear accidentally. The fallback logic means it degrades gracefully if substitution is somehow skipped.
- **[commands import at module level]** → `import commands` could shadow a stdlib module in older Python. Python 3.11+ has no stdlib `commands` module, and the project uses 3.11, so this is safe.
