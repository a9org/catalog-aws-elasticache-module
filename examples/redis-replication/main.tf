# ============================================
# Redis Replication Group Example
# ============================================
# This example demonstrates deploying a Redis replication group with
# high availability, encryption, and automatic failover.

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
# ElastiCache Redis Replication Group Module
# ============================================

module "redis_ha" {
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

  # High availability configuration (no cluster mode)
  cluster_mode_enabled       = false
  replicas_per_node_group    = var.replicas_per_node_group
  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled
  preferred_availability_zones = var.preferred_availability_zones

  # Security configuration
  transit_encryption_enabled = var.transit_encryption_enabled
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  auth_token                 = var.auth_token
  kms_key_id                 = var.kms_key_id

  # Backup configuration
  snapshot_retention_limit  = var.snapshot_retention_limit
  snapshot_window           = var.snapshot_window
  final_snapshot_identifier = "${var.name_prefix}-${var.environment}-final-snapshot"
  snapshot_arns             = var.snapshot_arns

  # Maintenance configuration
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  # Monitoring
  notification_topic_arn = var.notification_topic_arn

  # Custom parameter group (optional)
  create_parameter_group = var.create_parameter_group
  parameters             = var.parameters

  # Network security
  ingress_cidr_blocks = var.ingress_cidr_blocks

  # Tagging
  tags = merge(
    var.tags,
    {
      Example = "redis-replication-ha"
    }
  )
}
