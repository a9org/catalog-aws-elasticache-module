# ============================================
# Cluster Outputs
# ============================================

output "cluster_id" {
  description = "Redis replication group identifier"
  value       = module.redis_ha.cluster_id
}

output "engine" {
  description = "Cache engine type"
  value       = module.redis_ha.engine
}

output "engine_version" {
  description = "Redis engine version"
  value       = module.redis_ha.engine_version
}


# ============================================
# Endpoint Outputs
# ============================================

output "primary_endpoint_address" {
  description = "Primary endpoint address for write operations"
  value       = module.redis_ha.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint address for read operations"
  value       = module.redis_ha.reader_endpoint_address
}

output "port" {
  description = "Redis port number"
  value       = module.redis_ha.port
}

output "primary_connection_string" {
  description = "Redis primary connection string (without auth token)"
  value       = "redis://${module.redis_ha.primary_endpoint_address}:${module.redis_ha.port}"
}

output "reader_connection_string" {
  description = "Redis reader connection string (without auth token)"
  value       = "redis://${module.redis_ha.reader_endpoint_address}:${module.redis_ha.port}"
}


# ============================================
# Network Outputs
# ============================================

output "security_group_id" {
  description = "Security group ID for ElastiCache"
  value       = module.redis_ha.security_group_id
}

output "subnet_group_name" {
  description = "Subnet group name for ElastiCache"
  value       = module.redis_ha.subnet_group_name
}


# ============================================
# Configuration Summary
# ============================================

output "replication_configuration" {
  description = "Summary of replication configuration"
  value = {
    cluster_mode_enabled       = false
    replicas_per_node_group    = var.replicas_per_node_group
    total_nodes                = var.replicas_per_node_group + 1
    automatic_failover_enabled = var.automatic_failover_enabled
    multi_az_enabled           = var.multi_az_enabled
    node_type                  = var.node_type
    encryption_enabled         = var.transit_encryption_enabled && var.at_rest_encryption_enabled
  }
}
