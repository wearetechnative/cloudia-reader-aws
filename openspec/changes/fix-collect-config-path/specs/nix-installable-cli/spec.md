## ADDED Requirements

### Requirement: Package includes collect_commands.yaml
The Nix package SHALL include `collect_commands.yaml` alongside the installed binary so the collect command can find it at runtime.

#### Scenario: collect_commands.yaml available in Nix store
- **WHEN** the package is built with `nix build`
- **THEN** `collect_commands.yaml` SHALL exist in `$out/bin/`

### Requirement: Collect command resolves config from binary location
The collect command SHALL resolve `collect_commands.yaml` relative to the binary location by default, not the current working directory, so it works when installed via Nix.

#### Scenario: Collect runs from arbitrary directory
- **WHEN** the user runs `cloudia-aws-reader collect` from a directory other than the source tree
- **THEN** the command SHALL find and load `collect_commands.yaml` without error

### Requirement: Overridable collect commands file
The collect command SHALL accept a `--collect-commands` argument to specify a custom yaml file path, overriding the default bundled one.

#### Scenario: Custom collect commands file
- **WHEN** the user runs `cloudia-aws-reader collect --collect-commands /path/to/custom.yaml`
- **THEN** the command SHALL load collect commands from the specified file

#### Scenario: Default collect commands file
- **WHEN** the user runs `cloudia-aws-reader collect` without `--collect-commands`
- **THEN** the command SHALL load the bundled `collect_commands.yaml` from the binary location
