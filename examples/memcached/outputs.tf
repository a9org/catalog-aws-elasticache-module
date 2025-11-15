# ============================================
# Cluster Outputs
# ============================================

output "cluster_id" {
  description = "Memcached cluster identifier"
  value       = module.memcached_cache.cluster_id
}

output "engine" {
  description = "Cache engine type"
  value       = module.memcached_cache.engine
}

output "engine_version" {
  description = "Memcached engine version"
  value       = module.memcached_cache.engine_version
}


# ============================================
# Endpoint Outputs
# ============================================

output "configuration_endpoint" {
  description = "Configuration endpoint for Memcached cluster"
  value       = module.memcached_cache.primary_endpoint_address
}

output "port" {
  description = "Memcached port number"
  value       = module.memcached_cache.port
}

output "connection_string" {
  description = "Memcached connection string"
  value       = "${module.memcached_cache.primary_endpoint_address}:${module.memcached_cache.port}"
}


# ============================================
# Network Outputs
# ============================================

output "security_group_id" {
  description = "Security group ID for ElastiCache"
  value       = module.memcached_cache.security_group_id
}

output "subnet_group_name" {
  description = "Subnet group name for ElastiCache"
  value       = module.memcached_cache.subnet_group_name
}


# ============================================
# Configuration Summary
# ============================================

output "cluster_configuration" {
  description = "Summary of cluster configuration"
  value = {
    engine          = "memcached"
    num_cache_nodes = var.num_cache_nodes
    node_type       = var.node_type
    engine_version  = var.engine_version
  }
}
