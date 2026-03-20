## 1. Package the config file

- [x] 1.1 Add `cp $src/collect_commands.yaml $out/bin/` to `postInstall` in `package.nix`

## 2. Fix path resolution

- [x] 2.1 Add `--collect-commands` argument to `run()` in `commands/collect.py`, defaulting to the yaml resolved via `Path(sys.argv[0]).resolve().parent`
- [x] 2.2 Update `collect()` to use the argument path instead of hardcoded `"collect_commands.yaml"`
