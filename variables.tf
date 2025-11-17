# ============================================
# Core Configuration (REQUIRED)
# ============================================
# Resources read: name_prefix, environment, engine, engine_version, node_type, parameter_family

variable "name_prefix" {
  description = "Prefix for resource names. Example: 'myapp'"
  type        = string
}

variable "engine" {
  description = "Cache engine type. Must be 'redis' or 'memcached'"
  type        = string

  validation {
    condition     = contains(["redis", "memcached"], var.engine)
    error_message = "Engine must be either 'redis' or 'memcached'."
  }
}

variable "engine_version" {
  description = "Version number of the cache engine. Example: '7.0' for Redis, '1.6.17' for Memcached"
  type        = string
}

variable "node_type" {
  description = "Instance type for cache nodes. Example: 'cache.t3.micro', 'cache.r6g.large'"
  type        = string
}

variable "parameter_family" {
  description = "Family of the ElastiCache parameter group. Example: 'redis7', 'memcached1.6'"
  type        = string
}


# ============================================
# Optional Core Configuration
# ============================================
# Resources read: port_final, description

variable "port" {
  description = "Port number on which the cache accepts connections. Defaults: 6379 for Redis, 11211 for Memcached"
  type        = number
  default     = null
}

variable "port_str" {
  description = "Port number as string if your platform cannot pass numbers. Example: '6379'. Leave empty to use port"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description for the ElastiCache cluster or replication group"
  type        = string
  default     = "Managed by A9 Catalog"
}


# ============================================
# Redis-Specific Configuration
# ============================================
# Resources read: cluster_mode_enabled_final, num_node_groups_final, replicas_per_node_group_final,
#                 automatic_failover_enabled_final, multi_az_enabled_final, auth_token,
#                 transit_encryption_enabled_final, at_rest_encryption_enabled_final,
#                 kms_key_id, data_tiering_enabled_final, log_delivery_configuration_final

variable "cluster_mode_enabled" {
  description = "Enable Redis cluster mode for horizontal scaling through sharding"
  type        = bool
  default     = false
}

