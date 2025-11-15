# ============================================
# String Input Example Outputs
# ============================================

output "cluster_id" {
  description = "ElastiCache cluster identifier"
  value       = module.redis_cache.cluster_id
}

output "primary_endpoint_address" {
  description = "Primary endpoint address"
  value       = module.redis_cache.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint address"
  value       = module.redis_cache.reader_endpoint_address
}

output "port" {
  description = "Port number"
  value       = module.redis_cache.port
}

output "security_group_id" {
  description = "Security group ID"
  value       = module.redis_cache.security_group_id
}

output "subnet_group_name" {
  description = "Subnet group name"
  value       = module.redis_cache.subnet_group_name
}
