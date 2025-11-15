# Quick Reference - Conventional Commits

Quick reference for commit messages.

## Basic Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Common Types

| Type | When to Use | Version |
|------|-------------|---------|
| `feat` | New functionality | MINOR |
| `fix` | Bug fix | PATCH |
| `docs` | Documentation only | PATCH |
| `perf` | Performance improvement | PATCH |
| `refactor` | Code refactoring | PATCH |
| `test` | Add/update tests | - |
| `chore` | Maintenance/tasks | - |
| `ci` | CI/CD changes | - |

## Suggested Scopes

- `redis` - Redis specific
- `memcached` - Memcached specific
- `security` - Security
- `backup` - Backups
- `monitoring` - Monitoring
- `network` - Network
- `variables` - Variables
- `outputs` - Outputs
- `examples` - Examples
- `docs` - Documentation

## Quick Examples

### Feature
```bash
git commit -m "feat(redis): add cluster mode"
```

### Bug Fix
```bash
git commit -m "fix(security): correct validation"
```

### Breaking Change
```bash
git commit -m "feat!: rename variable

BREAKING CHANGE: vpc_subnets → subnets_pvt"
```

### Documentation
```bash
git commit -m "docs(readme): update examples"
```

## Useful Commands

```bash
# Validate last commit
make commit-check

# Format code
make fmt

# Validate everything
make ci

# Simulate release
make release-dry-run
```
