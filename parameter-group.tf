# ============================================
# ElastiCache Parameter Group
# ============================================

resource "aws_elasticache_parameter_group" "this" {
  count = var.create_parameter_group ? 1 : 0

  name        = local.parameter_group_name
  family      = var.parameter_family
  description = "Custom parameter group for ${var.name_prefix}-${var.environment}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}
