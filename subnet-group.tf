# ============================================
# ElastiCache Subnet Group
# ============================================

resource "aws_elasticache_subnet_group" "this" {
  name        = local.subnet_group_name
  description = "Subnet group for ${var.name_prefix}-${var.environment} ElastiCache cluster"
  subnet_ids  = var.subnets_pvt

  tags = local.common_tags
}
