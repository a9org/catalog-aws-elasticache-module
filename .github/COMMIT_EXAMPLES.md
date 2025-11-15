# Exemplos de Commits

Exemplos práticos de mensagens de commit seguindo Conventional Commits.

## Features (Minor Version Bump)

### Adicionar Nova Funcionalidade
```bash
git commit -m "feat(redis): add support for Redis 7.1

Add configuration support for Redis engine version 7.1.
Includes new parameters and validation rules.

Closes #123"
```

### Nova Variável
```bash
git commit -m "feat(variables): add data_tiering_enabled variable

Allow users to enable data tiering for r6gd node types.
Defaults to false for backward compatibility."
```

## Bug Fixes (Patch Version Bump)

### Correção de Bug
```bash
git commit -m "fix(security): correct CIDR block validation

Fix regex pattern that was rejecting valid CIDR blocks.
Now properly validates all IPv4 CIDR notations.

Fixes #456"
```

### Correção de Output
```bash
git commit -m "fix(outputs): return correct endpoint for Memcached

Change output to use configuration_endpoint instead of
primary_endpoint_address for Memcached clusters."
```

## Breaking Changes (Major Version Bump)

### Renomear Variável
```bash
git commit -m "feat(variables)!: rename vpc_subnets to subnets_pvt

BREAKING CHANGE: Variable vpc_subnets renamed to subnets_pvt
for IDP naming alignment.

Migration: Replace vpc_subnets with subnets_pvt in configs."
```
