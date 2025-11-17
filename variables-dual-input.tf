# ============================================
# DUAL INPUT SYSTEM - String/JSON Alternatives
# ============================================
# These variables provide string/JSON alternatives for IDPs
# that can only pass strings and numbers (no native booleans, lists, or objects)

# Boolean String Alternatives
variable "cluster_mode_enabled_str" {
  description = "String alternative for cluster_mode_enabled. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = ""
}

variable "automatic_failover_enabled_str" {
  description = "String alternative for automatic_failover_enabled. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = ""
}

variable "multi_az_enabled_str" {
  description = "String alternative for multi_az_enabled. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = ""
}

variable "transit_encryption_enabled_str" {
  description = "String alternative for transit_encryption_enabled. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = ""
}

variable "at_rest_encryption_enabled_str" {
  description = "String alternative for at_rest_encryption_enabled. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = ""
}

variable "data_tiering_enabled_str" {
  description = "String alternative for data_tiering_enabled. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = ""
}

variable "auto_minor_version_upgrade_str" {
  description = "String alternative for auto_minor_version_upgrade. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = ""
}

variable "create_parameter_group_str" {
  description = "String alternative for create_parameter_group. Use 'true', 'false', '1', or '0'"
  type        = string
  default     = ""
}

# Number String Alternatives
variable "port_str" {
  description = "String alternative for port. Example: '6379' for Redis, '11211' for Memcached"
  type        = string
  default     = ""
}

variable "num_node_groups_str" {
  description = "String alternative for num_node_groups. Example: '3'"
  type        = string
  default     = ""
}

variable "replicas_per_node_group_str" {
  description = "String alternative for replicas_per_node_group. Example: '2'"
  type        = string
  default     = ""
}

variable "num_cache_nodes_str" {
  description = "String alternative for num_cache_nodes. Example: '3'"
  type        = string
  default     = ""
}

variable "snapshot_retention_limit_str" {
  description = "String alternative for snapshot_retention_limit. Example: '7'"
  type        = string
  default     = ""
}

# Complex Type JSON String Alternatives
variable "subnets_pvt_json" {
  description = "JSON string alternative for subnets_pvt. Example: '[\"subnet-abc123\",\"subnet-def456\"]'"
  type        = string
  default     = ""
}

variable "tags_json" {
  description = "JSON string alternative for tags. Example: '{\"Project\":\"MyApp\",\"Team\":\"Platform\"}'"
  type        = string
  default     = ""
}

variable "parameters_json" {
  description = "JSON string alternative for parameters. Example: '[{\"name\":\"maxmemory-policy\",\"value\":\"allkeys-lru\"}]'"
  type        = string
  default     = ""
}

variable "ingress_cidr_blocks_json" {
  description = "JSON string alternative for ingress_cidr_blocks. Example: '[\"10.0.0.0/16\",\"172.16.0.0/12\"]'"
  type        = string
  default     = ""
}

variable "ingress_rules_json" {
  description = "JSON string alternative for ingress_rules. Example: '[{\"from_port\":6379,\"to_port\":6379,\"protocol\":\"tcp\",\"cidr_blocks\":[\"10.0.0.0/16\"],\"description\":\"Redis\"}]'"
  type        = string
  default     = ""
}

variable "snapshot_arns_json" {
  description = "JSON string alternative for snapshot_arns. Example: '[\"arn:aws:elasticache:us-east-1:123456789012:snapshot:my-snapshot\"]'"
  type        = string
  default     = ""
}

variable "cloudwatch_log_exports_json" {
  description = "JSON string alternative for cloudwatch_log_exports. Example: '[\"slow-log\",\"engine-log\"]'"
  type        = string
  default     = ""
}

variable "log_delivery_configuration_json" {
  description = "JSON string alternative for log_delivery_configuration. Example: '[{\"destination\":\"/aws/elasticache/redis\",\"destination_type\":\"cloudwatch-logs\",\"log_format\":\"json\",\"log_type\":\"slow-log\"}]'"
  type        = string
  default     = ""
}

variable "preferred_availability_zones_json" {
  description = "JSON string alternative for preferred_availability_zones. Example: '[\"us-east-1a\",\"us-east-1b\",\"us-east-1c\"]'"
  type        = string
  default     = ""
}

variable "additional_security_group_ids_json" {
  description = "JSON string alternative for additional_security_group_ids. Example: '[\"sg-123456\",\"sg-789012\"]'"
  type        = string
  default     = ""
}
