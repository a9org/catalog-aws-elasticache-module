# AWS ElastiCache Terraform Module

A comprehensive Terraform module for provisioning AWS ElastiCache clusters (Redis or Memcached) with full configuration flexibility and IDP integration support.

## Features

- **Multi-Engine Support**: Deploy Redis or Memcached clusters
- **Redis Cluster Mode**: Support for Redis cluster mode with sharding
- **High Availability**: Multi-AZ deployment with automatic failover
- **Security**: Encryption at rest and in transit, VPC isolation, custom security groups
- **Backup & Recovery**: Automated snapshots with configurable retention
- **Monitoring**: CloudWatch log delivery and SNS notifications
- **Flexible Configuration**: Expose all ElastiCache options through variables
- **IDP Integration**: Seamless integration with VPC context from IDP

## Usage

### Basic Redis Cluster

```hcl
module "redis" {
  source = "./path-to-module"

  # IDP-provided variables
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  subnets_pvt    = var.subnets_pvt

  # Core configuration
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "redis"
  engine_version   = "7.0"
  node_type        = "cache.t3.micro"
  parameter_family = "redis7"
}
```

### Redis with High Availability

```hcl
module "redis_ha" {
  source = "./path-to-module"

  # IDP-provided variables
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  subnets_pvt    = var.subnets_pvt

  # Core configuration
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "redis"
  engine_version   = "7.0"
  node_type        = "cache.r6g.large"
  parameter_family = "redis7"

  # High availability
  automatic_failover_enabled = true
  multi_az_enabled          = true
  replicas_per_node_group   = 2

  # Security
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  auth_token                = var.redis_auth_token

  # Backup
  snapshot_retention_limit = 7
  snapshot_window         = "03:00-05:00"
  maintenance_window      = "sun:05:00-sun:07:00"
}
```

### Redis Cluster Mode

```hcl
module "redis_cluster" {
  source = "./path-to-module"

  # IDP-provided variables
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  subnets_pvt    = var.subnets_pvt

  # Core configuration
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "redis"
  engine_version   = "7.0"
  node_type        = "cache.r6g.large"
  parameter_family = "redis7"

  # Cluster mode
  cluster_mode_enabled    = true
  num_node_groups         = 3
  replicas_per_node_group = 2

  # High availability
  automatic_failover_enabled = true
  multi_az_enabled          = true
}
```

### Memcached Cluster

```hcl
module "memcached" {
  source = "./path-to-module"

  # IDP-provided variables
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  subnets_pvt    = var.subnets_pvt

  # Core configuration
  name_prefix      = "myapp"
  environment      = "prod"
  engine           = "memcached"
  engine_version   = "1.6.17"
  node_type        = "cache.t3.micro"
  parameter_family = "memcached1.6"
  num_cache_nodes  = 3
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

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
| vpc_id | VPC ID provided by IDP | `string` | yes |
| vpc_cidr_block | VPC CIDR block provided by IDP | `string` | yes |
| subnets_pvt | List of private subnet IDs provided by IDP | `list(string)` | yes |

### Core Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name_prefix | Prefix for resource names | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, prod) | `string` | n/a | yes |
| engine | Cache engine type (redis or memcached) | `string` | n/a | yes |
| engine_version | Version number of the cache engine | `string` | n/a | yes |
| node_type | Instance type for cache nodes | `string` | n/a | yes |
| parameter_family | Family of the ElastiCache parameter group | `string` | n/a | yes |
| port | Port number on which the cache accepts connections | `number` | `null` (6379 for Redis, 11211 for Memcached) | no |
| description | Description for the ElastiCache cluster | `string` | `"Managed by Terraform"` | no |

### Redis-Specific Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_mode_enabled | Enable Redis cluster mode (sharding) | `bool` | `false` | no |
| num_node_groups | Number of node groups (shards) for cluster mode | `number` | `1` | no |
| replicas_per_node_group | Number of replica nodes per node group | `number` | `0` | no |
| automatic_failover_enabled | Enable automatic failover | `bool` | `false` | no |
| multi_az_enabled | Enable multi-AZ deployment | `bool` | `false` | no |
| auth_token | Password for Redis AUTH | `string` | `null` | no |
| transit_encryption_enabled | Enable encryption in transit (TLS) | `bool` | `false` | no |
| at_rest_encryption_enabled | Enable encryption at rest | `bool` | `false` | no |
| kms_key_id | ARN of KMS key for encryption | `string` | `null` | no |
| data_tiering_enabled | Enable data tiering (r6gd nodes) | `bool` | `false` | no |
| log_delivery_configuration | List of log delivery configurations | `list(object)` | `[]` | no |

### Memcached-Specific Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| num_cache_nodes | Number of cache nodes for Memcached | `number` | `1` | no |

### Backup and Maintenance

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| snapshot_retention_limit | Days to retain automatic snapshots (0 to disable) | `number` | `0` | no |
| snapshot_window | Daily time range for automated backups | `string` | `null` | no |
| maintenance_window | Weekly time range for system maintenance | `string` | `null` | no |
| final_snapshot_identifier | Name of final snapshot on deletion | `string` | `null` | no |
| snapshot_arns | List of snapshot ARNs to restore from | `list(string)` | `null` | no |
| auto_minor_version_upgrade | Enable automatic minor version upgrades | `bool` | `true` | no |

### Network and Security

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| security_group_name | Custom security group name | `string` | `null` (auto-generated) | no |
| security_group_description | Security group description | `string` | `"Security group for ElastiCache cluster"` | no |
| ingress_cidr_blocks | CIDR blocks allowed to access ElastiCache | `list(string)` | `null` (defaults to VPC CIDR) | no |
| ingress_rules | List of custom ingress rules | `list(object)` | `[]` | no |
| additional_security_group_ids | Additional security groups to attach | `list(string)` | `[]` | no |

### Monitoring and Notifications

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| notification_topic_arn | ARN of SNS topic for notifications | `string` | `null` | no |
| cloudwatch_log_exports | Log types to export to CloudWatch | `list(string)` | `[]` | no |
| preferred_availability_zones | Preferred AZs for node placement | `list(string)` | `null` | no |

### Parameter Group

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| create_parameter_group | Whether to create a custom parameter group | `bool` | `false` | no |
| parameters | List of parameter objects for custom configuration | `list(object)` | `[]` | no |

### Tagging

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| tags | Map of custom tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ElastiCache cluster identifier |
| primary_endpoint_address | Primary endpoint address |
| reader_endpoint_address | Reader endpoint address (Redis only) |
| port | Port number |
| security_group_id | Security group ID |
| subnet_group_name | Subnet group name |
| engine | Cache engine type |
| engine_version | Cache engine version |

## Examples

See the `examples/` directory for complete working examples:

- `examples/redis-cluster/` - Redis cluster mode with sharding
- `examples/redis-replication/` - Redis with HA and replication
- `examples/memcached/` - Memcached cluster

## License

See LICENSE file for details.
