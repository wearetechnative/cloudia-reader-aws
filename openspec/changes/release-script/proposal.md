## Why

Version is currently hardcoded in three places (`cloudia-aws-reader.py`, `package.nix`, `setup.py`) with existing drift (0.1.1 vs 0.1.0). There is no release automation — bumping, tagging, and publishing are manual and error-prone. A release script with a single source of truth for version eliminates drift and makes releases repeatable.

## What Changes

- Add a `VERSION` file as the single source of truth for the version string
- Make `cloudia-aws-reader.py` read version from `VERSION` at runtime
- Make `package.nix` read version from `VERSION` via `builtins.readFile`
- Keep `setup.py` reading from `VERSION` for future non-Nix packagers
- Add a `release.sh` bash script (pure git, no jj dependency) that:
  - Guards against a dirty working tree before proceeding
  - Presents an interactive menu to select major/minor/patch bump
  - Bumps the version in `VERSION`
  - Renames the `## Next` placeholder in `CHANGELOG.md` to the new version and adds a fresh `## Next` section
  - Commits the version bump via `git commit`
  - Creates a git tag `v<version>`
  - Pushes commit and tag
  - Creates a GitHub release via `gh`
- Add `gum` and `gh` to the Nix devShell so release tooling is always available

## Capabilities

### New Capabilities
- `version-ssot`: Single source of truth VERSION file read by the app, package.nix, and setup.py
- `release-automation`: Interactive bash release script handling semver bump, changelog, tagging, and GitHub release — pure git so it works for any contributor or CI

### Modified Capabilities
- `nix-installable-cli`: package.nix and devShell gain VERSION file reading and new devShell deps (gum, gh)

## Impact

- `VERSION` (new file)
- `release.sh` (new file)
- `cloudia-aws-reader.py` — version reading changes
- `package.nix` — version source changes
- `setup.py` — version source changes
- `flake.nix` / devShell — new dependencies (gum, gh)
- `CHANGELOG.md` — format stays the same, placeholder handling automated
