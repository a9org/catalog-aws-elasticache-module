# ============================================
# String Input Example Variables
# ============================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Required variables
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

variable "parameters_json" {
  description = "JSON string of parameters - Example: '[{\"name\":\"maxmemory-policy\",\"value\":\"allkeys-lru\"}]'"
  type        = string
  default     = "[]"
}

variable "ingress_rules_json" {
  description = "JSON string of ingress rules"
  type        = string
  default     = "[]"
}

variable "snapshot_arns_json" {
  description = "JSON string of snapshot ARNs - Example: '[\"arn:aws:elasticache:...\"]' or 'null'"
  type        = string
  default     = "null"
}

variable "ingress_cidr_blocks_json" {
  description = "JSON string of ingress CIDR blocks - Example: '[\"10.0.0.0/16\"]' or 'null'"
  type        = string
  default     = "null"
}

variable "cloudwatch_log_exports_json" {
  description = "JSON string of CloudWatch log exports - Example: '[\"slow-log\",\"engine-log\"]'"
  type        = string
  default     = "[]"
}

variable "log_delivery_configuration_json" {
  description = "JSON string of log delivery configuration"
  type        = string
  default     = "[]"
}

variable "preferred_availability_zones_json" {
  description = "JSON string of preferred AZs - Example: '[\"us-east-1a\",\"us-east-1b\"]' or 'null'"
  type        = string
  default     = "null"
}

variable "additional_security_group_ids_json" {
  description = "JSON string of additional security group IDs - Example: '[\"sg-123\",\"sg-456\"]'"
  type        = string
  default     = "[]"
}

# Optional variables
variable "description" {
  description = "Description"
  type        = string
  default     = "Managed by Terraform"
}

variable "port" {
  description = "Port number"
  type        = number
  default     = null
}

variable "cluster_mode_enabled" {
  description = "Enable cluster mode"
  type        = bool
  default     = false
}

variable "num_node_groups" {
  description = "Number of node groups"
  type        = number
  default     = 1
}

variable "replicas_per_node_group" {
  description = "Replicas per node group"
  type        = number
  default     = 0
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover"
  type        = bool
  default     = false
}

variable "multi_az_enabled" {
  description = "Enable multi-AZ"
  type        = bool
  default     = false
}

variable "transit_encryption_enabled" {
  description = "Enable transit encryption"
  type        = bool
  default     = false
}

variable "at_rest_encryption_enabled" {
  description = "Enable at-rest encryption"
  type        = bool
  default     = false
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

variable "snapshot_retention_limit" {
  description = "Snapshot retention limit"
  type        = number
  default     = 0
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

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier"
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Auto minor version upgrade"
  type        = bool
  default     = true
}

variable "notification_topic_arn" {
  description = "Notification topic ARN"
  type        = string
  default     = null
}

variable "create_parameter_group" {
  description = "Create parameter group"
  type        = bool
  default     = false
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "Security group description"
  type        = string
  default     = "Security group for ElastiCache cluster"
}
