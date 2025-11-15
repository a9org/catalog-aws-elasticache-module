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
  port                 = coalesce(var.port, 6379)
  parameter_group_name = local.parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = concat([aws_security_group.this.id], var.additional_security_group_ids)

  # Cluster mode configuration
  num_node_groups         = var.cluster_mode_enabled ? var.num_node_groups : null
  replicas_per_node_group = var.cluster_mode_enabled ? var.replicas_per_node_group : null

  # High availability configuration
  automatic_failover_enabled  = var.automatic_failover_enabled
  multi_az_enabled            = var.multi_az_enabled
  preferred_cache_cluster_azs = var.preferred_availability_zones

  # Security configuration
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.auth_token
  kms_key_id                 = var.kms_key_id

  # Backup configuration
  snapshot_retention_limit  = var.snapshot_retention_limit
  snapshot_window           = var.snapshot_window
  final_snapshot_identifier = var.final_snapshot_identifier
  snapshot_arns             = var.snapshot_arns

  # Maintenance and notification configuration
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  notification_topic_arn     = var.notification_topic_arn

  # Advanced features
  data_tiering_enabled = var.data_tiering_enabled

  # Log delivery configuration
  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration
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
  num_cache_nodes      = var.num_cache_nodes
  port                 = coalesce(var.port, 11211)
  parameter_group_name = local.parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = concat([aws_security_group.this.id], var.additional_security_group_ids)

  # Availability zone configuration
  preferred_availability_zones = var.preferred_availability_zones

  # Maintenance and notification configuration
  maintenance_window         = var.maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  tags = local.common_tags
}
