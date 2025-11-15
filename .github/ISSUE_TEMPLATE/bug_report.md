---
name: Bug Report
about: Create a report to help us improve
title: 'fix: '
labels: bug
assignees: ''
---

## Bug Description

<!-- A clear and concise description of what the bug is -->

## To Reproduce

Steps to reproduce the behavior:

1. Configure module with '...'
2. Run terraform apply '...'
3. See error '...'

## Expected Behavior

<!-- A clear and concise description of what you expected to happen -->

## Actual Behavior

<!-- What actually happened -->

## Terraform Configuration

```hcl
# Paste your module configuration here (remove sensitive data)
module "elasticache" {
  source = "..."
  
  # Your configuration
}
```

## Error Output

```
# Paste the error output here
```

## Environment

- **Terraform Version**: <!-- e.g., 1.6.0 -->
- **AWS Provider Version**: <!-- e.g., 5.0.0 -->
- **Module Version**: <!-- e.g., 1.2.3 -->
- **AWS Region**: <!-- e.g., us-east-1 -->
- **Engine**: <!-- Redis or Memcached -->
- **Engine Version**: <!-- e.g., 7.0 -->

## Additional Context

<!-- Add any other context about the problem here -->

## Possible Solution

<!-- Optional: Suggest a fix or reason for the bug -->
