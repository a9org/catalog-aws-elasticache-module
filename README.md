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

1. **vpc_id** (required): The VPC ID where ElastiCache resources will be deployed
2. **vpc_cidr_block** (required): The VPC CIDR block for default security group rules
3. **subnets_pvt** (required): List of private subnet IDs for the ElastiCache subnet group
   - Can be passed as native list or JSON string via `subnets_pvt_json`

The module handles all other resource creation including:
- ElastiCache subnet group
- Security group with configurable rules
- Optional parameter group
- ElastiCache cluster or replication group

### String-Only Input Support

If your IDP can **ONLY** pass strings (no booleans, lists, maps, or numbers), the module fully supports this limitation through dedicated string input variables with automatic type conversion:

```hcl
module "elasticache" {
  source = "path/to/module"

  # Required IDP variables (strings)
  vpc_id         = "vpc-123"
  vpc_cidr_block = "10.0.0.0/16"
  
  # Required core configuration (strings)
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "redis"
  engine_version   = "7.0"
  node_type        = "cache.r6g.large"
  parameter_family = "redis7"
  
  # Booleans as strings ("true", "false", "1", or "0")
  cluster_mode_enabled_str           = "true"
  automatic_failover_enabled_str     = "true"
  multi_az_enabled_str               = "true"
  transit_encryption_enabled_str     = "true"
  at_rest_encryption_enabled_str     = "true"
  data_tiering_enabled_str           = "false"
  auto_minor_version_upgrade_str     = "true"
  create_parameter_group_str         = "false"
  
  # Numbers as strings
  port_str                       = "6379"
  num_node_groups_str            = "3"
  replicas_per_node_group_str    = "2"
  num_cache_nodes_str            = "3"
  snapshot_retention_limit_str   = "7"
  
  # Complex types as JSON strings
  subnets_pvt_json                      = "[\"subnet-abc\",\"subnet-def\"]"
  tags_json                             = "{\"Project\":\"MyApp\",\"Team\":\"Platform\"}"
  ingress_cidr_blocks_json              = "[\"10.0.0.0/16\"]"
  additional_security_group_ids_json    = "[\"sg-123456\"]"
  parameters_json                       = "[{\"name\":\"maxmemory-policy\",\"value\":\"allkeys-lru\"}]"
  log_delivery_configuration_json       = "[{\"destination\":\"/aws/elasticache/redis\",\"destination_type\":\"cloudwatch-logs\",\"log_format\":\"json\",\"log_type\":\"slow-log\"}]"
}
```

**String Variable Features:**
- Boolean strings accept: `"true"`, `"false"`, `"1"`, `"0"` (case-insensitive)
- Number strings are automatically converted to numbers
- JSON strings are parsed into native Terraform types
- Empty string (`""`) defaults to the native variable value
- All string variables have validation to ensure correct format
- Every complex type has both native and JSON string variants

**Variable Naming Convention:**
- Native variables: `variable_name` (e.g., `cluster_mode_enabled`, `subnets_pvt`)
- String alternatives: `variable_name_str` or `variable_name_json` (e.g., `cluster_mode_enabled_str`, `subnets_pvt_json`)

See [IDP_VARIABLES_GUIDE.md](IDP_VARIABLES_GUIDE.md) for complete IDP integration details and [STRING_INPUT_GUIDE.md](STRING_INPUT_GUIDE.md) for string input examples.

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

### IDP-Provided Variables (REQUIRED)

| Name | Description | Type | String Alternative | Required |
|------|-------------|------|-------------------|----------|
| vpc_id | VPC ID where ElastiCache resources will be deployed | `string` | n/a | yes |
| vpc_cidr_block | VPC CIDR block for default security group ingress rules | `string` | n/a | yes |
| subnets_pvt | List of private subnet IDs for ElastiCache subnet group | `list(string)` | `subnets_pvt_json` | yes* |

*Either `subnets_pvt` or `subnets_pvt_json` must be provided.

### Core Configuration Variables (REQUIRED)

| Name | Description | Type | String Alternative | Required |
|------|-------------|------|-------------------|----------|
| name_prefix | Prefix for resource names | `string` | n/a | yes |
| environment | Environment name (e.g., 'dev', 'staging', 'prod') | `string` | n/a | yes |
| engine | Cache engine type - must be 'redis' or 'memcached' | `string` | n/a | yes |
| engine_version | Version number of the cache engine | `string` | n/a | yes |
| node_type | Instance type for cache nodes | `string` | n/a | yes |
| parameter_family | Family of the ElastiCache parameter group | `string` | n/a | yes |

### Optional Core Configuration

