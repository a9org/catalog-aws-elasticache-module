# ============================================
# Security Group for ElastiCache
# ============================================

resource "aws_security_group" "this" {
  name        = local.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.security_group_name
    }
  )
}


# ============================================
# Default Ingress Rule - VPC CIDR Access
# ============================================

resource "aws_security_group_rule" "default_ingress" {
  type              = "ingress"
  from_port         = coalesce(var.port, local.is_redis ? 6379 : 11211)
  to_port           = coalesce(var.port, local.is_redis ? 6379 : 11211)
  protocol          = "tcp"
  cidr_blocks       = local.default_ingress_cidr
  description       = "Allow access from VPC CIDR"
  security_group_id = aws_security_group.this.id
}


# ============================================
# Custom Ingress Rules
# ============================================

resource "aws_security_group_rule" "custom_ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  security_group_id = aws_security_group.this.id
}


# ============================================
# Egress Rule - Allow All Outbound
# ============================================

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.this.id
}
