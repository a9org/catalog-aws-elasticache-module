.PHONY: help init validate fmt lint docs test clean install-tools

# Default target
.DEFAULT_GOAL := help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)AWS ElastiCache Terraform Module - Available Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

install-tools: ## Install required development tools
	@echo "$(BLUE)Installing development tools...$(NC)"
	@command -v terraform >/dev/null 2>&1 || (echo "$(RED)Terraform not found. Install from https://www.terraform.io/downloads$(NC)" && exit 1)
	@command -v pre-commit >/dev/null 2>&1 || (echo "$(YELLOW)Installing pre-commit...$(NC)" && brew install pre-commit)
	@command -v tflint >/dev/null 2>&1 || (echo "$(YELLOW)Installing tflint...$(NC)" && brew install tflint)
	@command -v terraform-docs >/dev/null 2>&1 || (echo "$(YELLOW)Installing terraform-docs...$(NC)" && brew install terraform-docs)
	@npm list -g @commitlint/cli >/dev/null 2>&1 || (echo "$(YELLOW)Installing commitlint...$(NC)" && npm install -g @commitlint/cli @commitlint/config-conventional)
	@pre-commit install
	@echo "$(GREEN)✓ All tools installed$(NC)"

init: ## Initialize Terraform
	@echo "$(BLUE)Initializing Terraform...$(NC)"
	@terraform init -backend=false
	@echo "$(GREEN)✓ Terraform initialized$(NC)"

validate: init ## Validate Terraform configuration
	@echo "$(BLUE)Validating Terraform configuration...$(NC)"
	@terraform validate
	@echo "$(GREEN)✓ Validation successful$(NC)"

fmt: ## Format Terraform files
	@echo "$(BLUE)Formatting Terraform files...$(NC)"
	@terraform fmt -recursive
	@echo "$(GREEN)✓ Formatting complete$(NC)"

fmt-check: ## Check Terraform formatting
	@echo "$(BLUE)Checking Terraform formatting...$(NC)"
	@terraform fmt -check -recursive
	@echo "$(GREEN)✓ Format check passed$(NC)"

lint: ## Lint Terraform files with tflint
	@echo "$(BLUE)Linting Terraform files...$(NC)"
	@tflint --init
	@tflint --config=.tflint.hcl
	@echo "$(GREEN)✓ Linting complete$(NC)"

docs: ## Generate documentation
	@echo "$(BLUE)Generating documentation...$(NC)"
	@terraform-docs markdown table --config .terraform-docs.yml --output-file README.md .
	@echo "$(GREEN)✓ Documentation generated$(NC)"

test: fmt-check validate lint ## Run all tests
	@echo "$(BLUE)Running all tests...$(NC)"
	@echo "$(GREEN)✓ All tests passed$(NC)"

validate-examples: ## Validate example configurations
	@echo "$(BLUE)Validating examples...$(NC)"
	@for example in examples/*/; do \
		echo "$(YELLOW)Validating $$example$(NC)"; \
		cd "$$example" && \
		terraform init -backend=false && \
		terraform validate && \
		cd - > /dev/null; \
	done
	@echo "$(GREEN)✓ All examples validated$(NC)"

commit-check: ## Validate commit message format
	@echo "$(BLUE)Checking last commit message...$(NC)"
	@git log -1 --pretty=%B | npx commitlint
	@echo "$(GREEN)✓ Commit message is valid$(NC)"

pre-commit: ## Run pre-commit hooks on all files
	@echo "$(BLUE)Running pre-commit hooks...$(NC)"
	@pre-commit run --all-files
	@echo "$(GREEN)✓ Pre-commit checks passed$(NC)"

clean: ## Clean temporary files
	@echo "$(BLUE)Cleaning temporary files...$(NC)"
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@find . -type f -name "terraform.tfstate*" -delete 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

version: ## Show current version
	@echo "$(BLUE)Current version:$(NC)"
	@cat VERSION 2>/dev/null || echo "$(YELLOW)No version file found$(NC)"

changelog: ## Show changelog
	@echo "$(BLUE)Changelog:$(NC)"
	@cat CHANGELOG.md 2>/dev/null || echo "$(YELLOW)No changelog found$(NC)"

release-dry-run: ## Simulate a release (requires GITHUB_TOKEN)
	@echo "$(BLUE)Simulating release...$(NC)"
	@npx semantic-release --dry-run
	@echo "$(GREEN)✓ Dry run complete$(NC)"

ci: fmt-check validate lint validate-examples ## Run CI checks locally
	@echo "$(GREEN)✓ All CI checks passed$(NC)"

all: install-tools init test validate-examples docs ## Run all setup and validation steps
	@echo "$(GREEN)✓ All tasks completed successfully$(NC)"
