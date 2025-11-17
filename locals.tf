locals {
  # Engine type detection
  is_redis     = var.engine == "redis"
  is_memcached = var.engine == "memcached"

  # Convert string booleans to actual booleans
  # Accepts: "true", "false", "1", "0" or empty string (defaults to false)
  cluster_mode_enabled_final = var.cluster_mode_enabled != "" ? (
    contains(["true", "1"], lower(var.cluster_mode_enabled))
  ) : false

  automatic_failover_enabled_final = var.automatic_failover_enabled != "" ? (
    contains(["true", "1"], lower(var.automatic_failover_enabled))
  ) : false

  multi_az_enabled_final = var.multi_az_enabled != "" ? (
    contains(["true", "1"], lower(var.multi_az_enabled))
  ) : false

  transit_encryption_enabled_final = var.transit_encryption_enabled != "" ? (
    contains(["true", "1"], lower(var.transit_encryption_enabled))
  ) : false

  at_rest_encryption_enabled_final = var.at_rest_encryption_enabled != "" ? (
    contains(["true", "1"], lower(var.at_rest_encryption_enabled))
  ) : false

  data_tiering_enabled_final = var.data_tiering_enabled != "" ? (
    contains(["true", "1"], lower(var.data_tiering_enabled))
  ) : false

  auto_minor_version_upgrade_final = var.auto_minor_version_upgrade != "" ? (
    contains(["true", "1"], lower(var.auto_minor_version_upgrade))
  ) : true

  create_parameter_group_final = var.create_parameter_group != "" ? (
    contains(["true", "1"], lower(var.create_parameter_group))
  ) : false

  # Convert string numbers to actual numbers
  port_final                     = var.port != "" ? tonumber(var.port) : (local.is_redis ? 6379 : 11211)
  num_node_groups_final          = var.num_node_groups != "" ? tonumber(var.num_node_groups) : 1
  replicas_per_node_group_final  = var.replicas_per_node_group != "" ? tonumber(var.replicas_per_node_group) : 0
  num_cache_nodes_final          = var.num_cache_nodes != "" ? tonumber(var.num_cache_nodes) : 1
  snapshot_retention_limit_final = var.snapshot_retention_limit != "" ? tonumber(var.snapshot_retention_limit) : 0

  # Resource naming conventions
  cluster_id           = "${var.name_prefix}-${var.environment}"
  replication_group_id = "${var.name_prefix}-${var.environment}"
  subnet_group_name    = "${var.name_prefix}-${var.environment}-subnet-group"
  security_group_name  = var.security_group_name != "" ? var.security_group_name : "${var.name_prefix}-${var.environment}-sg"
  parameter_group_name = local.create_parameter_group_final ? "${var.name_prefix}-${var.environment}-params" : var.parameter_family

  # Decode JSON strings to proper types
  # Empty strings default to appropriate empty values ([], {})
  tags_final                          = var.tags != "" ? jsondecode(var.tags) : {}
  parameters_final                    = var.parameters != "" ? jsondecode(var.parameters) : []
  subnets_pvt_final                   = var.subnets_pvt != "" ? jsondecode(var.subnets_pvt) : []
  ingress_rules_final                 = var.ingress_rules != "" ? jsondecode(var.ingress_rules) : []
  snapshot_arns_final                 = var.snapshot_arns != "" ? jsondecode(var.snapshot_arns) : []
  ingress_cidr_blocks_final           = var.ingress_cidr_blocks != "" ? jsondecode(var.ingress_cidr_blocks) : []
  cloudwatch_log_exports_final        = var.cloudwatch_log_exports != "" ? jsondecode(var.cloudwatch_log_exports) : []
  log_delivery_configuration_final    = var.log_delivery_configuration != "" ? jsondecode(var.log_delivery_configuration) : []
  preferred_availability_zones_final  = var.preferred_availability_zones != "" ? jsondecode(var.preferred_availability_zones) : []
  additional_security_group_ids_final = var.additional_security_group_ids != "" ? jsondecode(var.additional_security_group_ids) : []

  # Default network configuration
  default_ingress_cidr = length(local.ingress_cidr_blocks_final) > 0 ? local.ingress_cidr_blocks_final : [var.vpc_cidr_block]

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
