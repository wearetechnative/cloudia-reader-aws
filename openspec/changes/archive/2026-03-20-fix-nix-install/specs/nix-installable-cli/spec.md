## MODIFIED Requirements

### Requirement: CLI binary available via nix shell
The flake SHALL expose `cloudia-aws-reader` as an executable binary when a user runs `nix shell .` in the project root. The binary name MUST be exactly `cloudia-aws-reader` (no `.py` suffix). The binary SHALL discover and load its command modules regardless of the current working directory.

#### Scenario: Run via nix shell
- **WHEN** a user runs `nix shell .` followed by `cloudia-aws-reader --help`
- **THEN** the command executes successfully and prints usage information including all available commands

#### Scenario: Run from arbitrary directory
- **WHEN** a user runs `cloudia-aws-reader` from a directory other than the source tree
- **THEN** the command SHALL still discover and list all available commands

## ADDED Requirements

### Requirement: Build-time version substitution
`package.nix` SHALL substitute a version placeholder in the script with the actual version string during the build, so the installed binary has the version baked in.

#### Scenario: Version baked in during Nix build
- **WHEN** the package is built with `nix build`
- **THEN** the installed script SHALL contain the actual version string, not the placeholder
