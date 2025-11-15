# ============================================
# Wrapper Variables for String Input
# ============================================
# These variables accept string inputs and convert them
# to the appropriate types for the module

variable "tags_json" {
  description = "JSON string of tags map (optional, use this OR var.tags)"
  type        = string
  default     = ""
}

variable "parameters_json" {
  description = "JSON string of parameters list (optional, use this OR var.parameters)"
  type        = string
  default     = ""
}

variable "subnets_pvt_json" {
  description = "JSON string of subnet IDs list (optional, use this OR var.subnets_pvt)"
  type        = string
  default     = ""
}

variable "ingress_rules_json" {
  description = "JSON string of ingress rules list (optional, use this OR var.ingress_rules)"
  type        = string
  default     = ""
}

variable "snapshot_arns_json" {
  description = "JSON string of snapshot ARNs list (optional, use this OR var.snapshot_arns)"
  type        = string
  default     = ""
}

variable "ingress_cidr_blocks_json" {
  description = "JSON string of ingress CIDR blocks list (optional, use this OR var.ingress_cidr_blocks)"
  type        = string
  default     = ""
}

variable "cloudwatch_log_exports_json" {
  description = "JSON string of CloudWatch log exports list (optional, use this OR var.cloudwatch_log_exports)"
  type        = string
  default     = ""
}

variable "log_delivery_configuration_json" {
  description = "JSON string of log delivery configuration list (optional, use this OR var.log_delivery_configuration)"
  type        = string
  default     = ""
}

variable "preferred_availability_zones_json" {
  description = "JSON string of preferred availability zones list (optional, use this OR var.preferred_availability_zones)"
  type        = string
  default     = ""
}

variable "additional_security_group_ids_json" {
  description = "JSON string of additional security group IDs list (optional, use this OR var.additional_security_group_ids)"
  type        = string
  default     = ""
}
