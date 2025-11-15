# ============================================
# Redis Cluster Mode Example
# ============================================
# This example demonstrates deploying a Redis cluster with cluster mode
# (sharding) enabled for horizontal scalability and high availability.

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ============================================
# ElastiCache Redis Cluster Module
# ============================================

module "redis_cluster" {
  source = "../.."

  # IDP-provided variables (simulated here)
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  subnets_pvt    = var.subnets_pvt

  # Core configuration
  name_prefix      = var.name_prefix
  environment      = var.environment
  engine           = "redis"
  engine_version   = var.engine_version
  node_type        = var.node_type
  parameter_family = var.parameter_family

  # Cluster mode configuration (sharding)
  cluster_mode_enabled       = true
  num_node_groups            = var.num_node_groups
  replicas_per_node_group    = var.replicas_per_node_group
  automatic_failover_enabled = true

  # Security configuration
  transit_encryption_enabled = var.transit_encryption_enabled
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  auth_token                 = var.auth_token
  kms_key_id                 = var.kms_key_id

  # Backup configuration
  snapshot_retention_limit  = var.snapshot_retention_limit
  snapshot_window           = var.snapshot_window
  final_snapshot_identifier = "${var.name_prefix}-${var.environment}-final-snapshot"

  # Maintenance configuration
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  # Monitoring
  notification_topic_arn = var.notification_topic_arn

  # Log delivery (optional)
  log_delivery_configuration = var.enable_log_delivery ? [
    {
      destination      = var.cloudwatch_log_group_name
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "slow-log"
    },
    {
      destination      = var.cloudwatch_log_group_name
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ] : []

  # Tagging
  tags = merge(
    var.tags,
    {
      Example = "redis-cluster-mode"
    }
  )
}
