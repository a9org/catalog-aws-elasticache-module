# Contributing to AWS ElastiCache Terraform Module

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## Commit Message Convention

This project follows the [Conventional Commits](https://www.conventionalcommits.org/) specification. All commit messages must be formatted accordingly.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: A new feature (triggers minor version bump)
- **fix**: A bug fix (triggers patch version bump)
- **docs**: Documentation only changes (triggers patch version bump)
- **style**: Changes that don't affect code meaning (formatting, etc)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement (triggers patch version bump)
- **test**: Adding or updating tests
- **build**: Changes to build system or dependencies
- **ci**: Changes to CI/CD configuration
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Scope (Optional)

The scope should specify the area of the codebase affected:

- `redis`: Redis-specific changes
- `memcached`: Memcached-specific changes
- `security`: Security group or encryption changes
- `backup`: Backup and snapshot changes
- `monitoring`: Monitoring and logging changes
- `examples`: Changes to example configurations
- `docs`: Documentation changes

### Subject

- Use imperative, present tense: "add" not "added" nor "adds"
- Don't capitalize first letter
- No period (.) at the end
- Maximum 100 characters

### Examples

#### Feature Addition
```
feat(redis): add support for data tiering

Implement data tiering configuration for Redis clusters using r6gd node types.
This allows automatic data management between memory and SSD.

Closes #123
```

#### Bug Fix
```
fix(security): correct ingress rule CIDR block validation

Fix validation logic that was rejecting valid CIDR blocks.
The regex pattern now properly handles all valid IPv4 CIDR notations.

Fixes #456
```

#### Documentation
```
docs(examples): add Redis cluster mode usage guide

Add comprehensive documentation for deploying Redis in cluster mode,
including architecture diagrams and cost considerations.
```

#### Breaking Change
```
feat(variables)!: rename vpc_subnets to subnets_pvt

BREAKING CHANGE: The variable `vpc_subnets` has been renamed to `subnets_pvt`
to better align with IDP naming conventions. Users must update their
configurations to use the new variable name.

Migration guide:
- Replace `vpc_subnets` with `subnets_pvt` in all module calls
```

## Versioning

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR** version (X.0.0): Breaking changes
- **MINOR** version (0.X.0): New features (backward compatible)
- **PATCH** version (0.0.X): Bug fixes (backward compatible)

Versions are automatically determined based on commit messages:

- Commits with `BREAKING CHANGE:` in footer → MAJOR bump
- Commits with `feat:` type → MINOR bump
- Commits with `fix:`, `perf:`, `docs:`, `refactor:` → PATCH bump
- Other commits → No version bump

## Pull Request Process

1. **Fork the repository** and create your branch from `main`

2. **Make your changes** following the coding standards

3. **Write meaningful commit messages** following the convention above

4. **Update documentation** if you're adding or changing functionality

5. **Test your changes**:
   ```bash
   terraform fmt -check -recursive
   terraform init -backend=false
   terraform validate
   ```

6. **Create a Pull Request** with:
   - Clear title following commit convention
   - Description of changes
   - Reference to related issues
   - Screenshots (if applicable)

7. **Wait for CI checks** to pass:
   - Terraform validation
   - Commit message linting
   - Documentation checks

8. **Address review feedback** if requested

## Development Workflow

### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/your-org/aws-elasticache-terraform-module.git
cd aws-elasticache-terraform-module

# Install pre-commit hooks (optional but recommended)
brew install pre-commit
pre-commit install
```

### Running Validations Locally

```bash
# Format Terraform files
terraform fmt -recursive

# Validate module
terraform init -backend=false
terraform validate

# Validate examples
for example in examples/*/; do
  cd "$example"
  terraform init -backend=false
  terraform validate
  cd -
done
```

### Testing Commit Messages

```bash
# Install commitlint
npm install -g @commitlint/cli @commitlint/config-conventional

# Test your commit message
echo "feat(redis): add new feature" | commitlint
```

## Code Style Guidelines

### Terraform

- Use 2 spaces for indentation
- Use snake_case for resource names and variables
- Group related resources with comments
- Add descriptions to all variables and outputs
- Use validation blocks for input validation
- Keep lines under 100 characters when possible

### Documentation

- Update README.md for user-facing changes
- Update example READMEs when modifying examples
- Include code examples for new features
- Document breaking changes clearly

## Release Process

Releases are automated via GitHub Actions:

1. **Merge to main**: When a PR is merged to `main`
2. **Semantic Release**: Analyzes commits since last release
3. **Version Bump**: Determines new version based on commit types
4. **Changelog**: Generates CHANGELOG.md automatically
5. **GitHub Release**: Creates release with notes and assets
6. **Git Tag**: Tags the release commit

### Manual Release (if needed)

```bash
# Ensure you're on main and up to date
git checkout main
git pull

# Run semantic-release locally (requires GITHUB_TOKEN)
export GITHUB_TOKEN=your_token
npx semantic-release
```

## Getting Help

- **Issues**: Open an issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Documentation**: Check README.md and example READMEs

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Help others learn and grow

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
