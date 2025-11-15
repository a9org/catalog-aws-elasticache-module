# ============================================
# Wrapper Locals for Type Conversion
# ============================================
# Convert string inputs to appropriate types

locals {
  # Decode JSON strings to proper types
  tags_decoded                         = try(jsondecode(var.tags_json), {})
  parameters_decoded                   = try(jsondecode(var.parameters_json), [])
  subnets_pvt_decoded                  = try(jsondecode(var.subnets_pvt_json), [])
  ingress_rules_decoded                = try(jsondecode(var.ingress_rules_json), [])
  snapshot_arns_decoded                = try(jsondecode(var.snapshot_arns_json), null)
  ingress_cidr_blocks_decoded          = try(jsondecode(var.ingress_cidr_blocks_json), null)
  cloudwatch_log_exports_decoded       = try(jsondecode(var.cloudwatch_log_exports_json), [])
  log_delivery_configuration_decoded   = try(jsondecode(var.log_delivery_configuration_json), [])
  preferred_availability_zones_decoded = try(jsondecode(var.preferred_availability_zones_json), null)
  additional_security_group_ids_decoded = try(jsondecode(var.additional_security_group_ids_json), [])
}
