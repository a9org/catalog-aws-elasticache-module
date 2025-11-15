# Quick Reference - Conventional Commits

Referência rápida para mensagens de commit.

## Formato Básico

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Tipos Comuns

| Tipo | Quando Usar | Versão |
|------|-------------|--------|
| `feat` | Nova funcionalidade | MINOR |
| `fix` | Correção de bug | PATCH |
| `docs` | Apenas documentação | PATCH |
| `perf` | Melhoria de performance | PATCH |
| `refactor` | Refatoração de código | PATCH |
| `test` | Adicionar/atualizar testes | - |
| `chore` | Manutenção/tarefas | - |
| `ci` | Mudanças em CI/CD | - |

## Scopes Sugeridos

- `redis` - Redis específico
- `memcached` - Memcached específico
- `security` - Segurança
- `backup` - Backups
- `monitoring` - Monitoramento
- `network` - Rede
- `variables` - Variáveis
- `outputs` - Outputs
- `examples` - Exemplos
- `docs` - Documentação

## Exemplos Rápidos

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

### Documentação
```bash
git commit -m "docs(readme): update examples"
```

## Comandos Úteis

```bash
# Validar último commit
make commit-check

# Formatar código
make fmt

# Validar tudo
make ci

# Simular release
make release-dry-run
```
