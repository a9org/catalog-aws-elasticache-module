# ============================================
# Redis Replication Group
# ============================================

resource "aws_elasticache_replication_group" "redis" {
  count = local.is_redis ? 1 : 0

  replication_group_id = local.replication_group_id
  description          = var.description
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  port                 = coalesce(local.port_final, 6379)
  parameter_group_name = local.parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = concat([aws_security_group.this.id], local.additional_security_group_ids_final)

  # Cluster mode configuration
  num_node_groups         = local.cluster_mode_enabled_final ? local.num_node_groups_final : null
  replicas_per_node_group = local.cluster_mode_enabled_final ? local.replicas_per_node_group_final : null

  # High availability configuration
  automatic_failover_enabled  = local.automatic_failover_enabled_final
  multi_az_enabled            = local.multi_az_enabled_final
  preferred_cache_cluster_azs = local.preferred_availability_zones_final

  # Security configuration
  at_rest_encryption_enabled = local.at_rest_encryption_enabled_final
  transit_encryption_enabled = local.transit_encryption_enabled_final
  auth_token                 = var.auth_token
  kms_key_id                 = var.kms_key_id

  # Backup configuration
  snapshot_retention_limit  = local.snapshot_retention_limit_final
  snapshot_window           = var.snapshot_window
  final_snapshot_identifier = var.final_snapshot_identifier
  snapshot_arns             = local.snapshot_arns_final

  # Maintenance and notification configuration
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = local.auto_minor_version_upgrade_final
  notification_topic_arn     = var.notification_topic_arn

  # Advanced features
  data_tiering_enabled = local.data_tiering_enabled_final

  # Log delivery configuration
  dynamic "log_delivery_configuration" {
    for_each = local.log_delivery_configuration_final
    content {
      destination      = log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }

  tags = local.common_tags
}

# ============================================
# Memcached Cluster
# ============================================

resource "aws_elasticache_cluster" "memcached" {
  count = local.is_memcached ? 1 : 0

  cluster_id           = local.cluster_id
  engine               = "memcached"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = local.num_cache_nodes_final
  port                 = coalesce(local.port_final, 11211)
  parameter_group_name = local.parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = concat([aws_security_group.this.id], local.additional_security_group_ids_final)

  # Availability zone configuration
  preferred_availability_zones = local.preferred_availability_zones_final

  # Maintenance and notification configuration
  maintenance_window         = var.maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  auto_minor_version_upgrade = local.auto_minor_version_upgrade_final

  tags = local.common_tags
}
