# version-ssot Specification

## Purpose
Single source of truth for the project version via a plain-text VERSION file, read by the application, package.nix, and setup.py.

## Requirements

### Requirement: VERSION file as single source of truth
The project SHALL have a `VERSION` file at the repository root containing exactly one line: the semantic version string in `MAJOR.MINOR.PATCH` format.

#### Scenario: VERSION file exists with valid content
- **WHEN** the VERSION file is read
- **THEN** it SHALL contain a valid semver string (e.g., `0.2.0`) with an optional trailing newline

### Requirement: Python application reads version from VERSION file
The `cloudia-aws-reader.py` application SHALL read its version from the `VERSION` file at runtime, resolved relative to the script's own location.

#### Scenario: Application displays version from VERSION file
- **WHEN** the user runs `cloudia-aws-reader --help`
- **THEN** the displayed version SHALL match the contents of the `VERSION` file

#### Scenario: VERSION file is missing
- **WHEN** the `VERSION` file cannot be found at runtime
- **THEN** the application SHALL exit with a clear error message indicating the VERSION file is missing

### Requirement: package.nix reads version from VERSION file
`package.nix` SHALL read the version string from `./VERSION` using `builtins.readFile` and strip whitespace.

#### Scenario: Nix build uses VERSION file
- **WHEN** the package is built with `nix build`
- **THEN** the package version SHALL match the contents of the `VERSION` file

### Requirement: setup.py reads version from VERSION file
`setup.py` SHALL read the version string from the `VERSION` file rather than hardcoding it.

#### Scenario: setup.py uses VERSION file
- **WHEN** `setup.py` is evaluated
- **THEN** the `version` argument SHALL match the contents of the `VERSION` file
