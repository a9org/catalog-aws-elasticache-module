# Release Process

This document describes the automated release process for the AWS ElastiCache Terraform module.

## Overview

The project uses [Semantic Release](https://semantic-release.gitbook.io/) to fully automate the versioning and release creation process based on [Conventional Commits](https://www.conventionalcommits.org/).

## How It Works

### 1. Commit to Main Branch

When a commit is made (or PR is merged) to the `main` branch, the release workflow is automatically triggered.

### 2. Commit Analysis

Semantic Release analyzes all commits since the last release to determine:

- **If a new release is needed**
- **What type of version** (major, minor, patch)
- **Which changes to include** in release notes

### 3. Version Determination

The version is automatically determined based on commit types:

| Commit Type | Example | Version Bump | Resulting Version |
|-------------|---------|--------------|-------------------|
| `feat:` | `feat(redis): add cluster mode` | MINOR | 1.0.0 → 1.1.0 |
| `fix:` | `fix(security): correct CIDR validation` | PATCH | 1.0.0 → 1.0.1 |
| `perf:` | `perf(redis): optimize connection pooling` | PATCH | 1.0.0 → 1.0.1 |
| `BREAKING CHANGE:` | `feat!: rename vpc_subnets variable` | MAJOR | 1.0.0 → 2.0.0 |

### 4. Artifact Generation

The process automatically generates:

- **Git Tag**: `v1.2.3`
- **GitHub Release**: With formatted release notes
- **CHANGELOG.md**: Updated with changes
- **VERSION**: File with version number
- **Assets**: Terraform files attached to release

### 5. Release Commit

An automatic commit is created with:
```
chore(release): 1.2.3 [skip ci]

## [1.2.3](https://github.com/.../compare/v1.2.2...v1.2.3) (2024-01-15)

### Features
* add new feature ([abc123])

### Bug Fixes
* fix critical bug ([def456])
```

## Commit Format

### Basic Structure

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Commit Types

#### Features (Minor Version)
```bash
git commit -m "feat(redis): add support for data tiering"
```

#### Bug Fixes (Patch Version)
```bash
git commit -m "fix(security): correct ingress rule validation"
```

#### Breaking Changes (Major Version)
```bash
git commit -m "feat(variables)!: rename vpc_subnets to subnets_pvt

BREAKING CHANGE: The variable vpc_subnets has been renamed to subnets_pvt.
Users must update their configurations."
```

#### Documentation (Patch Version)
```bash
git commit -m "docs(readme): update usage examples"
```

#### Performance (Patch Version)
```bash
git commit -m "perf(redis): optimize parameter group creation"
```

#### Refactoring (Patch Version)
```bash
git commit -m "refactor(locals): simplify naming logic"
```

#### Others (No Release)
```bash
git commit -m "chore: update dependencies"
git commit -m "test: add validation tests"
git commit -m "ci: update workflow configuration"
```

## Recommended Scopes

Use scopes to indicate the affected area:

- `redis`: Redis-specific functionality
- `memcached`: Memcached-specific functionality
- `security`: Security groups, encryption
- `backup`: Snapshots, backups
- `monitoring`: CloudWatch, logs, SNS
- `network`: VPC, subnets, security groups
- `variables`: Input variables
- `outputs`: Module outputs
- `examples`: Configuration examples
- `docs`: Documentation

## Release Notes Examples

### Minor Release (1.0.0 → 1.1.0)

```markdown
# [1.1.0](https://github.com/.../compare/v1.0.0...v1.1.0) (2024-01-15)

## Features

* **redis**: add support for data tiering ([abc123](https://github.com/.../commit/abc123))
* **monitoring**: add CloudWatch log delivery configuration ([def456](https://github.com/.../commit/def456))

## Bug Fixes

* **security**: correct CIDR block validation logic ([ghi789](https://github.com/.../commit/ghi789))
```

### Major Release (1.0.0 → 2.0.0)

```markdown
# [2.0.0](https://github.com/.../compare/v1.0.0...v2.0.0) (2024-01-15)

## ⚠ BREAKING CHANGES

* **variables**: The variable `vpc_subnets` has been renamed to `subnets_pvt`

## Features

* **variables**: rename vpc_subnets to subnets_pvt for IDP alignment ([abc123](https://github.com/.../commit/abc123))
```

## Development Workflow

### 1. Create Feature Branch

```bash
git checkout -b feat/add-data-tiering
```

### 2. Make Commits Following Convention

```bash
git add .
git commit -m "feat(redis): add data tiering support

Add configuration for Redis data tiering on r6gd node types.
This allows automatic data management between memory and SSD.

Closes #123"
```

### 3. Create Pull Request

- PR will be automatically validated
- Commits will be checked by commitlint
- Terraform will be validated

### 4. Merge to Main

After approval, merge to `main`:

```bash
git checkout main
git merge feat/add-data-tiering
git push origin main
```

### 5. Automatic Release

GitHub Actions will:
1. Analyze commits
2. Determine new version (1.0.0 → 1.1.0)
3. Generate CHANGELOG.md
4. Create tag `v1.1.0`
5. Create GitHub Release
6. Commit changes

## Semantic Versioning

### MAJOR (X.0.0)

Breaking changes incompatible with previous versions:

- Variable removal
- Renaming required variables
- Output changes that break integrations
- Default behavior changes affecting existing resources

**Example:**
```
feat(variables)!: remove deprecated vpc_subnets variable

BREAKING CHANGE: The deprecated vpc_subnets variable has been removed.
Use subnets_pvt instead.
```

### MINOR (0.X.0)

New features compatible with previous versions:

- New optional variables
- New outputs
- New optional resources
- Feature improvements

**Example:**
```
feat(redis): add support for Redis 7.1

Add support for Redis engine version 7.1 with new features.
All existing configurations remain compatible.
```

### PATCH (0.0.X)

Bug fixes and compatible improvements:

- Bug fixes
- Performance improvements
- Documentation updates
- Internal refactoring

**Example:**
```
fix(security): correct default security group rules

Fix issue where default ingress rules were not properly applied
when ingress_cidr_blocks was not specified.
```

## Special Releases

### Pre-releases

To create pre-releases (beta, alpha, rc):

```bash
# Create pre-release branch
git checkout -b beta

# Make commits normally
git commit -m "feat(redis): add experimental feature"

# Push to beta branch
git push origin beta
```

Configure in `.releaserc.json`:
```json
{
  "branches": [
    "main",
    {"name": "beta", "prerelease": true},
    {"name": "alpha", "prerelease": true}
  ]
}
```

This will generate versions like: `v1.1.0-beta.1`

### Hotfixes

For urgent hotfixes:

```bash
# Create hotfix branch
git checkout -b hotfix/critical-bug

# Make fix commit
git commit -m "fix(security): patch critical vulnerability"

# Merge directly to main
git checkout main
git merge hotfix/critical-bug
git push origin main
```

Release will be created automatically as patch: `1.0.0 → 1.0.1`

## Release Verification

### Check Latest Release

```bash
# Via GitHub CLI
gh release view

# Via Git
git describe --tags --abbrev=0
```

### Check CHANGELOG

```bash
cat CHANGELOG.md
```

### Check VERSION

```bash
cat VERSION
```

## Troubleshooting

### Release Not Created

Check if:
1. Commits follow Conventional Commits format
2. There are commits that justify a release (feat, fix, etc.)
3. Workflow has correct permissions
4. GITHUB_TOKEN is configured

### Incorrect Version

If generated version is incorrect:
1. Check commit type used
2. Confirm BREAKING CHANGE is in footer (not subject)
3. Review rules in `.releaserc.json`

### Commits Not Appearing in CHANGELOG

Commits with types `chore`, `test`, `build`, `ci` are hidden by default.
Use `feat`, `fix`, `docs`, `perf`, or `refactor` to appear in CHANGELOG.

## Best Practices

1. **Atomic Commits**: One commit = one logical change
2. **Descriptive Messages**: Explain "why", not just "what"
3. **Consistent Scope**: Use same scopes throughout project
4. **Clear Breaking Changes**: Document impact and migration
5. **Test Before Merge**: Validate locally before creating PR
6. **Squash Commits**: Consider squashing feature commits before merge

## References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Semantic Release](https://semantic-release.gitbook.io/)
- [Keep a Changelog](https://keepachangelog.com/)
