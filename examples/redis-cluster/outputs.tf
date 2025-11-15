# ============================================
# Cluster Outputs
# ============================================

output "cluster_id" {
  description = "Redis replication group identifier"
  value       = module.redis_cluster.cluster_id
}

output "engine" {
  description = "Cache engine type"
  value       = module.redis_cluster.engine
}

output "engine_version" {
  description = "Redis engine version"
  value       = module.redis_cluster.engine_version
}


# ============================================
# Endpoint Outputs
# ============================================

output "primary_endpoint_address" {
  description = "Primary endpoint address for Redis cluster"
  value       = module.redis_cluster.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint address for Redis cluster"
  value       = module.redis_cluster.reader_endpoint_address
}

output "port" {
  description = "Redis port number"
  value       = module.redis_cluster.port
}

output "connection_string" {
  description = "Redis connection string (without auth token)"
  value       = "redis://${module.redis_cluster.primary_endpoint_address}:${module.redis_cluster.port}"
}


# ============================================
# Network Outputs
# ============================================

output "security_group_id" {
  description = "Security group ID for ElastiCache"
  value       = module.redis_cluster.security_group_id
}

output "subnet_group_name" {
  description = "Subnet group name for ElastiCache"
  value       = module.redis_cluster.subnet_group_name
}


# ============================================
# Configuration Summary
# ============================================

output "cluster_configuration" {
  description = "Summary of cluster configuration"
  value = {
    cluster_mode_enabled    = true
    num_node_groups         = var.num_node_groups
    replicas_per_node_group = var.replicas_per_node_group
    total_nodes             = var.num_node_groups * (var.replicas_per_node_group + 1)
    node_type               = var.node_type
    encryption_enabled      = var.transit_encryption_enabled && var.at_rest_encryption_enabled
  }
}
