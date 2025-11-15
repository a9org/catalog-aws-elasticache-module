# Commit Examples

Practical examples of commit messages following Conventional Commits.

## Features (Minor Version Bump)

### Add New Functionality
```bash
git commit -m "feat(redis): add support for Redis 7.1

Add configuration support for Redis engine version 7.1.
Includes new parameters and validation rules.

Closes #123"
```

### New Variable
```bash
git commit -m "feat(variables): add data_tiering_enabled variable

Allow users to enable data tiering for r6gd node types.
Defaults to false for backward compatibility."
```

## Bug Fixes (Patch Version Bump)

### Bug Fix
```bash
git commit -m "fix(security): correct CIDR block validation

Fix regex pattern that was rejecting valid CIDR blocks.
Now properly validates all IPv4 CIDR notations.

Fixes #456"
```

### Output Fix
```bash
git commit -m "fix(outputs): return correct endpoint for Memcached

Change output to use configuration_endpoint instead of
primary_endpoint_address for Memcached clusters."
```

## Breaking Changes (Major Version Bump)

### Rename Variable
```bash
git commit -m "feat(variables)!: rename vpc_subnets to subnets_pvt

BREAKING CHANGE: Variable vpc_subnets renamed to subnets_pvt
for IDP naming alignment.

Migration: Replace vpc_subnets with subnets_pvt in configs."
```

### Remove Deprecated Feature
```bash
git commit -m "feat!: remove deprecated snapshot_name variable

BREAKING CHANGE: The deprecated snapshot_name variable has been
removed. Use snapshot_arns instead.

Migration guide:
- Old: snapshot_name = "my-snapshot"
- New: snapshot_arns = ["arn:aws:elasticache:...:snapshot:my-snapshot"]"
```

## Documentation (Patch Version Bump)

### Update README
```bash
git commit -m "docs(readme): add Redis 7.1 compatibility note

Document that Redis 7.1 is now supported and add
configuration examples."
```

### Update Examples
```bash
git commit -m "docs(examples): improve Redis cluster example

Add more detailed comments and configuration options
to the Redis cluster mode example."
```

## Performance (Patch Version Bump)

### Optimize Resource
```bash
git commit -m "perf(security): optimize security group rule creation

Reduce number of API calls by batching security group rules.
Improves apply time by ~30%."
```

## Refactoring (Patch Version Bump)

### Code Refactoring
```bash
git commit -m "refactor(locals): simplify naming logic

Extract common naming patterns into reusable locals.
No functional changes."
```

## Chores (No Version Bump)

### Update Dependencies
```bash
git commit -m "chore: update Terraform AWS provider to 5.30

Update provider version for latest bug fixes."
```

### Update CI
```bash
git commit -m "ci: add terraform validate to PR workflow

Ensure Terraform configuration is valid before merge."
```

## Multiple Scopes

### Cross-cutting Change
```bash
git commit -m "feat(redis,memcached): add SNS notification support

Add notification_topic_arn variable for both Redis and
Memcached clusters to enable SNS notifications.

Closes #789"
```

## With Issue References

### Feature with Issue
```bash
git commit -m "feat(backup): add automated backup configuration

Implement automated backup scheduling with configurable
retention periods and backup windows.

Implements #234
Closes #235"
```

### Fix with Multiple Issues
```bash
git commit -m "fix(security): correct multiple security group issues

- Fix CIDR block validation
- Fix security group rule ordering
- Fix default ingress rules

Fixes #456, #457, #458"
```
