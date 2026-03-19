#!/usr/bin/env bash
set -euo pipefail

# --- Dependency check ---
for cmd in gum gh git; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: '$cmd' not found on PATH. Enter the Nix devShell: nix develop"
    exit 1
  fi
done

# --- Clean working tree guard ---
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "ERROR: Working tree is not clean. Commit or stash changes first."
  exit 1
fi

# --- Read current version ---
VERSION_FILE="$(cd "$(dirname "$0")" && pwd)/VERSION"
if [[ ! -f "$VERSION_FILE" ]]; then
  echo "ERROR: VERSION file not found at $VERSION_FILE"
  exit 1
fi
current_version="$(cat "$VERSION_FILE" | tr -d '[:space:]')"

IFS='.' read -r major minor patch <<< "$current_version"

echo "Current version: $current_version"

# --- Select bump type ---
bump_type="$(gum choose "patch" "minor" "major")"

# --- Compute new version ---
case "$bump_type" in
  patch) patch=$((patch + 1)) ;;
  minor) minor=$((minor + 1)); patch=0 ;;
  major) major=$((major + 1)); minor=0; patch=0 ;;
esac

new_version="${major}.${minor}.${patch}"
echo "Bumping: $current_version → $new_version"

# --- Confirm ---
gum confirm "Release v${new_version}?" || exit 0

# --- Update VERSION file ---
echo "$new_version" > "$VERSION_FILE"

# --- Update CHANGELOG.md ---
CHANGELOG="$(cd "$(dirname "$0")" && pwd)/CHANGELOG.md"
if [[ -f "$CHANGELOG" ]]; then
  sed -i "s/^## Next$/## Next\n\n## ${new_version}/" "$CHANGELOG"
else
  echo "WARNING: CHANGELOG.md not found, skipping changelog update"
fi

# --- Git commit, tag, push ---
git add VERSION CHANGELOG.md
git commit -m "release: v${new_version}"
git tag -a "v${new_version}" -m "v${new_version}"

echo "Pushing commit and tag..."
git push origin HEAD:main
git push origin "v${new_version}"

# --- GitHub release ---
gh release create "v${new_version}" --title "v${new_version}" --generate-notes

echo "Released v${new_version}"
