# ============================================
# Cluster Identification Outputs
# ============================================

output "cluster_id" {
  description = "ElastiCache cluster identifier or replication group identifier"
  value       = local.is_redis ? aws_elasticache_replication_group.redis[0].id : aws_elasticache_cluster.memcached[0].id
}

output "engine" {
  description = "Cache engine type (redis or memcached)"
  value       = var.engine
}

output "engine_version" {
  description = "Cache engine version"
  value       = var.engine_version
}


# ============================================
# Endpoint Outputs
# ============================================

output "primary_endpoint_address" {
  description = "Primary endpoint address for the cache cluster"
  value       = local.is_redis ? aws_elasticache_replication_group.redis[0].primary_endpoint_address : aws_elasticache_cluster.memcached[0].configuration_endpoint
}

output "reader_endpoint_address" {
  description = "Reader endpoint address (Redis only, null for Memcached)"
  value       = local.is_redis ? aws_elasticache_replication_group.redis[0].reader_endpoint_address : null
}

output "port" {
  description = "Port number on which the cache accepts connections"
  value       = local.port_final
}


# ============================================
# Network Resource Outputs
# ============================================

output "security_group_id" {
  description = "ID of the security group created for ElastiCache"
  value       = aws_security_group.this.id
}

output "subnet_group_name" {
  description = "Name of the subnet group created for ElastiCache"
  value       = aws_elasticache_subnet_group.this.name
}
