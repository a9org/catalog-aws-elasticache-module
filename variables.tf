# ============================================
# IDP-Provided Variables
# ============================================

variable "vpc_id" {
  description = "VPC ID provided by IDP where ElastiCache resources will be deployed"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block provided by IDP for default security group ingress rules"
  type        = string
}

variable "subnets_pvt" {
  description = "List of private subnet IDs provided by IDP for ElastiCache subnet group"
  type        = list(string)

  validation {
    condition     = length(var.subnets_pvt) > 0
    error_message = "At least one private subnet must be provided."
  }
}


# ============================================
# Core ElastiCache Configuration
# ============================================

variable "engine" {
  description = "Cache engine type (redis or memcached)"
  type        = string

  validation {
    condition     = contains(["redis", "memcached"], var.engine)
    error_message = "Engine must be either 'redis' or 'memcached'."
  }
}

variable "engine_version" {
  description = "Version number of the cache engine"
  type        = string
}

variable "node_type" {
  description = "Instance type for cache nodes (e.g., cache.t3.micro, cache.r6g.large)"
  type        = string
}

variable "port" {
  description = "Port number on which the cache accepts connections"
  type        = number
  default     = null
}

variable "parameter_family" {
  description = "Family of the ElastiCache parameter group (e.g., redis7, memcached1.6)"
  type        = string
}


# ============================================
# Redis-Specific Configuration
# ============================================

variable "cluster_mode_enabled" {
  description = "Enable Redis cluster mode (sharding)"
  type        = bool
  default     = false
}

variable "num_node_groups" {
  description = "Number of node groups (shards) for Redis cluster mode"
  type        = number
  default     = 1

  validation {
    condition     = var.num_node_groups >= 1
    error_message = "Number of node groups must be at least 1."
  }
}

variable "replicas_per_node_group" {
  description = "Number of replica nodes per node group (shard)"
  type        = number
  default     = 0

  validation {
    condition     = var.replicas_per_node_group >= 0 && var.replicas_per_node_group <= 5
    error_message = "Replicas per node group must be between 0 and 5."
  }
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover for Redis replication groups"
  type        = bool
  default     = false
}

variable "multi_az_enabled" {
  description = "Enable multi-AZ deployment for Redis"
  type        = bool
  default     = false
}

variable "auth_token" {
  description = "Password used to access a password protected Redis server (requires transit_encryption_enabled = true)"
  type        = string
  default     = null
  sensitive   = true
}

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit (TLS) for Redis"
  type        = bool
  default     = false
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest for Redis"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "ARN of the KMS key to use for encryption at rest"
  type        = string
  default     = null
}

variable "data_tiering_enabled" {
  description = "Enable data tiering for Redis (r6gd node types)"
  type        = bool
  default     = false
}

variable "log_delivery_configuration" {
  description = "List of log delivery configurations for Redis"
  type = list(object({
    destination      = string
    destination_type = string
    log_format       = string
    log_type         = string
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration :
      contains(["cloudwatch-logs", "kinesis-firehose"], config.destination_type)
    ])
    error_message = "Log delivery destination_type must be either 'cloudwatch-logs' or 'kinesis-firehose'."
  }

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration :
      contains(["json", "text"], config.log_format)
    ])
    error_message = "Log delivery log_format must be either 'json' or 'text'."
  }

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration :
      contains(["slow-log", "engine-log"], config.log_type)
    ])
    error_message = "Log delivery log_type must be either 'slow-log' or 'engine-log'."
  }
}


# ============================================
# Memcached-Specific Configuration
# ============================================

variable "num_cache_nodes" {
  description = "Number of cache nodes for Memcached cluster"
  type        = number
  default     = 1

  validation {
    condition     = var.num_cache_nodes >= 1 && var.num_cache_nodes <= 40
    error_message = "Number of cache nodes must be between 1 and 40."
  }
}


# ============================================
# Backup and Maintenance Configuration
# ============================================

variable "snapshot_retention_limit" {
  description = "Number of days to retain automatic snapshots (Redis only, 0 to disable)"
  type        = number
  default     = 0

  validation {
    condition     = var.snapshot_retention_limit >= 0 && var.snapshot_retention_limit <= 35
    error_message = "Snapshot retention limit must be between 0 and 35 days."
  }
}

variable "snapshot_window" {
  description = "Daily time range during which automated backups are created (e.g., 05:00-09:00)"
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "Weekly time range for system maintenance (e.g., sun:05:00-sun:09:00)"
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "Name of the final snapshot created when the cluster is deleted"
  type        = string
  default     = null
}

variable "snapshot_arns" {
  description = "List of snapshot ARNs to restore from (Redis only)"
  type        = list(string)
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades during maintenance window"
  type        = bool
  default     = true
}


# ============================================
# Network and Security Configuration
# ============================================

variable "security_group_name" {
  description = "Name for the ElastiCache security group (auto-generated if not provided)"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "Description for the ElastiCache security group"
  type        = string
  default     = "Security group for ElastiCache cluster"
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks allowed to access ElastiCache (defaults to VPC CIDR)"
  type        = list(string)
  default     = null
}

variable "ingress_rules" {
  description = "List of custom ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "additional_security_group_ids" {
  description = "List of additional security group IDs to attach to ElastiCache"
  type        = list(string)
  default     = []
}


# ============================================
# Monitoring and Notification Configuration
# ============================================

variable "notification_topic_arn" {
  description = "ARN of SNS topic for ElastiCache notifications"
  type        = string
  default     = null
}

variable "cloudwatch_log_exports" {
  description = "List of log types to export to CloudWatch (slow-log, engine-log)"
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

variable "preferred_availability_zones" {
  description = "List of preferred availability zones for cache node placement"
  type        = list(string)
  default     = null
}


# ============================================
# Tagging and Naming Configuration
# ============================================

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Map of custom tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "description" {
  description = "Description for the ElastiCache cluster or replication group"
  type        = string
  default     = "Managed by Terraform"
}


# ============================================
# Parameter Group Configuration
# ============================================

variable "create_parameter_group" {
  description = "Whether to create a custom parameter group"
  type        = bool
  default     = false
}

variable "parameters" {
  description = "List of parameter objects for custom parameter group configuration"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
