# AWS ElastiCache Terraform Module

[![Release](https://img.shields.io/github/v/release/your-org/aws-elasticache-terraform-module?style=flat-square)](https://github.com/your-org/aws-elasticache-terraform-module/releases)
[![License](https://img.shields.io/github/license/your-org/aws-elasticache-terraform-module?style=flat-square)](LICENSE)
[![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.0-blue?style=flat-square)](https://www.terraform.io)
[![AWS Provider](https://img.shields.io/badge/aws-%3E%3D5.0-orange?style=flat-square)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=flat-square)](https://conventionalcommits.org)

A comprehensive, production-ready Terraform module for provisioning AWS ElastiCache clusters (Redis or Memcached) designed for integration with Internal Developer Platforms (IDPs).

## Features

- **Multi-Engine Support**: Deploy Redis or Memcached clusters with engine-specific configurations
- **IDP Integration**: Accepts VPC context (vpc_id, vpc_cidr_block, subnets_pvt) from your platform
- **Redis Advanced Features**: Cluster mode, replication, automatic failover, multi-AZ deployment
- **Security**: Encryption at rest and in transit, authentication tokens, configurable security groups
- **High Availability**: Multi-AZ deployment, automatic failover, read replicas
- **Backup & Recovery**: Automated snapshots, point-in-time recovery, final snapshots
- **Monitoring**: CloudWatch log exports, SNS notifications, custom parameter groups
- **Flexible Configuration**: Comprehensive variable exposure with sensible defaults

## Usage

### Basic Redis Cluster

```hcl
module "redis_cache" {
  source = "path/to/module"

  # IDP-provided variables
  vpc_id         = "vpc-12345678"
  vpc_cidr_block = "10.0.0.0/16"
  subnets_pvt    = ["subnet-abc123", "subnet-def456"]

  # Core configuration
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "redis"
  engine_version   = "7.0"
  node_type        = "cache.t3.micro"
  parameter_family = "redis7"

  tags = {
    Project = "MyApplication"
    Team    = "Platform"
  }
}
```

### Redis with High Availability

```hcl
module "redis_ha" {
  source = "path/to/module"

  # IDP-provided variables
  vpc_id         = "vpc-12345678"
  vpc_cidr_block = "10.0.0.0/16"
  subnets_pvt    = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]

  # Core configuration
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "redis"
  engine_version   = "7.0"
  node_type        = "cache.r6g.large"
  parameter_family = "redis7"

  # High availability
  replicas_per_node_group    = 2
  automatic_failover_enabled = true
  multi_az_enabled           = true

  # Security
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  auth_token                 = var.redis_auth_token

  # Backup
  snapshot_retention_limit = 7
  snapshot_window          = "03:00-05:00"
  maintenance_window       = "sun:05:00-sun:07:00"

  tags = {
    Project = "MyApplication"
    Team    = "Platform"
  }
}
```

### Redis Cluster Mode (Sharding)

```hcl
module "redis_cluster" {
  source = "path/to/module"

  # IDP-provided variables
  vpc_id         = "vpc-12345678"
  vpc_cidr_block = "10.0.0.0/16"
  subnets_pvt    = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]

  # Core configuration
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "redis"
  engine_version   = "7.0"
  node_type        = "cache.r6g.xlarge"
  parameter_family = "redis7"

  # Cluster mode configuration
  cluster_mode_enabled       = true
  num_node_groups            = 3
  replicas_per_node_group    = 2
  automatic_failover_enabled = true

  # Security
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  auth_token                 = var.redis_auth_token

  tags = {
    Project = "MyApplication"
    Team    = "Platform"
  }
}
```

### Memcached Cluster

```hcl
module "memcached_cache" {
  source = "path/to/module"

  # IDP-provided variables
  vpc_id         = "vpc-12345678"
  vpc_cidr_block = "10.0.0.0/16"
  subnets_pvt    = ["subnet-abc123", "subnet-def456"]

  # Core configuration
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "memcached"
  engine_version   = "1.6.17"
  node_type        = "cache.t3.micro"
  num_cache_nodes  = 3
  parameter_family = "memcached1.6"

  tags = {
    Project = "MyApplication"
    Team    = "Platform"
  }
}
```

## IDP Integration Requirements

This module is designed to work with Internal Developer Platforms that provide VPC context. The IDP must supply:

1. **vpc_id**: The VPC ID where ElastiCache resources will be deployed
2. **vpc_cidr_block**: The VPC CIDR block for default security group rules
3. **subnets_pvt**: List of private subnet IDs for the ElastiCache subnet group

The module handles all other resource creation including:
- ElastiCache subnet group
- Security group with configurable rules
- Optional parameter group
- ElastiCache cluster or replication group

### String Input Support

If your IDP requires all variables as strings, the module supports JSON string inputs for complex types with proper default values. See [STRING_INPUT_GUIDE.md](STRING_INPUT_GUIDE.md) and [examples/string-input/](examples/string-input/) for details.

```hcl
module "elasticache" {
  source = "path/to/module"

  # Standard string variables
  vpc_id         = "vpc-123"
  vpc_cidr_block = "10.0.0.0/16"
  
  # Complex types as JSON strings (with sensible defaults)
  subnets_pvt_json = "[\"subnet-abc\",\"subnet-def\"]"
  tags_json        = "{\"Project\":\"MyApp\"}"
  # Optional: parameters_json defaults to "[]"
  # Optional: snapshot_arns_json defaults to "null"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Resources

| Name | Type |
|------|------|
| aws_elasticache_replication_group.redis | resource |
| aws_elasticache_cluster.memcached | resource |
| aws_elasticache_subnet_group.this | resource |
| aws_security_group.this | resource |
| aws_security_group_rule.default_ingress | resource |
| aws_security_group_rule.custom_ingress | resource |
| aws_security_group_rule.egress | resource |
| aws_elasticache_parameter_group.this | resource |

## Inputs

### IDP-Provided Variables

| Name | Description | Type | Required |
|------|-------------|------|----------|
| vpc_id | VPC ID provided by IDP where ElastiCache resources will be deployed | `string` | yes |
| vpc_cidr_block | VPC CIDR block provided by IDP for default security group ingress rules | `string` | yes |
| subnets_pvt | List of private subnet IDs provided by IDP for ElastiCache subnet group | `list(string)` | yes |

### Core Configuration Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name_prefix | Prefix for resource names | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, prod) | `string` | n/a | yes |
| engine | Cache engine type (redis or memcached) | `string` | n/a | yes |
| engine_version | Version number of the cache engine | `string` | n/a | yes |
| node_type | Instance type for cache nodes (e.g., cache.t3.micro, cache.r6g.large) | `string` | n/a | yes |
| parameter_family | Family of the ElastiCache parameter group (e.g., redis7, memcached1.6) | `string` | n/a | yes |
| port | Port number on which the cache accepts connections | `number` | `null` (6379 for Redis, 11211 for Memcached) | no |
| description | Description for the ElastiCache cluster or replication group | `string` | `"Managed by Terraform"` | no |

### Redis-Specific Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_mode_enabled | Enable Redis cluster mode (sharding) | `bool` | `false` | no |
| num_node_groups | Number of node groups (shards) for Redis cluster mode | `number` | `1` | no |
| replicas_per_node_group | Number of replica nodes per node group (shard) | `number` | `0` | no |
| automatic_failover_enabled | Enable automatic failover for Redis replication groups | `bool` | `false` | no |
| multi_az_enabled | Enable multi-AZ deployment for Redis | `bool` | `false` | no |
| auth_token | Password used to access a password protected Redis server (requires transit_encryption_enabled = true) | `string` | `null` | no |
| transit_encryption_enabled | Enable encryption in transit (TLS) for Redis | `bool` | `false` | no |
| at_rest_encryption_enabled | Enable encryption at rest for Redis | `bool` | `false` | no |
| kms_key_id | ARN of the KMS key to use for encryption at rest | `string` | `null` | no |
| data_tiering_enabled | Enable data tiering for Redis (r6gd node types) | `bool` | `false` | no |
| log_delivery_configuration | List of log delivery configurations for Redis | `list(object)` | `[]` | no |

### Memcached-Specific Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| num_cache_nodes | Number of cache nodes for Memcached cluster | `number` | `1` | no |

### Backup and Maintenance Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| snapshot_retention_limit | Number of days to retain automatic snapshots (Redis only, 0 to disable) | `number` | `0` | no |
| snapshot_window | Daily time range during which automated backups are created (e.g., 05:00-09:00) | `string` | `null` | no |
| maintenance_window | Weekly time range for system maintenance (e.g., sun:05:00-sun:09:00) | `string` | `null` | no |
| final_snapshot_identifier | Name of the final snapshot created when the cluster is deleted | `string` | `null` | no |
| snapshot_arns | List of snapshot ARNs to restore from (Redis only) | `list(string)` | `null` | no |
| auto_minor_version_upgrade | Enable automatic minor version upgrades during maintenance window | `bool` | `true` | no |

### Network and Security Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| security_group_name | Name for the ElastiCache security group (auto-generated if not provided) | `string` | `null` | no |
| security_group_description | Description for the ElastiCache security group | `string` | `"Security group for ElastiCache cluster"` | no |
| ingress_cidr_blocks | List of CIDR blocks allowed to access ElastiCache (defaults to VPC CIDR) | `list(string)` | `null` | no |
| ingress_rules | List of custom ingress rules for the security group | `list(object)` | `[]` | no |
| additional_security_group_ids | List of additional security group IDs to attach to ElastiCache | `list(string)` | `[]` | no |

### Monitoring and Notification Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| notification_topic_arn | ARN of SNS topic for ElastiCache notifications | `string` | `null` | no |
| cloudwatch_log_exports | List of log types to export to CloudWatch (slow-log, engine-log) | `list(string)` | `[]` | no |
| preferred_availability_zones | List of preferred availability zones for cache node placement | `list(string)` | `null` | no |

### Parameter Group Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| create_parameter_group | Whether to create a custom parameter group | `bool` | `false` | no |
| parameters | List of parameter objects for custom parameter group configuration | `list(object)` | `[]` | no |

### Tagging Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| tags | Map of custom tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ElastiCache cluster identifier or replication group identifier |
| engine | Cache engine type (redis or memcached) |
| engine_version | Cache engine version |
| primary_endpoint_address | Primary endpoint address for the cache cluster |
| reader_endpoint_address | Reader endpoint address (Redis only, null for Memcached) |
| port | Port number on which the cache accepts connections |
| security_group_id | ID of the security group created for ElastiCache |
| subnet_group_name | Name of the subnet group created for ElastiCache |

## Examples

See the [examples](./examples) directory for complete working examples:

- [Redis Cluster Mode](./examples/redis-cluster) - Redis with cluster mode (sharding) enabled
- [Redis Replication Group](./examples/redis-replication) - Redis with high availability and encryption
- [Memcached Cluster](./examples/memcached) - Basic Memcached cluster deployment

## Security Considerations

1. **Encryption**: Enable `transit_encryption_enabled` and `at_rest_encryption_enabled` for production workloads
2. **Authentication**: Use `auth_token` with Redis when transit encryption is enabled
3. **Network Access**: The module creates a security group that defaults to allowing access from the VPC CIDR block
4. **KMS Keys**: Provide a `kms_key_id` when using encryption at rest for better key management
5. **Subnet Placement**: Ensure `subnets_pvt` are in private subnets without direct internet access

## Versioning

This module follows [Semantic Versioning](https://semver.org/). Releases are automated using [Semantic Release](https://semantic-release.gitbook.io/) based on [Conventional Commits](https://www.conventionalcommits.org/).

### Version Format

- **MAJOR.MINOR.PATCH** (e.g., 1.2.3)
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Latest Release

Check the [Releases](https://github.com/your-org/aws-elasticache-terraform-module/releases) page for the latest version and changelog.

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:

- Commit message conventions
- Pull request process
- Development workflow
- Code style guidelines

### Quick Start for Contributors

```bash
# Fork and clone the repository
git clone https://github.com/your-username/aws-elasticache-terraform-module.git

# Create a feature branch
git checkout -b feat/my-new-feature

# Make changes and commit using conventional commits
git commit -m "feat(redis): add new feature"

# Push and create a pull request
git push origin feat/my-new-feature
```

## Release Process

Releases are fully automated. See [RELEASE.md](RELEASE.md) for details on:

- How versioning works
- Commit message format
- Release workflow
- Creating pre-releases

## License

See [LICENSE](LICENSE) for full details.

## Authors

Managed by your platform team.
