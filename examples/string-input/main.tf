# ============================================
# String Input Example
# ============================================
# This example shows how to use the module when all inputs
# must be provided as strings (e.g., from an IDP or API)

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
# ElastiCache Module with String Inputs
# ============================================

module "redis_cache" {
  source = "../.."

  # Required string variables
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  name_prefix    = var.name_prefix
  environment    = var.environment
  engine         = var.engine
  engine_version = var.engine_version
  node_type      = var.node_type
  parameter_family = var.parameter_family

  # JSON string variables (converted internally)
  subnets_pvt_json = var.subnets_pvt_json
  tags_json        = var.tags_json
  
  # Optional JSON string variables
  parameters_json                   = var.parameters_json
  ingress_rules_json                = var.ingress_rules_json
  snapshot_arns_json                = var.snapshot_arns_json
  ingress_cidr_blocks_json          = var.ingress_cidr_blocks_json
  cloudwatch_log_exports_json       = var.cloudwatch_log_exports_json
  log_delivery_configuration_json   = var.log_delivery_configuration_json
  preferred_availability_zones_json = var.preferred_availability_zones_json
  additional_security_group_ids_json = var.additional_security_group_ids_json

  # Other optional variables
  description                = var.description
  port                       = var.port
  cluster_mode_enabled       = var.cluster_mode_enabled
  num_node_groups            = var.num_node_groups
  replicas_per_node_group    = var.replicas_per_node_group
  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  auth_token                 = var.auth_token
  kms_key_id                 = var.kms_key_id
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window
  maintenance_window         = var.maintenance_window
  final_snapshot_identifier  = var.final_snapshot_identifier
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  notification_topic_arn     = var.notification_topic_arn
  create_parameter_group     = var.create_parameter_group
  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
}
