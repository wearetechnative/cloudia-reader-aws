## 1. VERSION file as SSOT

- [x] 1.1 Create `VERSION` file at repo root containing `0.1.1`
- [x] 1.2 Update `cloudia-aws-reader.py` to read version from VERSION file via pathlib, with clear error on missing file
- [x] 1.3 Update `package.nix` to read version via `builtins.readFile ./VERSION` with whitespace stripping
- [x] 1.4 Update `setup.py` to read version from VERSION file via `open()`

## 2. Nix devShell updates

- [x] 2.1 Add `gum` and `gh` to devShell buildInputs in `flake.nix`

## 3. Release script

- [x] 3.1 Create `release.sh` with dependency check (gum, gh on PATH)
- [x] 3.2 Add clean working tree guard (`git diff --quiet`)
- [x] 3.3 Add interactive bump type selection via `gum choose`
- [x] 3.4 Add semver bump logic (parse current version, compute new version)
- [x] 3.5 Add VERSION file update
- [x] 3.6 Add CHANGELOG.md update (rename `## Next` → `## <version>`, insert new `## Next`)
- [x] 3.7 Add git commit (`release: v<version>`), annotated tag (`v<version>`), push, and `gh release create`
- [x] 3.8 Make `release.sh` executable
