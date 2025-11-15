# Release Process

Este documento descreve o processo automatizado de releases para o módulo AWS ElastiCache Terraform.

## Visão Geral

O projeto utiliza [Semantic Release](https://semantic-release.gitbook.io/) para automatizar completamente o processo de versionamento e criação de releases baseado em [Conventional Commits](https://www.conventionalcommits.org/).

## Como Funciona

### 1. Commit na Branch Main

Quando um commit é feito (ou PR é merged) na branch `main`, o workflow de release é acionado automaticamente.

### 2. Análise de Commits

O Semantic Release analisa todos os commits desde a última release para determinar:

- **Se uma nova release é necessária**
- **Qual tipo de versão** (major, minor, patch)
- **Quais mudanças incluir** nas release notes

### 3. Determinação da Versão

A versão é determinada automaticamente baseada nos tipos de commit:

| Tipo de Commit | Exemplo | Versão Bump | Versão Resultante |
|----------------|---------|-------------|-------------------|
| `feat:` | `feat(redis): add cluster mode` | MINOR | 1.0.0 → 1.1.0 |
| `fix:` | `fix(security): correct CIDR validation` | PATCH | 1.0.0 → 1.0.1 |
| `perf:` | `perf(redis): optimize connection pooling` | PATCH | 1.0.0 → 1.0.1 |
| `BREAKING CHANGE:` | `feat!: rename vpc_subnets variable` | MAJOR | 1.0.0 → 2.0.0 |

### 4. Geração de Artefatos

O processo gera automaticamente:

- **Tag Git**: `v1.2.3`
- **GitHub Release**: Com release notes formatadas
- **CHANGELOG.md**: Atualizado com as mudanças
- **VERSION**: Arquivo com o número da versão
- **Assets**: Arquivos Terraform anexados à release

### 5. Commit de Release

Um commit automático é criado com:
```
chore(release): 1.2.3 [skip ci]

## [1.2.3](https://github.com/.../compare/v1.2.2...v1.2.3) (2024-01-15)

### Features
* add new feature ([abc123])

### Bug Fixes
* fix critical bug ([def456])
```

## Formato de Commits

### Estrutura Básica

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Tipos de Commit

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

#### Outros (Sem Release)
```bash
git commit -m "chore: update dependencies"
git commit -m "test: add validation tests"
git commit -m "ci: update workflow configuration"
```

## Scopes Recomendados

Use scopes para indicar a área afetada:

- `redis`: Funcionalidades específicas do Redis
- `memcached`: Funcionalidades específicas do Memcached
- `security`: Security groups, encryption
- `backup`: Snapshots, backups
- `monitoring`: CloudWatch, logs, SNS
- `network`: VPC, subnets, security groups
- `variables`: Variáveis de entrada
- `outputs`: Outputs do módulo
- `examples`: Exemplos de configuração
- `docs`: Documentação

## Exemplos de Release Notes

### Release Minor (1.0.0 → 1.1.0)

```markdown
# [1.1.0](https://github.com/.../compare/v1.0.0...v1.1.0) (2024-01-15)

## Features

* **redis**: add support for data tiering ([abc123](https://github.com/.../commit/abc123))
* **monitoring**: add CloudWatch log delivery configuration ([def456](https://github.com/.../commit/def456))

## Bug Fixes

* **security**: correct CIDR block validation logic ([ghi789](https://github.com/.../commit/ghi789))
```

### Release Major (1.0.0 → 2.0.0)

```markdown
# [2.0.0](https://github.com/.../compare/v1.0.0...v2.0.0) (2024-01-15)

## ⚠ BREAKING CHANGES

* **variables**: The variable `vpc_subnets` has been renamed to `subnets_pvt`

## Features

* **variables**: rename vpc_subnets to subnets_pvt for IDP alignment ([abc123](https://github.com/.../commit/abc123))
```

## Workflow de Desenvolvimento

### 1. Criar Branch de Feature

```bash
git checkout -b feat/add-data-tiering
```

### 2. Fazer Commits Seguindo a Convenção

```bash
git add .
git commit -m "feat(redis): add data tiering support

Add configuration for Redis data tiering on r6gd node types.
This allows automatic data management between memory and SSD.

Closes #123"
```

### 3. Criar Pull Request

- O PR será validado automaticamente
- Commits serão verificados pelo commitlint
- Terraform será validado

### 4. Merge para Main

Após aprovação, merge para `main`:

```bash
git checkout main
git merge feat/add-data-tiering
git push origin main
```

### 5. Release Automática

O GitHub Actions irá:
1. Analisar os commits
2. Determinar a nova versão (1.0.0 → 1.1.0)
3. Gerar CHANGELOG.md
4. Criar tag `v1.1.0`
5. Criar GitHub Release
6. Fazer commit das mudanças

## Versionamento Semântico

### MAJOR (X.0.0)

Mudanças incompatíveis com versões anteriores:

- Remoção de variáveis
- Renomeação de variáveis obrigatórias
- Mudanças em outputs que quebram integrações
- Alterações em comportamento padrão que afetam recursos existentes

**Exemplo:**
```
feat(variables)!: remove deprecated vpc_subnets variable

BREAKING CHANGE: The deprecated vpc_subnets variable has been removed.
Use subnets_pvt instead.
```

### MINOR (0.X.0)

Novas funcionalidades compatíveis com versões anteriores:

- Novas variáveis opcionais
- Novos outputs
- Novos recursos opcionais
- Melhorias de funcionalidade

**Exemplo:**
```
feat(redis): add support for Redis 7.1

Add support for Redis engine version 7.1 with new features.
All existing configurations remain compatible.
```

### PATCH (0.0.X)

Correções de bugs e melhorias compatíveis:

- Correções de bugs
- Melhorias de performance
- Atualizações de documentação
- Refatorações internas

**Exemplo:**
```
fix(security): correct default security group rules

Fix issue where default ingress rules were not properly applied
when ingress_cidr_blocks was not specified.
```

## Releases Especiais

### Pre-releases

Para criar pre-releases (beta, alpha, rc):

```bash
# Criar branch de pre-release
git checkout -b beta

# Fazer commits normalmente
git commit -m "feat(redis): add experimental feature"

# Push para branch beta
git push origin beta
```

Configure no `.releaserc.json`:
```json
{
  "branches": [
    "main",
    {"name": "beta", "prerelease": true},
    {"name": "alpha", "prerelease": true}
  ]
}
```

Isso gerará versões como: `v1.1.0-beta.1`

### Hotfixes

Para hotfixes urgentes:

```bash
# Criar branch de hotfix
git checkout -b hotfix/critical-bug

# Fazer commit de fix
git commit -m "fix(security): patch critical vulnerability"

# Merge direto para main
git checkout main
git merge hotfix/critical-bug
git push origin main
```

A release será criada automaticamente como patch: `1.0.0 → 1.0.1`

## Verificação de Releases

### Verificar Última Release

```bash
# Via GitHub CLI
gh release view

# Via Git
git describe --tags --abbrev=0
```

### Verificar CHANGELOG

```bash
cat CHANGELOG.md
```

### Verificar VERSION

```bash
cat VERSION
```

## Troubleshooting

### Release Não Foi Criada

Verifique se:
1. Os commits seguem o formato Conventional Commits
2. Há commits que justificam uma release (feat, fix, etc.)
3. O workflow tem permissões corretas
4. O GITHUB_TOKEN está configurado

### Versão Incorreta

Se a versão gerada está incorreta:
1. Verifique o tipo de commit usado
2. Confirme se BREAKING CHANGE está no footer (não no subject)
3. Revise as regras em `.releaserc.json`

### Commits Não Aparecem no CHANGELOG

Commits com tipos `chore`, `test`, `build`, `ci` são ocultados por padrão.
Use `feat`, `fix`, `docs`, `perf`, ou `refactor` para aparecer no CHANGELOG.

## Boas Práticas

1. **Commits Atômicos**: Um commit = uma mudança lógica
2. **Mensagens Descritivas**: Explique o "porquê", não apenas o "o quê"
3. **Scope Consistente**: Use os mesmos scopes em todo o projeto
4. **Breaking Changes Claros**: Documente impacto e migração
5. **Teste Antes do Merge**: Valide localmente antes de fazer PR
6. **Squash Commits**: Considere squash de commits de feature antes do merge

## Referências

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Semantic Release](https://semantic-release.gitbook.io/)
- [Keep a Changelog](https://keepachangelog.com/)
