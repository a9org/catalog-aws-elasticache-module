# 📚 Documentation Index

Complete navigation guide for AWS ElastiCache Terraform module documentation.

## 🚀 Getting Started

| Document | Description | When to Use |
|----------|-------------|-------------|
| [README.md](README.md) | Main module documentation | First read, usage reference |
| [SETUP.md](SETUP.md) | Initial setup guide | Setting up environment for first time |
| [CI_CD_SUMMARY.md](CI_CD_SUMMARY.md) | CI/CD implementation summary | Understanding what was implemented |

## 👥 For Contributors

| Document | Description | When to Use |
|----------|-------------|-------------|
| [CONTRIBUTING.md](CONTRIBUTING.md) | Complete contribution guide | Before contributing |
| [RELEASE.md](RELEASE.md) | Detailed release process | Understanding versioning |
| [.github/QUICK_REFERENCE.md](.github/QUICK_REFERENCE.md) | Quick commit reference | During development |
| [.github/COMMIT_EXAMPLES.md](.github/COMMIT_EXAMPLES.md) | Practical commit examples | Writing commit messages |

## 🔧 Workflows and CI/CD

| Document | Description | When to Use |
|----------|-------------|-------------|
| [.github/README.md](.github/README.md) | Workflow documentation | Understanding/modifying workflows |
| [.github/WORKFLOW_DIAGRAM.md](.github/WORKFLOW_DIAGRAM.md) | Visual flow diagrams | Visualizing process |
| [.github/workflows/release.yml](.github/workflows/release.yml) | Release workflow | Modifying release process |
| [.github/workflows/validate.yml](.github/workflows/validate.yml) | Validation workflow | Modifying validations |
| [.github/workflows/tag.yml](.github/workflows/tag.yml) | Tag validation | Modifying tag validation |

## 📝 Templates

| Document | Description | When to Use |
|----------|-------------|-------------|
| [.github/pull_request_template.md](.github/pull_request_template.md) | Pull Request template | Automatic when creating PR |
| [.github/ISSUE_TEMPLATE/bug_report.md](.github/ISSUE_TEMPLATE/bug_report.md) | Bug report template | Reporting bugs |
| [.github/ISSUE_TEMPLATE/feature_request.md](.github/ISSUE_TEMPLATE/feature_request.md) | Feature request template | Requesting features |

## 📖 Examples

| Document | Description | When to Use |
|----------|-------------|-------------|
| [examples/redis-cluster/README.md](examples/redis-cluster/README.md) | Redis Cluster Mode example | Implementing Redis with sharding |
| [examples/redis-replication/README.md](examples/redis-replication/README.md) | Redis HA example | Implementing Redis with HA |
| [examples/memcached/README.md](examples/memcached/README.md) | Memcached example | Implementing Memcached |

## ⚙️ Configuration

| File | Description | When to Modify |
|------|-------------|----------------|
| [.releaserc.json](.releaserc.json) | Semantic Release config | Changing versioning rules |
| [.commitlintrc.json](.commitlintrc.json) | Commitlint config | Changing commit rules |
| [.pre-commit-config.yaml](.pre-commit-config.yaml) | Pre-commit config | Adding/removing hooks |
| [.tflint.hcl](.tflint.hcl) | TFLint config | Changing lint rules |
| [.terraform-docs.yml](.terraform-docs.yml) | Terraform Docs config | Changing docs format |
| [.markdownlint.json](.markdownlint.json) | Markdown Lint config | Changing markdown rules |
| [Makefile](Makefile) | Automated commands | Adding new commands |

## 📊 History and Version

| File | Description | When to Check |
|------|-------------|---------------|
| [CHANGELOG.md](CHANGELOG.md) | Change history | Viewing changes between versions |
| [VERSION](VERSION) | Current version | Checking installed version |

## 🎯 Common Workflows

### 1. First Time Using the Module
```
README.md → examples/*/README.md → Implement
```

### 2. Setting Up Development Environment
```
SETUP.md → CONTRIBUTING.md → Install tools
```

### 3. Contributing Code
```
CONTRIBUTING.md → .github/QUICK_REFERENCE.md → Develop → PR
```

### 4. Understanding Release Process
```
RELEASE.md → .github/WORKFLOW_DIAGRAM.md → CI_CD_SUMMARY.md
```

### 5. Reporting Bug
```
.github/ISSUE_TEMPLATE/bug_report.md → Fill out → Submit
```

### 6. Requesting Feature
```
.github/ISSUE_TEMPLATE/feature_request.md → Fill out → Submit
```

## 🔍 Quick Search

### I need to know how to...

- **Use the module**: [README.md](README.md)
- **Make a commit**: [.github/QUICK_REFERENCE.md](.github/QUICK_REFERENCE.md)
- **Create a PR**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Understand versioning**: [RELEASE.md](RELEASE.md)
- **Configure CI/CD**: [.github/README.md](.github/README.md)
- **See examples**: [examples/](examples/)
- **Report issue**: [.github/ISSUE_TEMPLATE/bug_report.md](.github/ISSUE_TEMPLATE/bug_report.md)
- **Run commands**: [Makefile](Makefile)

## 📞 Help

Can't find what you're looking for?

1. Use GitHub search (press `/`)
2. Check [README.md](README.md)
3. Open an [issue](https://github.com/your-org/aws-elasticache-terraform-module/issues)

---

**Tip**: Bookmark this file for quick access! 🔖
