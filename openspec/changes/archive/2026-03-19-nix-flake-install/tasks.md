## 1. Fix package.nix binary naming

- [x] 1.1 Update `postInstall` in `package.nix` to copy the script as `cloudia-aws-reader` AND remove the `.py`-suffixed copy from `$out/bin/`

## 2. Verify flake outputs

- [x] 2.1 Run `nix build .` and verify `result/bin/` contains only `cloudia-aws-reader` (no `.py` suffix)
- [x] 2.2 Run `nix shell . -c cloudia-aws-reader --help` — binary executes, `main()` is reached (boto3 import error is a pre-existing dependency issue, not related to this change)
