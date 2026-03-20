## MODIFIED Requirements

### Requirement: Python application reads version from VERSION file
The `cloudia-aws-reader.py` application SHALL read its version from the `VERSION` file at runtime when available, and fall back to a build-time baked version constant when the file is not present (e.g., when installed via Nix).

#### Scenario: Application displays version from VERSION file
- **WHEN** the user runs `cloudia-aws-reader --help` from the source directory
- **THEN** the displayed version SHALL match the contents of the `VERSION` file

#### Scenario: Application displays version when installed via Nix
- **WHEN** the user runs `cloudia-aws-reader --help` after installing via `nix shell` or as a flake input
- **THEN** the displayed version SHALL match the version baked in at build time

#### Scenario: VERSION file is missing and no baked version
- **WHEN** the `VERSION` file cannot be found at runtime and no version was baked in at build time
- **THEN** the application SHALL exit with a clear error message indicating the VERSION file is missing