| Name | Description | Type | Default | String Alternative |
|------|-------------|------|---------|-------------------|
| port | Port number on which the cache accepts connections | `number` | `null` (auto: 6379/11211) | `port_str` |
| description | Description for the ElastiCache cluster | `string` | `"Managed by Terraform"` | n/a |

### Redis-Specific Variables

| Name | Description | Type | Default | String Alternative |
|------|-------------|------|---------|-------------------|
| cluster_mode_enabled | Enable Redis cluster mode (sharding) | `bool` | `false` | `cluster_mode_enabled_str` |
| num_node_groups | Number of node groups (shards) for cluster mode | `number` | `1` | `num_node_groups_str` |
| replicas_per_node_group | Number of replica nodes per node group/shard | `number` | `0` | `replicas_per_node_group_str` |
| automatic_failover_enabled | Enable automatic failover for replication groups | `bool` | `false` | `automatic_failover_enabled_str` |
| multi_az_enabled | Enable multi-AZ deployment | `bool` | `false` | `multi_az_enabled_str` |
| auth_token | Password for Redis AUTH (requires transit encryption) | `string` | `null` | n/a |
| transit_encryption_enabled | Enable encryption in transit (TLS) | `bool` | `false` | `transit_encryption_enabled_str` |
| at_rest_encryption_enabled | Enable encryption at rest | `bool` | `false` | `at_rest_encryption_enabled_str` |
| kms_key_id | ARN of KMS key for encryption at rest | `string` | `null` | n/a |
| data_tiering_enabled | Enable data tiering (requires r6gd node types) | `bool` | `false` | `data_tiering_enabled_str` |
| log_delivery_configuration | List of log delivery configurations | `list(object)` | `[]` | `log_delivery_configuration_json` |

### Memcached-Specific Variables

| Name | Description | Type | Default | String Alternative |
|------|-------------|------|---------|-------------------|
| num_cache_nodes | Number of cache nodes for Memcached cluster | `number` | `1` | `num_cache_nodes_str` |

### Backup and Maintenance Variables

| Name | Description | Type | Default | String Alternative |
|------|-------------|------|---------|-------------------|
| snapshot_retention_limit | Days to retain automatic snapshots (0 = disabled) | `number` | `0` | `snapshot_retention_limit_str` |
| snapshot_window | Daily time range for automated backups | `string` | `null` | n/a |
| maintenance_window | Weekly time range for system maintenance | `string` | `null` | n/a |
| final_snapshot_identifier | Name of final snapshot when cluster is deleted | `string` | `null` | n/a |
| snapshot_arns | List of snapshot ARNs to restore from (Redis only) | `list(string)` | `null` | `snapshot_arns_json` |
| auto_minor_version_upgrade | Enable automatic minor version upgrades | `bool` | `true` | `auto_minor_version_upgrade_str` |

### Network and Security Variables

| Name | Description | Type | Default | String Alternative |
|------|-------------|------|---------|-------------------|
| security_group_name | Name for the ElastiCache security group | `string` | `null` (auto-generated) | n/a |
| security_group_description | Description for the security group | `string` | `"Security group for ElastiCache cluster"` | n/a |
| ingress_cidr_blocks | List of CIDR blocks allowed to access ElastiCache | `list(string)` | `null` (defaults to VPC CIDR) | `ingress_cidr_blocks_json` |
| ingress_rules | List of custom ingress rules | `list(object)` | `[]` | `ingress_rules_json` |
| additional_security_group_ids | Additional security group IDs to attach | `list(string)` | `[]` | `additional_security_group_ids_json` |

### Monitoring and Notification Variables

| Name | Description | Type | Default | String Alternative |
|------|-------------|------|---------|-------------------|
| notification_topic_arn | ARN of SNS topic for ElastiCache notifications | `string` | `null` | n/a |
| cloudwatch_log_exports | Log types to export to CloudWatch | `list(string)` | `[]` | `cloudwatch_log_exports_json` |
| preferred_availability_zones | Preferred AZs for cache node placement | `list(string)` | `null` | `preferred_availability_zones_json` |

### Tagging Variables

| Name | Description | Type | Default | String Alternative |
|------|-------------|------|---------|-------------------|
| tags | Map of custom tags to apply to all resources | `map(string)` | `{}` | `tags_json` |

### Parameter Group Variables

| Name | Description | Type | Default | String Alternative |
|------|-------------|------|---------|-------------------|
| create_parameter_group | Whether to create a custom parameter group | `bool` | `false` | `create_parameter_group_str` |
| parameters | List of parameter objects for configuration | `list(object)` | `[]` | `parameters_json` |

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
