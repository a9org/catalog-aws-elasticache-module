# Setup Guide - CI/CD and Automated Versioning

This guide explains how to configure and use the module's CI/CD and automated versioning system.

## 📋 What Was Implemented

### 1. GitHub Actions Workflows

- **Release Workflow** (`.github/workflows/release.yml`)
  - Automatic releases based on commits
  - Automatic semantic versioning
  - CHANGELOG generation
  - Tag and GitHub Release creation

- **Validation Workflow** (`.github/workflows/validate.yml`)
  - Terraform validation
  - Commit message linting
  - Documentation verification

- **Tag Validation** (`.github/workflows/tag.yml`)
  - Tag format validation
  - Release verification

### 2. Versioning Configuration

- **Semantic Release** (`.releaserc.json`)
  - Automatic commit analysis
  - Version determination
  - Release notes generation

- **Commitlint** (`.commitlintrc.json`)
  - Commit message validation
  - Conventional Commits compliance

### 3. Development Tools

- **Pre-commit Hooks** (`.pre-commit-config.yaml`)
  - Automatic formatting
  - Pre-commit validation
  - File linting

- **Makefile**
  - Simplified commands
  - Common task automation

- **TFLint** (`.tflint.hcl`)
  - Terraform-specific linting
  - AWS rules

### 4. Documentation

- **CONTRIBUTING.md** - Contribution guide
- **RELEASE.md** - Release process
- **CHANGELOG.md** - Change history
- **VERSION** - Current version

## 🚀 Quick Start

### Step 1: Install Tools

```bash
# Using Makefile
make install-tools

# Or manually
brew install terraform tflint terraform-docs pre-commit
npm install -g @commitlint/cli @commitlint/config-conventional
```

### Step 2: Configure Pre-commit

```bash
pre-commit install
```

### Step 3: Make First Commit

```bash
git add .
git commit -m "feat: initial module implementation"
git push origin main
```

### Step 4: Check Release

The release will be created automatically! Check at:
- GitHub → Releases
- CHANGELOG.md
- VERSION file

## 📝 How to Use

### Making Correct Commits

```bash
# Feature (minor version)
git commit -m "feat(redis): add cluster mode support"

# Bug fix (patch version)
git commit -m "fix(security): correct validation logic"

# Breaking change (major version)
git commit -m "feat!: rename variable

BREAKING CHANGE: vpc_subnets renamed to subnets_pvt"
```

### Useful Commands

```bash
# Validate everything locally
make ci

# Format code
make fmt

# Validate Terraform
make validate

# Generate documentation
make docs

# Simulate release
make release-dry-run
```

## 🔄 Workflow

1. **Create Branch**
   ```bash
   git checkout -b feat/new-feature
   ```

2. **Develop**
   ```bash
   # Make changes
   vim main.tf
   
   # Validate locally
   make test
   ```

3. **Commit**
   ```bash
   git add .
   git commit -m "feat(redis): add new feature"
   ```

4. **Push and PR**
   ```bash
   git push origin feat/new-feature
   gh pr create
   ```

5. **Merge**
   - After approval, merge to main
   - Release created automatically!

## 📊 Versioning

### Version Types

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features
- **PATCH** (1.0.0 → 1.0.1): Bug fixes

### Commit Types

| Type | Description | Version |
|------|-------------|---------|
| `feat:` | New feature | MINOR |
| `fix:` | Bug fix | PATCH |
| `perf:` | Performance | PATCH |
| `docs:` | Documentation | PATCH |
| `BREAKING CHANGE:` | Breaking | MAJOR |

## 🛠️ Troubleshooting

### Release Not Created

Check:
1. Do commits follow correct format?
2. Are there commits that justify a release?
3. Does workflow have permissions?

### Validation Failed

```bash
# Format code
make fmt

# Validate
make validate

# Lint
make lint
```

## 📚 Complete Documentation

- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [RELEASE.md](RELEASE.md) - Release process
- [.github/README.md](.github/README.md) - Workflows
- [Makefile](Makefile) - Available commands

## 🎯 Next Steps

1. Configure branch protection on GitHub
2. Add secrets if necessary
3. Customize workflows as needed
4. Make your first commit and see the magic happen!

## ✅ Configuration Checklist

- [ ] Tools installed
- [ ] Pre-commit configured
- [ ] Branch protection configured
- [ ] First commit made
- [ ] Automatic release working
- [ ] Team trained in Conventional Commits
