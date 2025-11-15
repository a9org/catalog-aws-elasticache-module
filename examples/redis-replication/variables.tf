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
  default     = "myapp-redis"
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
  default     = "cache.r6g.large"
}

variable "parameter_family" {
  description = "Redis parameter family"
  type        = string
  default     = "redis7"
}


# ============================================
# High Availability Configuration
# ============================================

variable "replicas_per_node_group" {
  description = "Number of replica nodes"
  type        = number
  default     = 2
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover"
  type        = bool
  default     = true
}

variable "multi_az_enabled" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default     = true
}

variable "preferred_availability_zones" {
  description = "Preferred availability zones for node placement"
  type        = list(string)
  default     = null
}


# ============================================
# Security Configuration
# ============================================

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit (TLS)"
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

variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access Redis"
  type        = list(string)
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

variable "snapshot_arns" {
  description = "Snapshot ARNs to restore from"
  type        = list(string)
  default     = null
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


# ============================================
# Parameter Group Configuration
# ============================================

variable "create_parameter_group" {
  description = "Create custom parameter group"
  type        = bool
  default     = false
}

variable "parameters" {
  description = "Custom Redis parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
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
