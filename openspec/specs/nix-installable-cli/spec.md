# nix-installable-cli Specification

## Purpose
TBD - created by archiving change nix-flake-install. Update Purpose after archive.
## Requirements
### Requirement: CLI binary available via nix shell
The flake SHALL expose `cloudia-aws-reader` as an executable binary when a user runs `nix shell .` in the project root. The binary name MUST be exactly `cloudia-aws-reader` (no `.py` suffix).

#### Scenario: Run via nix shell
- **WHEN** a user runs `nix shell .` followed by `cloudia-aws-reader --help`
- **THEN** the command executes successfully and prints usage information

#### Scenario: No .py suffixed binary in PATH
- **WHEN** a user runs `nix shell .`
- **THEN** only `cloudia-aws-reader` (without `.py`) SHALL be available in `$out/bin/`

### Requirement: Installable as flake input
The flake SHALL be usable as an input in another flake's `inputs` block. When consumed as an input, the `packages.<system>.default` output SHALL provide the `cloudia-aws-reader` binary.

#### Scenario: Consume as flake input
- **WHEN** another flake adds this flake as an input and includes `inputs.cloudia-reader-aws.packages.${system}.default` in its environment
- **THEN** the `cloudia-aws-reader` binary SHALL be available on PATH

### Requirement: Clean binary installation
The `package.nix` SHALL install `cloudia-aws-reader` as the sole binary without leaving the `.py`-suffixed copy in `$out/bin/`.

#### Scenario: Only named binary in output
- **WHEN** the package is built with `nix build .`
- **THEN** `result/bin/` SHALL contain `cloudia-aws-reader` and SHALL NOT contain `cloudia-aws-reader.py`

### Requirement: Package version from VERSION file
`package.nix` SHALL read the version from `./VERSION` using `builtins.readFile` instead of a hardcoded string.

#### Scenario: Version matches VERSION file
- **WHEN** the package is built
- **THEN** the package `version` attribute SHALL equal the trimmed contents of `./VERSION`

### Requirement: DevShell includes release tooling
The Nix devShell SHALL include `gum` and `gh` as build inputs so release tooling is available without additional setup.

#### Scenario: gum available in devShell
- **WHEN** the user enters the devShell via `nix develop`
- **THEN** `gum` SHALL be on PATH

#### Scenario: gh available in devShell
- **WHEN** the user enters the devShell via `nix develop`
- **THEN** `gh` SHALL be on PATH

