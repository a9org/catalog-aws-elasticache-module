locals {
  # Engine type detection
  is_redis     = var.engine == "redis"
  is_memcached = var.engine == "memcached"

  # Convert string booleans to actual booleans
  # Accepts: "true", "false", "1", "0" or falls back to native bool variable
  cluster_mode_enabled_final = var.cluster_mode_enabled_str != "" ? (
    contains(["true", "1"], lower(var.cluster_mode_enabled_str))
  ) : var.cluster_mode_enabled

  automatic_failover_enabled_final = var.automatic_failover_enabled_str != "" ? (
    contains(["true", "1"], lower(var.automatic_failover_enabled_str))
  ) : var.automatic_failover_enabled

  multi_az_enabled_final = var.multi_az_enabled_str != "" ? (
    contains(["true", "1"], lower(var.multi_az_enabled_str))
  ) : var.multi_az_enabled

  transit_encryption_enabled_final = var.transit_encryption_enabled_str != "" ? (
    contains(["true", "1"], lower(var.transit_encryption_enabled_str))
  ) : var.transit_encryption_enabled

  at_rest_encryption_enabled_final = var.at_rest_encryption_enabled_str != "" ? (
    contains(["true", "1"], lower(var.at_rest_encryption_enabled_str))
  ) : var.at_rest_encryption_enabled

  data_tiering_enabled_final = var.data_tiering_enabled_str != "" ? (
    contains(["true", "1"], lower(var.data_tiering_enabled_str))
  ) : var.data_tiering_enabled

  auto_minor_version_upgrade_final = var.auto_minor_version_upgrade_str != "" ? (
    contains(["true", "1"], lower(var.auto_minor_version_upgrade_str))
  ) : var.auto_minor_version_upgrade

  create_parameter_group_final = var.create_parameter_group_str != "" ? (
    contains(["true", "1"], lower(var.create_parameter_group_str))
  ) : var.create_parameter_group

  # Convert string numbers to actual numbers
  port_final                     = var.port_str != "" ? tonumber(var.port_str) : var.port
  num_node_groups_final          = var.num_node_groups_str != "" ? tonumber(var.num_node_groups_str) : var.num_node_groups
  replicas_per_node_group_final  = var.replicas_per_node_group_str != "" ? tonumber(var.replicas_per_node_group_str) : var.replicas_per_node_group
  num_cache_nodes_final          = var.num_cache_nodes_str != "" ? tonumber(var.num_cache_nodes_str) : var.num_cache_nodes
  snapshot_retention_limit_final = var.snapshot_retention_limit_str != "" ? tonumber(var.snapshot_retention_limit_str) : var.snapshot_retention_limit

  # Resource naming conventions
  cluster_id           = "${var.name_prefix}-${var.environment}"
  replication_group_id = "${var.name_prefix}-${var.environment}"
  subnet_group_name    = "${var.name_prefix}-${var.environment}-subnet-group"
  security_group_name  = coalesce(var.security_group_name, "${var.name_prefix}-${var.environment}-sg")
  parameter_group_name = local.create_parameter_group_final ? "${var.name_prefix}-${var.environment}-params" : var.parameter_family

  # Decode JSON strings if provided, otherwise use direct variables
  # This allows the module to accept both native types and JSON strings
  # Defaults to empty list/map if both are null/empty
  tags_final                              = var.tags_json != "" ? jsondecode(var.tags_json) : (var.tags != null ? var.tags : {})
  parameters_final                        = var.parameters_json != "" ? jsondecode(var.parameters_json) : (var.parameters != null ? var.parameters : [])
  subnets_pvt_final                       = var.subnets_pvt_json != "" ? jsondecode(var.subnets_pvt_json) : (var.subnets_pvt != null ? var.subnets_pvt : [])
  ingress_rules_final                     = var.ingress_rules_json != "" ? jsondecode(var.ingress_rules_json) : (var.ingress_rules != null ? var.ingress_rules : [])
  snapshot_arns_final                     = var.snapshot_arns_json != "" ? jsondecode(var.snapshot_arns_json) : var.snapshot_arns
  ingress_cidr_blocks_final               = var.ingress_cidr_blocks_json != "" ? jsondecode(var.ingress_cidr_blocks_json) : var.ingress_cidr_blocks
  cloudwatch_log_exports_final            = var.cloudwatch_log_exports_json != "" ? jsondecode(var.cloudwatch_log_exports_json) : (var.cloudwatch_log_exports != null ? var.cloudwatch_log_exports : [])
  log_delivery_configuration_final        = var.log_delivery_configuration_json != "" ? jsondecode(var.log_delivery_configuration_json) : (var.log_delivery_configuration != null ? var.log_delivery_configuration : [])
  preferred_availability_zones_final      = var.preferred_availability_zones_json != "" ? jsondecode(var.preferred_availability_zones_json) : var.preferred_availability_zones
  additional_security_group_ids_final     = var.additional_security_group_ids_json != "" ? jsondecode(var.additional_security_group_ids_json) : (var.additional_security_group_ids != null ? var.additional_security_group_ids : [])

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
