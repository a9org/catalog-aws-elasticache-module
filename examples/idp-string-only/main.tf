# ============================================
# IDP String-Only Input Example
# ============================================
# This example shows how to use the module when the IDP
# can ONLY pass strings and numbers (no booleans, lists, or objects)

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
# ElastiCache Module with String-Only Inputs
# ============================================

module "redis_cache" {
  source = "../.."

  # Required string variables
  vpc_id           = var.vpc_id
  vpc_cidr_block   = var.vpc_cidr_block
  name_prefix      = var.name_prefix
  environment      = var.environment
  engine           = var.engine
  engine_version   = var.engine_version
  node_type        = var.node_type
  parameter_family = var.parameter_family

  # Complex types as JSON strings
  subnets_pvt_json = var.subnets_pvt_json
  tags_json        = var.tags_json

  # Boolean values as strings ("true" or "false")
  cluster_mode_enabled_str       = var.cluster_mode_enabled_str
  automatic_failover_enabled_str = var.automatic_failover_enabled_str
  multi_az_enabled_str           = var.multi_az_enabled_str
  transit_encryption_enabled_str = var.transit_encryption_enabled_str
  at_rest_encryption_enabled_str = var.at_rest_encryption_enabled_str
  auto_minor_version_upgrade_str = var.auto_minor_version_upgrade_str

  # Number values as strings
  port_str                      = var.port_str
  num_node_groups_str           = var.num_node_groups_str
  replicas_per_node_group_str   = var.replicas_per_node_group_str
  snapshot_retention_limit_str  = var.snapshot_retention_limit_str

  # Optional string variables
  description            = var.description
  auth_token             = var.auth_token
  kms_key_id             = var.kms_key_id
  snapshot_window        = var.snapshot_window
  maintenance_window     = var.maintenance_window
  notification_topic_arn = var.notification_topic_arn
}
