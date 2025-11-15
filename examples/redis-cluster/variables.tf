# ============================================
# AWS Configuration
# ============================================

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}


# ============================================
# IDP-Provided Variables (simulated)
# ============================================

variable "vpc_id" {
  description = "VPC ID where ElastiCache will be deployed"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block for security group rules"
  type        = string
}

variable "subnets_pvt" {
  description = "List of private subnet IDs for ElastiCache"
  type        = list(string)
}


# ============================================
# Core Configuration
# ============================================

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "myapp-cache"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.r6g.xlarge"
}

variable "parameter_family" {
  description = "Redis parameter family"
  type        = string
  default     = "redis7"
}


# ============================================
# Cluster Mode Configuration
# ============================================

variable "num_node_groups" {
  description = "Number of shards (node groups) in the cluster"
  type        = number
  default     = 3
}

variable "replicas_per_node_group" {
  description = "Number of replica nodes per shard"
  type        = number
  default     = 2
}


# ============================================
# Security Configuration
# ============================================

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit"
  type        = bool
  default     = true
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "Redis AUTH token for authentication"
  type        = string
  default     = null
  sensitive   = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption at rest"
  type        = string
  default     = null
}


# ============================================
# Backup Configuration
# ============================================

variable "snapshot_retention_limit" {
  description = "Number of days to retain snapshots"
  type        = number
  default     = 7
}

variable "snapshot_window" {
  description = "Daily snapshot window"
  type        = string
  default     = "03:00-05:00"
}


# ============================================
# Maintenance Configuration
# ============================================

variable "maintenance_window" {
  description = "Weekly maintenance window"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}


# ============================================
# Monitoring Configuration
# ============================================

variable "notification_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
  default     = null
}

variable "enable_log_delivery" {
  description = "Enable CloudWatch log delivery"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for Redis logs"
  type        = string
  default     = "/aws/elasticache/redis"
}


# ============================================
# Tagging
# ============================================

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default = {
    Project = "MyApplication"
    Team    = "Platform"
  }
}
