## Context

Version is hardcoded in three files with existing drift. The repo is jj/git colocated — the developer uses jj day-to-day but the release script should be pure git so any contributor or CI can use it. The Nix devShell provides the development environment.

## Goals / Non-Goals

**Goals:**
- Single source of truth for version in a plain `VERSION` file
- All version consumers (Python app, package.nix, setup.py) read from `VERSION`
- Interactive release script using bash + gum for the picker
- Pure git operations in release.sh (no jj dependency)
- GitHub release creation via `gh`
- Release tooling available via Nix devShell

**Non-Goals:**
- CI/CD integration (manual release only for now)
- Pre-release or build metadata suffixes (strict `MAJOR.MINOR.PATCH`)
- Automated changelog generation from commits

## Decisions

### VERSION file format: plain text
A single line containing `MAJOR.MINOR.PATCH` with a trailing newline. No JSON, no TOML — just the version string.

**Why over alternatives**: Nix reads it with `builtins.readFile` + `lib.trim`, Python with `open().read().strip()`, bash with `cat`. Zero parsing needed anywhere.

### Python reads VERSION at runtime via `pathlib`
`cloudia-aws-reader.py` resolves `VERSION` relative to `__file__` using `pathlib.Path(__file__).resolve().parent / "VERSION"`. This works whether run from source or installed.

**Why not bake in at build time**: Runtime reading is simpler, no build-time substitution needed, and the VERSION file is already included in the package source.

### package.nix reads VERSION via builtins.readFile
```nix
version = builtins.replaceStrings ["\n"] [""] (builtins.readFile ./VERSION);
```

**Why**: Native Nix, no extra dependencies, evaluates at build time.

### setup.py reads VERSION via open()
```python
version=open("VERSION").read().strip(),
```

**Why**: Keeps setup.py working for non-Nix packagers without adding dependencies.

### Interactive picker: gum
`gum choose "patch" "minor" "major"` provides a clean TUI dropdown.

**Why over fzf**: gum is purpose-built for script UIs, simpler API, better styled output. Already available in nixpkgs.

### release.sh is pure git
Uses `git add`, `git commit`, `git tag`, `git push`. Works for git users, jj-colocated users, and CI. The dirty-tree guard (`git diff --quiet`) catches uncommitted jj changes too.

### Git tag format: `v<version>`
Tags are `v0.2.0` not `0.2.0`. This is the most common convention and what `gh release create` expects by default.

## Risks / Trade-offs

- **[Runtime VERSION read fails if file missing]** → The app should fail with a clear error message pointing to the missing VERSION file, not a cryptic traceback.
- **[gum not available outside devShell]** → release.sh checks for `gum` and `gh` at startup and exits with instructions if missing.
- **[jj working copy out of sync]** → The `git diff --quiet` guard catches this. If user has uncommitted jj changes, they'll be told to commit first.
