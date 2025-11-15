locals {
  # Engine type detection
  is_redis     = var.engine == "redis"
  is_memcached = var.engine == "memcached"

  # Resource naming conventions
  cluster_id           = "${var.name_prefix}-${var.environment}"
  replication_group_id = "${var.name_prefix}-${var.environment}"
  subnet_group_name    = "${var.name_prefix}-${var.environment}-subnet-group"
  security_group_name  = coalesce(var.security_group_name, "${var.name_prefix}-${var.environment}-sg")
  parameter_group_name = var.create_parameter_group ? "${var.name_prefix}-${var.environment}-params" : var.parameter_family

  # Default network configuration
  default_ingress_cidr = length(var.ingress_cidr_blocks) > 0 ? var.ingress_cidr_blocks : [var.vpc_cidr_block]

  # Merged tags
  common_tags = merge(
    {
      Name        = "${var.name_prefix}-${var.environment}"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
