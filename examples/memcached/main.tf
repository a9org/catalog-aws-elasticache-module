# ============================================
# Memcached Cluster Example
# ============================================
# This example demonstrates deploying a Memcached cluster for
# simple, distributed in-memory caching.

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
# ElastiCache Memcached Cluster Module
# ============================================

module "memcached_cache" {
  source = "../.."

  # IDP-provided variables (simulated here)
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  subnets_pvt    = var.subnets_pvt

  # Core configuration
  name_prefix      = var.name_prefix
  environment      = var.environment
  engine           = "memcached"
  engine_version   = var.engine_version
  node_type        = var.node_type
  parameter_family = var.parameter_family

  # Memcached cluster configuration
  num_cache_nodes              = var.num_cache_nodes
  preferred_availability_zones = var.preferred_availability_zones

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
      Example = "memcached-cluster"
    }
  )
}
