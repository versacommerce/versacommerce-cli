# Bump version

This command bump version, changes CHANGELOG.md if exists, commit and push changes.

## Usage

```
/bump-version
```

## Process

1. Find current app version in config/version.rb or in CHANGELOG.md
2. Bump the app version number - new features should increase the minor version number, bug fixes should increase the patch version number. Breaking changes should increase the major version number. Follow [Semantic Versioning](https://semver.org/).
3. Update config/version.rb if exists
4. Update CHANGELOG.md if exists, ask user which changes that in not released section should be included in new version.
5. commit the changes with a short, but descriptive message
6. Ask user approval to push the changes to the remote repository
