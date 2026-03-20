# release-automation Specification

## Purpose
Interactive bash release script handling semver bump, changelog update, git tagging, and GitHub release creation. Pure git — works for any contributor or CI.

## Requirements

### Requirement: Interactive version bump selection
`release.sh` SHALL present an interactive menu using `gum choose` allowing the user to select `patch`, `minor`, or `major` as the bump type.

#### Scenario: User selects patch bump
- **WHEN** the user selects "patch" and the current version is `0.1.1`
- **THEN** the new version SHALL be `0.1.2`

#### Scenario: User selects minor bump
- **WHEN** the user selects "minor" and the current version is `0.1.1`
- **THEN** the new version SHALL be `0.2.0`

#### Scenario: User selects major bump
- **WHEN** the user selects "major" and the current version is `0.1.1`
- **THEN** the new version SHALL be `1.0.0`

### Requirement: Clean working tree guard
`release.sh` SHALL verify the git working tree is clean before proceeding. It SHALL exit with an error if there are staged or unstaged changes.

#### Scenario: Dirty working tree
- **WHEN** there are uncommitted changes (staged or unstaged)
- **THEN** the script SHALL exit with a non-zero status and a message instructing the user to commit or stash changes first

#### Scenario: Clean working tree
- **WHEN** the working tree is clean
- **THEN** the script SHALL proceed with the release

### Requirement: Dependency check
`release.sh` SHALL check that `gum` and `gh` are available on PATH before proceeding.

#### Scenario: Missing dependency
- **WHEN** `gum` or `gh` is not found on PATH
- **THEN** the script SHALL exit with an error naming the missing tool and suggesting to enter the Nix devShell

### Requirement: VERSION file update
`release.sh` SHALL write the new version string to the `VERSION` file.

#### Scenario: VERSION file updated
- **WHEN** the user selects a bump type
- **THEN** the `VERSION` file SHALL contain exactly the new version string

### Requirement: CHANGELOG update
`release.sh` SHALL rename the `## Next` heading in `CHANGELOG.md` to `## <new-version>` and insert a new `## Next` section above it.

#### Scenario: CHANGELOG updated after release
- **WHEN** the version is bumped to `0.2.0`
- **THEN** `CHANGELOG.md` SHALL contain `## Next` (empty) followed by `## 0.2.0` with the previous unreleased entries

### Requirement: Git commit and tag
`release.sh` SHALL create a git commit containing the updated `VERSION` and `CHANGELOG.md`, then create an annotated git tag `v<version>`.

#### Scenario: Release commit and tag created
- **WHEN** the release completes
- **THEN** a commit with message `release: v<version>` SHALL exist and a tag `v<version>` SHALL point to it

### Requirement: Push and GitHub release
`release.sh` SHALL push the commit and tag to origin, then create a GitHub release via `gh release create` using the tag.

#### Scenario: GitHub release created
- **WHEN** the push succeeds
- **THEN** a GitHub release titled `v<version>` SHALL be created with the tag `v<version>`

### Requirement: Pure git operations
`release.sh` SHALL use only git commands (no jj commands) so it works for any contributor regardless of their VCS tooling.

#### Scenario: Script contains no jj commands
- **WHEN** the script source is inspected
- **THEN** it SHALL contain no references to `jj` commands
