# ============================================
# IDP String/Number Variables
# ============================================
# These variables accept string or number inputs from IDPs
# that cannot pass boolean or complex types

# Boolean variables as strings
variable "cluster_mode_enabled_str" {
  description = "Enable Redis cluster mode - use 'true' or 'false' as string"
  type        = string
  default     = ""
  
  validation {
    condition     = var.cluster_mode_enabled_str == "" || contains(["true", "false", "1", "0"], var.cluster_mode_enabled_str)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "automatic_failover_enabled_str" {
  description = "Enable automatic failover - use 'true' or 'false' as string"
  type        = string
  default     = ""
  
  validation {
    condition     = var.automatic_failover_enabled_str == "" || contains(["true", "false", "1", "0"], var.automatic_failover_enabled_str)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "multi_az_enabled_str" {
  description = "Enable multi-AZ - use 'true' or 'false' as string"
  type        = string
  default     = ""
  
  validation {
    condition     = var.multi_az_enabled_str == "" || contains(["true", "false", "1", "0"], var.multi_az_enabled_str)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "transit_encryption_enabled_str" {
  description = "Enable transit encryption - use 'true' or 'false' as string"
  type        = string
  default     = ""
  
  validation {
    condition     = var.transit_encryption_enabled_str == "" || contains(["true", "false", "1", "0"], var.transit_encryption_enabled_str)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "at_rest_encryption_enabled_str" {
  description = "Enable at-rest encryption - use 'true' or 'false' as string"
  type        = string
  default     = ""
  
  validation {
    condition     = var.at_rest_encryption_enabled_str == "" || contains(["true", "false", "1", "0"], var.at_rest_encryption_enabled_str)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "data_tiering_enabled_str" {
  description = "Enable data tiering - use 'true' or 'false' as string"
  type        = string
  default     = ""
  
  validation {
    condition     = var.data_tiering_enabled_str == "" || contains(["true", "false", "1", "0"], var.data_tiering_enabled_str)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "auto_minor_version_upgrade_str" {
  description = "Enable auto minor version upgrade - use 'true' or 'false' as string"
  type        = string
  default     = ""
  
  validation {
    condition     = var.auto_minor_version_upgrade_str == "" || contains(["true", "false", "1", "0"], var.auto_minor_version_upgrade_str)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

variable "create_parameter_group_str" {
  description = "Create parameter group - use 'true' or 'false' as string"
  type        = string
  default     = ""
  
  validation {
    condition     = var.create_parameter_group_str == "" || contains(["true", "false", "1", "0"], var.create_parameter_group_str)
    error_message = "Must be 'true', 'false', '1', '0', or empty string."
  }
}

# Number variables as strings (for IDPs that pass everything as string)
variable "port_str" {
  description = "Port number as string"
  type        = string
  default     = ""
}

variable "num_node_groups_str" {
  description = "Number of node groups as string"
  type        = string
  default     = ""
}

variable "replicas_per_node_group_str" {
  description = "Replicas per node group as string"
  type        = string
  default     = ""
}

variable "num_cache_nodes_str" {
  description = "Number of cache nodes as string"
  type        = string
  default     = ""
}

variable "snapshot_retention_limit_str" {
  description = "Snapshot retention limit as string"
  type        = string
  default     = ""
}
