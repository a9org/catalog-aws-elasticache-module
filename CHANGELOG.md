# Changelog

All notable changes to this project will be documented in this file.

## 1.0.0 (2025-11-15)


### Features

* add Memcached cluster resource implementation ([3d38663](https://github.com/a9org/catalog-aws-elasticache-module/commit/3d386637305ca86c6e524a0473870413bb191b3b))
* add module outputs for cluster identification, endpoints, and network resources ([9d657c9](https://github.com/a9org/catalog-aws-elasticache-module/commit/9d657c90942f06793bc209dafcb5798cfcfb63de))
* implement AWS ElastiCache Terraform module with Redis support ([ef2f7c6](https://github.com/a9org/catalog-aws-elasticache-module/commit/ef2f7c6e4efcedee507a0600284f4d32bf6eaa8d))


### Documentation

* add contributing guidelines and CI/CD documentation ([4aa43fb](https://github.com/a9org/catalog-aws-elasticache-module/commit/4aa43fbdb9882aa890737e9757b0604e5ee63231))
* add examples ([06fdb65](https://github.com/a9org/catalog-aws-elasticache-module/commit/06fdb65798f7f0b98eaecc64f4f8457c4853b754))
* improve README with enhanced examples and clearer documentation ([e130e94](https://github.com/a9org/catalog-aws-elasticache-module/commit/e130e9461736879ea6ccb4a820250bd795221214))
* translate SETUP.md to English ([e08f44d](https://github.com/a9org/catalog-aws-elasticache-module/commit/e08f44d2f85add0ef1ebfb401fdcad7239e511da))

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial module implementation for AWS ElastiCache
- Support for Redis and Memcached engines
- IDP integration with VPC context variables
- Redis cluster mode (sharding) support
- Redis replication with automatic failover
- Multi-AZ deployment support
- Encryption at rest and in transit
- Custom parameter groups
- Automated backup and snapshot management
- CloudWatch log delivery configuration
- Comprehensive documentation and examples
- GitHub Actions workflows for CI/CD
- Semantic versioning and automated releases

[Unreleased]: https://github.com/your-org/aws-elasticache-terraform-module/compare/v0.1.0...HEAD
