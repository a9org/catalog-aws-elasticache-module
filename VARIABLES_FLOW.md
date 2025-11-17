# Variables Flow - What Resources Actually Read

This document explains which variables the AWS resources actually use when they are created.

## How It Works

The module uses a **two-step process**:

1. **Input Variables** → You provide values (native types OR strings)
2. **Local Variables** (`_final` suffix) → Module converts and normalizes
3. **AWS Resources** → Read the `_final` local variables

## Variable Flow Diagram

```
User Input                    Module Processing              AWS Resources
─────────────────────────────────────────────────────────────────────────────

port = 6379                   port_final                     aws_elasticache_*
  OR                    →     = 6379                    →    port = port_final
port_str = "6379"

multi_az_enabled = true       multi_az_enabled_final         aws_elasticache_replication_group
  OR                    →     = true                    →    multi_az_enabled = multi_az_enabled_final
multi_az_enabled_str = "true"

subnets_pvt = ["subnet-1"]    subnets_pvt_final             aws_elasticache_subnet_group
  OR                    →     = ["subnet-1"]           →    subnet_ids = subnets_pvt_final
subnets_pvt_json = "[...]"

tags = {Project = "App"}      tags_final                     All resources
  OR                    →     = {Project = "App"}      →    tags = common_tags
tags_json = "{...}"                                          (includes tags_final)
```

## Variables Read by Each Resource

### 1. aws_elasticache_replication_group (Redis)

**Direct Variables:**
- `var.engine_version`
- `var.node_type`
- `var.description`
- `var.auth_token`
- `var.kms_key_id`
- `var.snapshot_window`
- `var.final_snapshot_identifier`
- `var.maintenance_window`
- `var.notification_topic_arn`

**Converted Variables (_final):**
- `local.port_final` (from `port` OR `port_str`)
- `local.cluster_mode_enabled_final` (from `cluster_mode_enabled` OR `cluster_mode_enabled_str`)
- `local.num_node_groups_final` (from `num_node_groups` OR `num_node_groups_str`)
- `local.replicas_per_node_group_final` (from `replicas_per_node_group` OR `replicas_per_node_group_str`)
- `local.automatic_failover_enabled_final` (from `automatic_failover_enabled` OR `automatic_failover_enabled_str`)
- `local.multi_az_enabled_final` (from `multi_az_enabled` OR `multi_az_enabled_str`)
- `local.transit_encryption_enabled_final` (from `transit_encryption_enabled` OR `transit_encryption_enabled_str`)
- `local.at_rest_encryption_enabled_final` (from `at_rest_encryption_enabled` OR `at_rest_encryption_enabled_str`)
- `local.data_tiering_enabled_final` (from `data_tiering_enabled` OR `data_tiering_enabled_str`)
- `local.snapshot_retention_limit_final` (from `snapshot_retention_limit` OR `snapshot_retention_limit_str`)
- `local.auto_minor_version_upgrade_final` (from `auto_minor_version_upgrade` OR `auto_minor_version_upgrade_str`)
- `local.snapshot_arns_final` (from `snapshot_arns` OR `snapshot_arns_json`)
- `local.log_delivery_configuration_final` (from `log_delivery_configuration` OR `log_delivery_configuration_json`)
- `local.preferred_availability_zones_final` (from `preferred_availability_zones` OR `preferred_availability_zones_json`)
- `local.additional_security_group_ids_final` (from `additional_security_group_ids` OR `additional_security_group_ids_json`)

**Computed Variables:**
- `local.replication_group_id` (from `name_prefix` + `environment`)
- `local.parameter_group_name` (from `create_parameter_group_final` + `name_prefix` + `environment` OR `parameter_family`)
- `local.common_tags` (from `tags_final` + default tags)

**Resource References:**
- `aws_elasticache_subnet_group.this.name`
- `aws_security_group.this.id`

---

### 2. aws_elasticache_cluster (Memcached)

**Direct Variables:**
- `var.engine_version`
- `var.node_type`
- `var.maintenance_window`
- `var.notification_topic_arn`

**Converted Variables (_final):**
- `local.port_final` (from `port` OR `port_str`)
- `local.num_cache_nodes_final` (from `num_cache_nodes` OR `num_cache_nodes_str`)
- `local.auto_minor_version_upgrade_final` (from `auto_minor_version_upgrade` OR `auto_minor_version_upgrade_str`)
- `local.preferred_availability_zones_final` (from `preferred_availability_zones` OR `preferred_availability_zones_json`)
- `local.additional_security_group_ids_final` (from `additional_security_group_ids` OR `additional_security_group_ids_json`)

**Computed Variables:**
- `local.cluster_id` (from `name_prefix` + `environment`)
- `local.parameter_group_name` (from `create_parameter_group_final` + `name_prefix` + `environment` OR `parameter_family`)
- `local.common_tags` (from `tags_final` + default tags)

**Resource References:**
- `aws_elasticache_subnet_group.this.name`
- `aws_security_group.this.id`

---

### 3. aws_elasticache_subnet_group

**Converted Variables (_final):**
- `local.subnets_pvt_final` (from `subnets_pvt` OR `subnets_pvt_json`)

