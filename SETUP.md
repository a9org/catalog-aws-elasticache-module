# Setup Guide - CI/CD e Versionamento Automático

Este guia explica como configurar e usar o sistema de CI/CD e versionamento automático do módulo.

## 📋 O Que Foi Implementado

### 1. Workflows do GitHub Actions

- **Release Workflow** (`.github/workflows/release.yml`)
  - Releases automáticas baseadas em commits
  - Versionamento semântico automático
  - Geração de CHANGELOG
  - Criação de tags e GitHub Releases

- **Validation Workflow** (`.github/workflows/validate.yml`)
  - Validação de Terraform
  - Lint de mensagens de commit
  - Verificação de documentação

- **Tag Validation** (`.github/workflows/tag.yml`)
  - Validação de formato de tags
  - Verificação de releases

### 2. Configurações de Versionamento

- **Semantic Release** (`.releaserc.json`)
  - Análise automática de commits
  - Determinação de versão
  - Geração de release notes

- **Commitlint** (`.commitlintrc.json`)
  - Validação de mensagens de commit
  - Conformidade com Conventional Commits

### 3. Ferramentas de Desenvolvimento

- **Pre-commit Hooks** (`.pre-commit-config.yaml`)
  - Formatação automática
  - Validação antes do commit
  - Lint de arquivos

- **Makefile**
  - Comandos simplificados
  - Automação de tarefas comuns

- **TFLint** (`.tflint.hcl`)
  - Lint específico para Terraform
  - Regras AWS

### 4. Documentação

- **CONTRIBUTING.md** - Guia de contribuição
- **RELEASE.md** - Processo de release
- **CHANGELOG.md** - Histórico de mudanças
- **VERSION** - Versão atual

## 🚀 Quick Start

### Passo 1: Instalar Ferramentas

```bash
# Usando o Makefile
make install-tools

# Ou manualmente
brew install terraform tflint terraform-docs pre-commit
npm install -g @commitlint/cli @commitlint/config-conventional
```

### Passo 2: Configurar Pre-commit

```bash
pre-commit install
```

### Passo 3: Fazer Primeiro Commit

```bash
git add .
git commit -m "feat: initial module implementation"
git push origin main
```

### Passo 4: Verificar Release

A release será criada automaticamente! Verifique em:
- GitHub → Releases
- CHANGELOG.md
- VERSION file

## 📝 Como Usar

### Fazer Commits Corretos

```bash
# Feature (minor version)
git commit -m "feat(redis): add cluster mode support"

# Bug fix (patch version)
git commit -m "fix(security): correct validation logic"

# Breaking change (major version)
git commit -m "feat!: rename variable

BREAKING CHANGE: vpc_subnets renamed to subnets_pvt"
```

### Comandos Úteis

```bash
# Validar tudo localmente
make ci

# Formatar código
make fmt

# Validar Terraform
make validate

# Gerar documentação
make docs

# Simular release
make release-dry-run
```

## 🔄 Fluxo de Trabalho

1. **Criar Branch**
   ```bash
   git checkout -b feat/nova-funcionalidade
   ```

2. **Desenvolver**
   ```bash
   # Fazer mudanças
   vim main.tf
   
   # Validar localmente
   make test
   ```

3. **Commit**
   ```bash
   git add .
   git commit -m "feat(redis): add new feature"
   ```

4. **Push e PR**
   ```bash
   git push origin feat/nova-funcionalidade
   gh pr create
   ```

5. **Merge**
   - Após aprovação, merge para main
   - Release criada automaticamente!

## 📊 Versionamento

### Tipos de Versão

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): Novas features
- **PATCH** (1.0.0 → 1.0.1): Bug fixes

### Tipos de Commit

| Tipo | Descrição | Versão |
|------|-----------|--------|
| `feat:` | Nova feature | MINOR |
| `fix:` | Bug fix | PATCH |
| `perf:` | Performance | PATCH |
| `docs:` | Documentação | PATCH |
| `BREAKING CHANGE:` | Breaking | MAJOR |

## 🛠️ Troubleshooting

### Release Não Foi Criada

Verifique:
1. Commits seguem formato correto?
2. Há commits que justificam release?
3. Workflow tem permissões?

### Validação Falhou

```bash
# Formatar código
make fmt

# Validar
make validate

# Lint
make lint
```

## 📚 Documentação Completa

- [CONTRIBUTING.md](CONTRIBUTING.md) - Como contribuir
- [RELEASE.md](RELEASE.md) - Processo de release
- [.github/README.md](.github/README.md) - Workflows
- [Makefile](Makefile) - Comandos disponíveis

## 🎯 Próximos Passos

1. Configure branch protection no GitHub
2. Adicione secrets se necessário
3. Customize workflows conforme necessário
4. Faça seu primeiro commit e veja a mágica acontecer!

## ✅ Checklist de Configuração

- [ ] Ferramentas instaladas
- [ ] Pre-commit configurado
- [ ] Branch protection configurada
- [ ] Primeiro commit feito
- [ ] Release automática funcionando
- [ ] Equipe treinada em Conventional Commits
