## 1. Fix version reading

- [x] 1.1 Add `_BAKED_VERSION` placeholder constant to `cloudia-aws-reader.py` and update version logic to try file read first, then fall back to baked version
- [x] 1.2 Add `postPatch` to `package.nix` to substitute the version placeholder with the actual version

## 2. Fix command discovery

- [x] 2.1 Update `cloudia-aws-reader.py` command loading to use `import commands` + `commands.__path__` instead of string-based relative path
- [x] 2.2 Ensure `commands/` package is properly included in the Nix build (verify `setup.py` `find_packages()` picks it up)