**Computed Variables:**
- `local.subnet_group_name` (from `name_prefix` + `environment`)
- `local.common_tags` (from `tags_final` + default tags)

**Direct Variables:**
- `var.name_prefix`
- `var.environment`

---

### 4. aws_security_group

**Direct Variables:**
- `var.vpc_id`
- `var.security_group_description`

**Computed Variables:**
- `local.security_group_name` (from `security_group_name` OR auto-generated from `name_prefix` + `environment`)
- `local.common_tags` (from `tags_final` + default tags)

---

### 5. aws_security_group_rule (default_ingress)

**Converted Variables (_final):**
- `local.port_final` (from `port` OR `port_str`)

**Computed Variables:**
- `local.default_ingress_cidr` (from `ingress_cidr_blocks_final` OR `vpc_cidr_block`)
- `local.is_redis` (from `engine`)

**Resource References:**
- `aws_security_group.this.id`

---

### 6. aws_security_group_rule (custom_ingress)

**Converted Variables (_final):**
- `local.ingress_rules_final` (from `ingress_rules` OR `ingress_rules_json`)

**Resource References:**
- `aws_security_group.this.id`

---

### 7. aws_elasticache_parameter_group

**Direct Variables:**
- `var.parameter_family`

**Converted Variables (_final):**
- `local.create_parameter_group_final` (from `create_parameter_group` OR `create_parameter_group_str`)
- `local.parameters_final` (from `parameters` OR `parameters_json`)

**Computed Variables:**
- `local.parameter_group_name` (from `name_prefix` + `environment`)
- `local.common_tags` (from `tags_final` + default tags)

**Direct Variables:**
- `var.name_prefix`
- `var.environment`

---

## Summary: Which Variables Matter?

### Always Required (No Alternatives)
These variables are always read directly:
- `vpc_id`
- `vpc_cidr_block`
- `name_prefix`
- `environment`
- `engine`
- `engine_version`
- `node_type`
- `parameter_family`
- `description`
- `auth_token` (if using Redis AUTH)
- `kms_key_id` (if using encryption)
- `snapshot_window`
- `maintenance_window`
- `final_snapshot_identifier`
- `notification_topic_arn`
- `security_group_name`
- `security_group_description`

### Flexible Input (Native OR String/JSON)
These variables have alternatives - resources read the `_final` version:

**Boolean Variables:**
- `cluster_mode_enabled` OR `cluster_mode_enabled_str` → `cluster_mode_enabled_final`
- `automatic_failover_enabled` OR `automatic_failover_enabled_str` → `automatic_failover_enabled_final`
- `multi_az_enabled` OR `multi_az_enabled_str` → `multi_az_enabled_final`
- `transit_encryption_enabled` OR `transit_encryption_enabled_str` → `transit_encryption_enabled_final`
- `at_rest_encryption_enabled` OR `at_rest_encryption_enabled_str` → `at_rest_encryption_enabled_final`
- `data_tiering_enabled` OR `data_tiering_enabled_str` → `data_tiering_enabled_final`
- `auto_minor_version_upgrade` OR `auto_minor_version_upgrade_str` → `auto_minor_version_upgrade_final`
- `create_parameter_group` OR `create_parameter_group_str` → `create_parameter_group_final`

**Number Variables:**
- `port` OR `port_str` → `port_final`
- `num_node_groups` OR `num_node_groups_str` → `num_node_groups_final`
- `replicas_per_node_group` OR `replicas_per_node_group_str` → `replicas_per_node_group_final`
- `num_cache_nodes` OR `num_cache_nodes_str` → `num_cache_nodes_final`
- `snapshot_retention_limit` OR `snapshot_retention_limit_str` → `snapshot_retention_limit_final`

**Complex Type Variables:**
- `subnets_pvt` OR `subnets_pvt_json` → `subnets_pvt_final`
- `tags` OR `tags_json` → `tags_final`
- `parameters` OR `parameters_json` → `parameters_final`
- `ingress_cidr_blocks` OR `ingress_cidr_blocks_json` → `ingress_cidr_blocks_final`
- `ingress_rules` OR `ingress_rules_json` → `ingress_rules_final`
- `snapshot_arns` OR `snapshot_arns_json` → `snapshot_arns_final`
- `cloudwatch_log_exports` OR `cloudwatch_log_exports_json` → `cloudwatch_log_exports_final`
- `log_delivery_configuration` OR `log_delivery_configuration_json` → `log_delivery_configuration_final`
- `preferred_availability_zones` OR `preferred_availability_zones_json` → `preferred_availability_zones_final`
- `additional_security_group_ids` OR `additional_security_group_ids_json` → `additional_security_group_ids_final`

## Key Takeaway

**For IDP Integration:**
- If your IDP can pass native types (boolean, number, list, map) → Use the base variables
- If your IDP can ONLY pass strings → Use the `_str` or `_json` suffix variables
- The module automatically handles the conversion in `locals.tf`
- AWS resources always read the normalized `_final` values from locals

**Priority:**
1. If `_str` or `_json` variable is NOT empty → Use it (converted)
2. If `_str` or `_json` variable is empty → Use base variable
3. If both empty → Use default value
