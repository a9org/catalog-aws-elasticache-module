locals {
  # Engine type detection
  is_redis     = var.engine == "redis"
  is_memcached = var.engine == "memcached"

  # Resource naming conventions
  cluster_id           = "${var.name_prefix}-${var.environment}"
  replication_group_id = "${var.name_prefix}-${var.environment}"
  subnet_group_name    = "${var.name_prefix}-${var.environment}-subnet-group"
  security_group_name  = coalesce(var.security_group_name, "${var.name_prefix}-${var.environment}-sg")
  parameter_group_name = var.create_parameter_group ? "${var.name_prefix}-${var.environment}-params" : var.parameter_family

  # Decode JSON strings if provided, otherwise use direct variables
  # This allows the module to accept both native types and JSON strings
  tags_final                         = var.tags_json != "" ? jsondecode(var.tags_json) : var.tags
  parameters_final                   = var.parameters_json != "" ? jsondecode(var.parameters_json) : var.parameters
  subnets_pvt_final                  = var.subnets_pvt_json != "" ? jsondecode(var.subnets_pvt_json) : var.subnets_pvt
  ingress_rules_final                = var.ingress_rules_json != "" ? jsondecode(var.ingress_rules_json) : var.ingress_rules
  snapshot_arns_final                = var.snapshot_arns_json != "" ? jsondecode(var.snapshot_arns_json) : var.snapshot_arns
  ingress_cidr_blocks_final          = var.ingress_cidr_blocks_json != "" ? jsondecode(var.ingress_cidr_blocks_json) : var.ingress_cidr_blocks
  cloudwatch_log_exports_final       = var.cloudwatch_log_exports_json != "" ? jsondecode(var.cloudwatch_log_exports_json) : var.cloudwatch_log_exports
  log_delivery_configuration_final   = var.log_delivery_configuration_json != "" ? jsondecode(var.log_delivery_configuration_json) : var.log_delivery_configuration
  preferred_availability_zones_final = var.preferred_availability_zones_json != "" ? jsondecode(var.preferred_availability_zones_json) : var.preferred_availability_zones
  additional_security_group_ids_final = var.additional_security_group_ids_json != "" ? jsondecode(var.additional_security_group_ids_json) : var.additional_security_group_ids

  # Default network configuration
  default_ingress_cidr = length(coalesce(local.ingress_cidr_blocks_final, [])) > 0 ? local.ingress_cidr_blocks_final : [var.vpc_cidr_block]

  # Merged tags
  common_tags = merge(
    {
      Name        = "${var.name_prefix}-${var.environment}"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    local.tags_final
  )
}
