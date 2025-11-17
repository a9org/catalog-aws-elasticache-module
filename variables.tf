# ============================================
# IDP-Provided Variables (REQUIRED)
# ============================================

variable "vpc_id" {
  description = "VPC ID where ElastiCache resources will be deployed"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block for default security group ingress rules. Example: '10.0.0.0/16'"
  type        = string
}

variable "subnets_pvt" {
  description = "Private subnet IDs for ElastiCache as JSON string. Example: '[\"subnet-abc123\",\"subnet-def456\"]'"
  type        = string
}

variable "environment" {
  description = "Environment name. Example: 'dev', 'staging', 'prod'"
  type        = string
}


# ============================================
# Core Configuration (REQUIRED)
# ============================================

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

variable "port" {
  description = "Port number as string. Example: '6379' for Redis, '11211' for Memcached. Leave empty for defaults"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description for the ElastiCache cluster or replication group"
  type        = string
  default     = "Managed by Terraform"
}


# ============================================
# Redis-Specific Configuration
# ============================================

variable "cluster_mode_enabled" {
  description = "Enable Redis cluster mode for horizontal scaling. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = "false"

  validation {
    condition     = contains(["true", "false", "1", "0", ""], var.cluster_mode_enabled)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "num_node_groups" {
  description = "Number of node groups (shards) for Redis cluster mode as string. Example: '3'. Minimum: 1"
  type        = string
  default     = "1"
}

variable "replicas_per_node_group" {
  description = "Number of replica nodes per node group as string. Example: '2'. Range: 0-5"
  type        = string
  default     = "0"
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover for Redis. Use 'true', 'false', '1', or '0'. Requires at least 1 replica"
  type        = string
  default     = "false"

  validation {
    condition     = contains(["true", "false", "1", "0", ""], var.automatic_failover_enabled)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "multi_az_enabled" {
  description = "Enable multi-AZ deployment for Redis. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = "false"

  validation {
    condition     = contains(["true", "false", "1", "0", ""], var.multi_az_enabled)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "auth_token" {
  description = "Password for Redis AUTH command. Requires transit_encryption_enabled. Minimum 16 characters"
  type        = string
  default     = ""
  sensitive   = true
}

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit (TLS) for Redis. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = "false"

  validation {
    condition     = contains(["true", "false", "1", "0", ""], var.transit_encryption_enabled)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest for Redis. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = "false"

  validation {
    condition     = contains(["true", "false", "1", "0", ""], var.at_rest_encryption_enabled)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "kms_key_id" {
  description = "ARN of the KMS key for encryption at rest. Example: 'arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012'"
  type        = string
  default     = ""
}

variable "data_tiering_enabled" {
  description = "Enable data tiering for Redis. Use 'true', 'false', '1', or '0'. Requires r6gd node types"
  type        = string
  default     = "false"

  validation {
    condition     = contains(["true", "false", "1", "0", ""], var.data_tiering_enabled)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "log_delivery_configuration" {
  description = "Log delivery configuration as JSON string. Example: '[{\"destination\":\"/aws/elasticache/redis\",\"destination_type\":\"cloudwatch-logs\",\"log_format\":\"json\",\"log_type\":\"slow-log\"}]'"
  type        = string
  default     = ""
}


# ============================================
# Memcached-Specific Configuration
# ============================================

variable "num_cache_nodes" {
  description = "Number of cache nodes for Memcached as string. Example: '3'. Range: 1-40"
  type        = string
  default     = "1"
}


# ============================================
# Backup and Maintenance Configuration
# ============================================

variable "snapshot_retention_limit" {
  description = "Days to retain automatic snapshots as string. Example: '7'. Range: 0-35. Set '0' to disable"
  type        = string
  default     = "0"
}

variable "snapshot_window" {
  description = "Daily time range for automated backups. Example: '05:00-09:00'"
  type        = string
  default     = ""
}

variable "maintenance_window" {
  description = "Weekly time range for system maintenance. Example: 'sun:05:00-sun:09:00'"
  type        = string
  default     = ""
}

variable "final_snapshot_identifier" {
  description = "Name of the final snapshot created when the cluster is deleted"
  type        = string
  default     = ""
}

variable "snapshot_arns" {
  description = "Snapshot ARNs to restore from as JSON string. Example: '[\"arn:aws:elasticache:us-east-1:123456789012:snapshot:my-snapshot\"]'"
  type        = string
  default     = ""
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = "true"

  validation {
    condition     = contains(["true", "false", "1", "0", ""], var.auto_minor_version_upgrade)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}


# ============================================
# Network and Security Configuration
# ============================================

variable "security_group_name" {
  description = "Name for the ElastiCache security group. Auto-generated if not provided"
  type        = string
  default     = ""
}

variable "security_group_description" {
  description = "Description for the ElastiCache security group"
  type        = string
  default     = "Security group for ElastiCache cluster"
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access ElastiCache as JSON string. Example: '[\"10.0.0.0/16\",\"172.16.0.0/12\"]'. Defaults to VPC CIDR if empty"
  type        = string
  default     = ""
}

variable "ingress_rules" {
  description = "Custom ingress rules as JSON string. Example: '[{\"from_port\":6379,\"to_port\":6379,\"protocol\":\"tcp\",\"cidr_blocks\":[\"10.0.0.0/16\"],\"description\":\"Redis access\"}]'"
  type        = string
  default     = ""
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs as JSON string. Example: '[\"sg-123456\",\"sg-789012\"]'"
  type        = string
  default     = ""
}


# ============================================
# Monitoring and Notification Configuration
# ============================================

variable "notification_topic_arn" {
  description = "ARN of SNS topic for ElastiCache notifications. Example: 'arn:aws:sns:us-east-1:123456789012:my-topic'"
  type        = string
  default     = ""
}

variable "cloudwatch_log_exports" {
  description = "Log types to export to CloudWatch as JSON string. Example: '[\"slow-log\",\"engine-log\"]'"
  type        = string
  default     = ""
}

variable "preferred_availability_zones" {
  description = "Preferred availability zones as JSON string. Example: '[\"us-east-1a\",\"us-east-1b\",\"us-east-1c\"]'"
  type        = string
  default     = ""
}


# ============================================
# Tagging Configuration
# ============================================

variable "tags" {
  description = "Custom tags as JSON string. Example: '{\"Project\":\"MyApp\",\"Team\":\"Platform\",\"Environment\":\"prod\"}'"
  type        = string
  default     = ""
}


# ============================================
# Parameter Group Configuration
# ============================================

variable "create_parameter_group" {
  description = "Create a custom parameter group. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = "false"

  validation {
    condition     = contains(["true", "false", "1", "0", ""], var.create_parameter_group)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "parameters" {
  description = "Parameter objects as JSON string. Example: '[{\"name\":\"maxmemory-policy\",\"value\":\"allkeys-lru\"},{\"name\":\"timeout\",\"value\":\"300\"}]'"
  type        = string
  default     = ""
}
