## MODIFIED Requirements

### Requirement: Package version from VERSION file
`package.nix` SHALL read the version from `./VERSION` using `builtins.readFile` instead of a hardcoded string.

#### Scenario: Version matches VERSION file
- **WHEN** the package is built
- **THEN** the package `version` attribute SHALL equal the trimmed contents of `./VERSION`

## ADDED Requirements

### Requirement: DevShell includes release tooling
The Nix devShell SHALL include `gum` and `gh` as build inputs so release tooling is available without additional setup.

#### Scenario: gum available in devShell
- **WHEN** the user enters the devShell via `nix develop`
- **THEN** `gum` SHALL be on PATH

#### Scenario: gh available in devShell
- **WHEN** the user enters the devShell via `nix develop`
- **THEN** `gh` SHALL be on PATH
