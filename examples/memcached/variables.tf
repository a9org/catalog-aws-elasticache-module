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
  description = "Memcached engine version"
  type        = string
  default     = "1.6.17"
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "parameter_family" {
  description = "Memcached parameter family"
  type        = string
  default     = "memcached1.6"
}


# ============================================
# Cluster Configuration
# ============================================

variable "num_cache_nodes" {
  description = "Number of cache nodes in the cluster"
  type        = number
  default     = 3
}

variable "preferred_availability_zones" {
  description = "Preferred availability zones for node placement"
  type        = list(string)
  default     = null
}


# ============================================
# Network Security
# ============================================

variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access Memcached"
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
  description = "Custom Memcached parameters"
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