variable "cluster_mode_enabled_str" {
  description = "Enable cluster mode as string. Use 'true', 'false', '1', or '0'. Leave empty to use cluster_mode_enabled"
  type        = string
  default     = ""

  validation {
    condition     = var.cluster_mode_enabled_str == "" || contains(["true", "false", "1", "0"], lower(var.cluster_mode_enabled_str))
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "num_node_groups" {
  description = "Number of node groups (shards) for Redis cluster mode. Minimum: 1"
  type        = number
  default     = 1

  validation {
    condition     = var.num_node_groups >= 1
    error_message = "Number of node groups must be at least 1."
  }
}

variable "num_node_groups_str" {
  description = "Number of node groups as string. Example: '3'. Leave empty to use num_node_groups"
  type        = string
  default     = ""
}

variable "replicas_per_node_group" {
  description = "Number of replica nodes per node group/shard. Range: 0-5"
  type        = number
  default     = 0

  validation {
    condition     = var.replicas_per_node_group >= 0 && var.replicas_per_node_group <= 5
    error_message = "Replicas per node group must be between 0 and 5."
  }
}

variable "replicas_per_node_group_str" {
  description = "Replicas per node group as string. Example: '2'. Leave empty to use replicas_per_node_group"
  type        = string
  default     = ""
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover for Redis replication groups. Requires at least 1 replica"
  type        = bool
  default     = false
}

variable "automatic_failover_enabled_str" {
  description = "Enable automatic failover as string. Use 'true', 'false', '1', or '0'. Leave empty to use automatic_failover_enabled"
  type        = string
  default     = ""

  validation {
    condition     = var.automatic_failover_enabled_str == "" || contains(["true", "false", "1", "0"], lower(var.automatic_failover_enabled_str))
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "multi_az_enabled" {
  description = "Enable multi-AZ deployment for Redis. Distributes nodes across multiple availability zones"
  type        = bool
  default     = false
}

variable "multi_az_enabled_str" {
  description = "Enable multi-AZ as string. Use 'true', 'false', '1', or '0'. Leave empty to use multi_az_enabled"
  type        = string
  default     = ""

  validation {
    condition     = var.multi_az_enabled_str == "" || contains(["true", "false", "1", "0"], lower(var.multi_az_enabled_str))
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "auth_token" {
  description = "Password for Redis AUTH command. Requires transit_encryption_enabled. Minimum 16 characters"
  type        = string
  default     = null
  sensitive   = true
}

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit (TLS) for Redis connections"
  type        = bool
  default     = false
}

variable "transit_encryption_enabled_str" {
  description = "Enable transit encryption as string. Use 'true', 'false', '1', or '0'. Leave empty to use transit_encryption_enabled"
  type        = string
  default     = ""

  validation {
    condition     = var.transit_encryption_enabled_str == "" || contains(["true", "false", "1", "0"], lower(var.transit_encryption_enabled_str))
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest for Redis data"
  type        = bool
  default     = false
}

variable "at_rest_encryption_enabled_str" {
  description = "Enable at-rest encryption as string. Use 'true', 'false', '1', or '0'. Leave empty to use at_rest_encryption_enabled"
  type        = string
  default     = ""

  validation {
    condition     = var.at_rest_encryption_enabled_str == "" || contains(["true", "false", "1", "0"], lower(var.at_rest_encryption_enabled_str))
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "kms_key_id" {
  description = "ARN of the KMS key for encryption at rest. Example: 'arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012'"
  type        = string
  default     = null
}

variable "data_tiering_enabled" {
  description = "Enable data tiering for Redis. Requires r6gd node types"
  type        = bool
  default     = false
}

variable "data_tiering_enabled_str" {
  description = "Enable data tiering as string. Use 'true', 'false', '1', or '0'. Leave empty to use data_tiering_enabled"
  type        = string
  default     = ""

  validation {
    condition     = var.data_tiering_enabled_str == "" || contains(["true", "false", "1", "0"], lower(var.data_tiering_enabled_str))
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "log_delivery_configuration" {
  description = "List of log delivery configurations for Redis. Each object requires: destination, destination_type, log_format, log_type"
  type = list(object({
    destination      = string
    destination_type = string
    log_format       = string
    log_type         = string
  }))
  default = []
}

variable "log_delivery_configuration_json" {
  description = "JSON string of log delivery configuration. Example: '[{\"destination\":\"/aws/elasticache/redis\",\"destination_type\":\"cloudwatch-logs\",\"log_format\":\"json\",\"log_type\":\"slow-log\"}]'. Leave empty to use log_delivery_configuration"
  type        = string
  default     = ""
}


# ============================================
# Memcached-Specific Configuration
# ============================================
# Resources read: num_cache_nodes_final

variable "num_cache_nodes" {
  description = "Number of cache nodes for Memcached cluster. Range: 1-40"
  type        = number
  default     = 1

  validation {
    condition     = var.num_cache_nodes >= 1 && var.num_cache_nodes <= 40
    error_message = "Number of cache nodes must be between 1 and 40."
  }
}

variable "num_cache_nodes_str" {
  description = "Number of cache nodes as string. Example: '3'. Leave empty to use num_cache_nodes"
  type        = string
  default     = ""
}


# ============================================
# Backup and Maintenance Configuration
# ============================================
# Resources read: snapshot_retention_limit_final, snapshot_window, maintenance_window,
#                 final_snapshot_identifier, snapshot_arns_final, auto_minor_version_upgrade_final

variable "snapshot_retention_limit" {
  description = "Number of days to retain automatic snapshots for Redis. Range: 0-35. Set 0 to disable"
  type        = number
  default     = 0

  validation {
    condition     = var.snapshot_retention_limit >= 0 && var.snapshot_retention_limit <= 35
    error_message = "Snapshot retention limit must be between 0 and 35 days."
  }
}

variable "snapshot_retention_limit_str" {
  description = "Snapshot retention limit as string. Example: '7'. Leave empty to use snapshot_retention_limit"
  type        = string
  default     = ""
}

variable "snapshot_window" {
  description = "Daily time range for automated backups. Example: '05:00-09:00'"
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "Weekly time range for system maintenance. Example: 'sun:05:00-sun:09:00'"
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "Name of the final snapshot created when the cluster is deleted"
  type        = string
  default     = null
}

variable "snapshot_arns" {
  description = "List of snapshot ARNs to restore from for Redis. Example: ['arn:aws:elasticache:us-east-1:123456789012:snapshot:my-snapshot']"
  type        = list(string)
  default     = null
}

variable "snapshot_arns_json" {
  description = "JSON string of snapshot ARNs. Example: '[\"arn:aws:elasticache:us-east-1:123456789012:snapshot:my-snapshot\"]'. Leave empty to use snapshot_arns"
  type        = string
  default     = ""
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades during maintenance window"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade_str" {
  description = "Enable auto minor version upgrade as string. Use 'true', 'false', '1', or '0'. Leave empty to use auto_minor_version_upgrade"
  type        = string
  default     = ""

  validation {
    condition     = var.auto_minor_version_upgrade_str == "" || contains(["true", "false", "1", "0"], lower(var.auto_minor_version_upgrade_str))
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}


# ============================================
# Network and Security Configuration
# ============================================
# Resources read: security_group_name, security_group_description, ingress_cidr_blocks_final,
#                 ingress_rules_final, additional_security_group_ids_final

variable "security_group_name" {
  description = "Name for the ElastiCache security group. Auto-generated if not provided"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "Description for the ElastiCache security group"
  type        = string
  default     = "Security group for ElastiCache cluster"
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks allowed to access ElastiCache. Defaults to VPC CIDR if not provided. Example: ['10.0.0.0/16', '172.16.0.0/12']"
  type        = list(string)
  default     = null
}

variable "ingress_cidr_blocks_json" {
  description = "JSON string of ingress CIDR blocks. Example: '[\"10.0.0.0/16\",\"172.16.0.0/12\"]'. Leave empty to use ingress_cidr_blocks"
  type        = string
  default     = ""
}

variable "ingress_rules" {
  description = "List of custom ingress rules for the security group. Each object requires: from_port, to_port, protocol, cidr_blocks, description"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "ingress_rules_json" {
  description = "JSON string of custom ingress rules. Example: '[{\"from_port\":6379,\"to_port\":6379,\"protocol\":\"tcp\",\"cidr_blocks\":[\"10.0.0.0/16\"],\"description\":\"Redis access\"}]'. Leave empty to use ingress_rules"
  type        = string
  default     = ""
}

variable "additional_security_group_ids" {
  description = "List of additional security group IDs to attach to ElastiCache. Example: ['sg-123456', 'sg-789012']"
  type        = list(string)
  default     = []
}

variable "additional_security_group_ids_json" {
  description = "JSON string of additional security group IDs. Example: '[\"sg-123456\",\"sg-789012\"]'. Leave empty to use additional_security_group_ids"
  type        = string
  default     = ""
}


# ============================================
# Monitoring and Notification Configuration
# ============================================
# Resources read: notification_topic_arn, cloudwatch_log_exports_final, preferred_availability_zones_final

variable "notification_topic_arn" {
  description = "ARN of SNS topic for ElastiCache notifications. Example: 'arn:aws:sns:us-east-1:123456789012:my-topic'"
  type        = string
  default     = null
}

variable "cloudwatch_log_exports" {
  description = "List of log types to export to CloudWatch. Valid values: 'slow-log', 'engine-log'. Example: ['slow-log', 'engine-log']"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for log_type in var.cloudwatch_log_exports :
      contains(["slow-log", "engine-log"], log_type)
    ])
    error_message = "CloudWatch log exports must be either 'slow-log' or 'engine-log'."
  }
}

variable "cloudwatch_log_exports_json" {
  description = "JSON string of CloudWatch log exports. Example: '[\"slow-log\",\"engine-log\"]'. Leave empty to use cloudwatch_log_exports"
  type        = string
  default     = ""
}

variable "preferred_availability_zones" {
  description = "List of preferred availability zones for cache node placement. Example: ['us-east-1a', 'us-east-1b', 'us-east-1c']"
  type        = list(string)
  default     = null
}

variable "preferred_availability_zones_json" {
  description = "JSON string of preferred availability zones. Example: '[\"us-east-1a\",\"us-east-1b\",\"us-east-1c\"]'. Leave empty to use preferred_availability_zones"
  type        = string
  default     = ""
}


# ============================================
# Tagging Configuration
# ============================================
# Resources read: tags_final (merged with default tags)

variable "tags" {
  description = "Map of custom tags to apply to all resources. Example: {Project = 'MyApp', Team = 'Platform'}"
  type        = map(string)
  default     = {}
}

variable "tags_json" {
  description = "JSON string of tags. Example: '{\"Project\":\"MyApp\",\"Team\":\"Platform\",\"Environment\":\"prod\"}'. Leave empty to use tags"
  type        = string
  default     = ""
}


# ============================================
# Parameter Group Configuration
# ============================================
# Resources read: create_parameter_group_final, parameters_final

variable "create_parameter_group" {
  description = "Whether to create a custom parameter group for fine-tuning cache behavior"
  type        = bool
  default     = false
}

variable "create_parameter_group_str" {
  description = "Create parameter group as string. Use 'true', 'false', '1', or '0'. Leave empty to use create_parameter_group"
  type        = string
  default     = ""

  validation {
    condition     = var.create_parameter_group_str == "" || contains(["true", "false", "1", "0"], lower(var.create_parameter_group_str))
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "parameters" {
  description = "List of parameter objects for custom parameter group. Each object requires: name, value. Example: [{name = 'maxmemory-policy', value = 'allkeys-lru'}]"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "parameters_json" {
  description = "JSON string of parameters. Example: '[{\"name\":\"maxmemory-policy\",\"value\":\"allkeys-lru\"},{\"name\":\"timeout\",\"value\":\"300\"}]'. Leave empty to use parameters"
  type        = string
  default     = ""
}

# ============================================
# IDP-Provided Variables (REQUIRED)
# ============================================
# Resources read: vpc_id, vpc_cidr_block, subnets_pvt_final

variable "vpc_id" {
  description = "VPC ID where ElastiCache resources will be deployed"
  type        = string
  default     = null
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block for default security group ingress rules. Example: '10.0.0.0/16'"
  type        = string
  default     = null
}

variable "subnets_pvt" {
  description = "List of private subnet IDs for ElastiCache subnet group. Example: ['subnet-abc123', 'subnet-def456']"
  type        = list(string)
  default     = []
}

variable "subnets_pvt_json" {
  description = "JSON string of subnet IDs if your platform cannot pass lists. Example: '[\"subnet-abc123\",\"subnet-def456\"]'. Leave empty to use subnets_pvt"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name. Example: 'dev', 'staging', 'prod'"
  type        = string
  default     = null
}
