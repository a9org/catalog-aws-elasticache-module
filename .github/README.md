# GitHub Workflows

Este diretório contém os workflows do GitHub Actions para CI/CD do módulo AWS ElastiCache Terraform.

## Workflows Disponíveis

### 1. Release (`release.yml`)

**Trigger**: Push para branch `main`

**Propósito**: Automatizar completamente o processo de release

**Etapas**:
1. Checkout do código
2. Instalação do Semantic Release e plugins
3. Análise de commits desde a última release
4. Determinação da nova versão (major, minor, patch)
5. Geração do CHANGELOG.md
6. Criação de tag Git
7. Criação de GitHub Release com assets
8. Commit das mudanças (CHANGELOG, VERSION)

**Permissões Necessárias**:
- `contents: write` - Para criar tags e commits
- `pull-requests: write` - Para comentar em PRs

**Variáveis de Ambiente**:
- `GITHUB_TOKEN` - Fornecido automaticamente pelo GitHub

**Exemplo de Uso**:
```bash
# Fazer commit seguindo conventional commits
git commit -m "feat(redis): add cluster mode support"

# Push para main (ou merge PR)
git push origin main

# Release será criada automaticamente
```

---

### 2. Validate (`validate.yml`)

**Trigger**: 
- Pull requests para `main`
- Push em branches que não sejam `main`

**Propósito**: Validar código antes do merge

**Jobs**:

#### terraform-validate
- Verifica formatação do Terraform
- Valida sintaxe do Terraform
- Valida exemplos

#### commit-lint
- Valida mensagens de commit em PRs
- Garante conformidade com Conventional Commits

#### documentation
- Verifica existência de README.md
- Valida documentação dos exemplos
- Gera documentação Terraform

**Exemplo de Uso**:
```bash
# Criar PR
git checkout -b feat/new-feature
git commit -m "feat(redis): add new feature"
git push origin feat/new-feature

# Workflow será executado automaticamente
```

---

### 3. Tag Validation (`tag.yml`)

**Trigger**: Push de tags com formato `v*`

**Propósito**: Validar tags de release

**Etapas**:
1. Valida formato da tag (v1.2.3)
2. Valida configuração Terraform
3. Cria release notes

**Formato de Tag Válido**:
- `v1.2.3` - Release normal
- `v1.2.3-beta.1` - Pre-release
- `v1.2.3-alpha.1` - Alpha release
- `v1.2.3-rc.1` - Release candidate

---

## Templates

### Pull Request Template (`pull_request_template.md`)

Template automático para PRs com seções para:
- Descrição das mudanças
- Tipo de mudança
- Issues relacionadas
- Checklist de validação
- Breaking changes

### Issue Templates

#### Bug Report (`ISSUE_TEMPLATE/bug_report.md`)
Template para reportar bugs com:
- Descrição do bug
- Passos para reproduzir
- Comportamento esperado vs atual
- Configuração Terraform
- Informações de ambiente

#### Feature Request (`ISSUE_TEMPLATE/feature_request.md`)
Template para solicitar features com:
- Descrição da feature
- Caso de uso
- Solução proposta
- Exemplo de configuração
- Alternativas consideradas

---

## Configuração de Secrets

### Secrets Necessários

#### GITHUB_TOKEN
- **Tipo**: Automático
- **Uso**: Criação de releases, tags, commits
- **Configuração**: Fornecido automaticamente pelo GitHub
- **Permissões**: Configuradas no workflow

### Secrets Opcionais

Para funcionalidades adicionais, você pode configurar:

#### NPM_TOKEN
- **Uso**: Publicar pacote npm (se aplicável)
- **Configuração**: Settings → Secrets → New repository secret

#### SLACK_WEBHOOK
- **Uso**: Notificações de release no Slack
- **Configuração**: Settings → Secrets → New repository secret

---

## Configuração de Branch Protection

Recomendações para proteção da branch `main`:

```yaml
Branch Protection Rules:
  - Require pull request reviews before merging: ✓
  - Require status checks to pass before merging: ✓
    - terraform-validate
    - commit-lint
    - documentation
  - Require branches to be up to date before merging: ✓
  - Require conversation resolution before merging: ✓
  - Do not allow bypassing the above settings: ✓
```

**Configurar em**: Settings → Branches → Add rule

---

## Fluxo de Trabalho Completo

### 1. Desenvolvimento

```bash
# Criar branch de feature
git checkout -b feat/add-feature

# Fazer mudanças
vim main.tf

# Commit seguindo conventional commits
git commit -m "feat(redis): add new feature"

# Push
git push origin feat/add-feature
```

### 2. Pull Request

```bash
# Criar PR no GitHub
gh pr create --title "feat(redis): add new feature" --body "Description"

# Workflows de validação executam automaticamente:
# - terraform-validate ✓
# - commit-lint ✓
# - documentation ✓
```

### 3. Review e Merge

```bash
# Após aprovação, merge para main
gh pr merge --squash

# Ou via interface do GitHub
```

### 4. Release Automática

```bash
# Workflow de release executa automaticamente:
# 1. Analisa commits: feat → minor version bump
# 2. Nova versão: 1.0.0 → 1.1.0
# 3. Gera CHANGELOG.md
# 4. Cria tag v1.1.0
# 5. Cria GitHub Release
# 6. Commit de release
```

---

## Troubleshooting

### Workflow Falhou

#### Erro: "Resource not accessible by integration"
**Causa**: Permissões insuficientes
**Solução**: Verificar permissões no workflow (contents: write)

#### Erro: "No new version to release"
**Causa**: Nenhum commit que justifique release
**Solução**: Usar tipos de commit corretos (feat, fix, etc.)

#### Erro: "Commit message does not follow format"
**Causa**: Mensagem de commit inválida
**Solução**: Seguir formato: `type(scope): subject`

### Validação Falhou

#### Erro: "Terraform format check failed"
**Causa**: Arquivos não formatados
**Solução**: 
```bash
terraform fmt -recursive
git add .
git commit --amend --no-edit
git push --force-with-lease
```

#### Erro: "Commit message validation failed"
**Causa**: Mensagem não segue Conventional Commits
**Solução**: Reescrever mensagem:
```bash
git commit --amend -m "feat(redis): correct message"
git push --force-with-lease
```

---

## Monitoramento

### Verificar Status dos Workflows

```bash
# Via GitHub CLI
gh run list

# Ver detalhes de um run
gh run view <run-id>

# Ver logs
gh run view <run-id> --log
```

### Verificar Releases

```bash
# Listar releases
gh release list

# Ver detalhes de uma release
gh release view v1.2.3
```

---

## Customização

### Adicionar Novo Workflow

1. Criar arquivo em `.github/workflows/`
2. Definir triggers e jobs
3. Testar em branch de feature
4. Merge para main

### Modificar Workflow Existente

1. Editar arquivo do workflow
2. Testar mudanças
3. Criar PR com mudanças
4. Merge após validação

### Adicionar Notificações

Exemplo de notificação Slack:

```yaml
- name: Notify Slack
  if: success()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "New release: ${{ github.ref_name }}"
      }
```

---

## Referências

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Release](https://semantic-release.gitbook.io/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)
