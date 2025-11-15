# ============================================
# IDP String-Only Example Variables
# ============================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Required string variables
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "engine" {
  description = "Engine type (redis or memcached)"
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = "7.0"
}

variable "node_type" {
  description = "Node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "parameter_family" {
  description = "Parameter family"
  type        = string
  default     = "redis7"
}

# JSON string variables
variable "subnets_pvt_json" {
  description = "JSON string of subnet IDs - Example: '[\"subnet-123\",\"subnet-456\"]'"
  type        = string
}

variable "tags_json" {
  description = "JSON string of tags - Example: '{\"Project\":\"MyApp\",\"Team\":\"Platform\"}'"
  type        = string
  default     = "{}"
}

# Boolean variables as strings
variable "cluster_mode_enabled_str" {
  description = "Enable cluster mode - use 'true' or 'false'"
  type        = string
  default     = "false"
}

variable "automatic_failover_enabled_str" {
  description = "Enable automatic failover - use 'true' or 'false'"
  type        = string
  default     = "false"
}

variable "multi_az_enabled_str" {
  description = "Enable multi-AZ - use 'true' or 'false'"
  type        = string
  default     = "false"
}

variable "transit_encryption_enabled_str" {
  description = "Enable transit encryption - use 'true' or 'false'"
  type        = string
  default     = "false"
}

variable "at_rest_encryption_enabled_str" {
  description = "Enable at-rest encryption - use 'true' or 'false'"
  type        = string
  default     = "false"
}

variable "auto_minor_version_upgrade_str" {
  description = "Enable auto minor version upgrade - use 'true' or 'false'"
  type        = string
  default     = "true"
}

# Number variables as strings
variable "port_str" {
  description = "Port number as string - Example: '6379'"
  type        = string
  default     = ""
}

variable "num_node_groups_str" {
  description = "Number of node groups as string - Example: '3'"
  type        = string
  default     = "1"
}

variable "replicas_per_node_group_str" {
  description = "Replicas per node group as string - Example: '2'"
  type        = string
  default     = "0"
}

variable "snapshot_retention_limit_str" {
  description = "Snapshot retention limit as string - Example: '7'"
  type        = string
  default     = "0"
}

# Optional string variables
variable "description" {
  description = "Description"
  type        = string
  default     = "Managed by Terraform"
}

variable "auth_token" {
  description = "Auth token"
  type        = string
  default     = null
  sensitive   = true
}

variable "kms_key_id" {
  description = "KMS key ID"
  type        = string
  default     = null
}

variable "snapshot_window" {
  description = "Snapshot window"
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = null
}

variable "notification_topic_arn" {
  description = "Notification topic ARN"
  type        = string
  default     = null
}
