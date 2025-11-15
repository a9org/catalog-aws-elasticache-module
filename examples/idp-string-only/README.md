# IDP String-Only Input Example

This example demonstrates how to use the ElastiCache module when your IDP can **ONLY** pass strings and numbers - no booleans, lists, or objects.

## Problem

Some IDPs have limitations where:
- All variables must be strings or numbers
- Cannot pass boolean values (`true`/`false`)
- Cannot pass lists or objects directly
- Cannot pass complex data structures

## Solution

The module supports converting:
- **Booleans as strings**: `"true"`, `"false"`, `"1"`, `"0"`
- **Numbers as strings**: `"6379"`, `"3"`, `"7"`
- **Lists/Objects as JSON strings**: `"[\"item1\",\"item2\"]"`, `"{\"key\":\"value\"}"`

## Usage

### 1. Copy Example Configuration

```bash
cp terraform.tfvars.example terraform.tfvars
```

### 2. Update Variables

```hcl
# Standard strings
vpc_id         = "vpc-12345678"
vpc_cidr_block = "10.0.0.0/16"

# Booleans as strings
cluster_mode_enabled_str = "false"
multi_az_enabled_str     = "true"

# Numbers as strings
port_str                    = "6379"
replicas_per_node_group_str = "2"

# Lists as JSON strings
subnets_pvt_json = "[\"subnet-abc\",\"subnet-def\"]"
tags_json        = "{\"Project\":\"MyApp\"}"
```

### 3. Apply

```bash
terraform init
terraform plan
terraform apply
```

## Variable Mapping

### Boolean Variables

| Native Variable | String Variable | Accepted Values |
|----------------|-----------------|-----------------|
| `cluster_mode_enabled` | `cluster_mode_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `automatic_failover_enabled` | `automatic_failover_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `multi_az_enabled` | `multi_az_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `transit_encryption_enabled` | `transit_encryption_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `at_rest_encryption_enabled` | `at_rest_encryption_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `data_tiering_enabled` | `data_tiering_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `auto_minor_version_upgrade` | `auto_minor_version_upgrade_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `create_parameter_group` | `create_parameter_group_str` | `"true"`, `"false"`, `"1"`, `"0"` |

### Number Variables

| Native Variable | String Variable | Example |
|----------------|-----------------|---------|
| `port` | `port_str` | `"6379"` |
| `num_node_groups` | `num_node_groups_str` | `"3"` |
| `replicas_per_node_group` | `replicas_per_node_group_str` | `"2"` |
| `num_cache_nodes` | `num_cache_nodes_str` | `"3"` |
| `snapshot_retention_limit` | `snapshot_retention_limit_str` | `"7"` |

### Complex Type Variables

| Native Variable | String Variable | Example |
|----------------|-----------------|---------|
| `subnets_pvt` | `subnets_pvt_json` | `"[\"subnet-1\",\"subnet-2\"]"` |
| `tags` | `tags_json` | `"{\"Project\":\"MyApp\"}"` |
| `parameters` | `parameters_json` | `"[{\"name\":\"timeout\",\"value\":\"300\"}]"` |

## Boolean String Formats

The module accepts multiple formats for boolean strings:

```hcl
# All of these mean TRUE
cluster_mode_enabled_str = "true"
cluster_mode_enabled_str = "True"
cluster_mode_enabled_str = "TRUE"
cluster_mode_enabled_str = "1"

# All of these mean FALSE
cluster_mode_enabled_str = "false"
cluster_mode_enabled_str = "False"
cluster_mode_enabled_str = "FALSE"
cluster_mode_enabled_str = "0"
```

## Complete Example

### IDP Configuration (JSON)

```json
{
  "vpc_id": "vpc-12345678",
  "vpc_cidr_block": "10.0.0.0/16",
  "name_prefix": "myapp",
  "environment": "prod",
  "engine": "redis",
  "engine_version": "7.0",
  "node_type": "cache.r6g.large",
  "parameter_family": "redis7",
  "subnets_pvt_json": "[\"subnet-abc\",\"subnet-def\",\"subnet-ghi\"]",
  "tags_json": "{\"Project\":\"MyApp\",\"Team\":\"Platform\"}",
  "cluster_mode_enabled_str": "false",
  "automatic_failover_enabled_str": "true",
  "multi_az_enabled_str": "true",
  "transit_encryption_enabled_str": "true",
  "at_rest_encryption_enabled_str": "true",
  "port_str": "6379",
  "replicas_per_node_group_str": "2",
  "snapshot_retention_limit_str": "7"
}
```

### Terraform Variables

```hcl
vpc_id         = "vpc-12345678"
vpc_cidr_block = "10.0.0.0/16"

# Booleans as strings
automatic_failover_enabled_str = "true"
multi_az_enabled_str           = "true"
transit_encryption_enabled_str = "true"

# Numbers as strings
replicas_per_node_group_str = "2"

# Complex types as JSON
subnets_pvt_json = "[\"subnet-abc\",\"subnet-def\"]"
tags_json        = "{\"Project\":\"MyApp\"}"
```

## Validation

The module validates:

1. **Boolean strings**: Must be `"true"`, `"false"`, `"1"`, or `"0"`
2. **Number strings**: Must be valid numbers
3. **JSON strings**: Must be valid JSON syntax

### Invalid Examples

```hcl
# WRONG - Invalid boolean
cluster_mode_enabled_str = "yes"  # Error: must be true/false/1/0

# WRONG - Invalid number
port_str = "abc"  # Error: must be a valid number

# WRONG - Invalid JSON
subnets_pvt_json = "[subnet-1, subnet-2]"  # Error: missing quotes
```

### Correct Examples

```hcl
# CORRECT
cluster_mode_enabled_str = "true"
port_str = "6379"
subnets_pvt_json = "[\"subnet-1\",\"subnet-2\"]"
```

## Advantages

1. **IDP Compatible**: Works with platforms that only support strings/numbers
2. **Type Safe**: Automatic conversion with validation
3. **Flexible**: Accepts multiple boolean formats
4. **Clear Errors**: Validation catches issues early

## Limitations

1. **Less Readable**: String booleans less clear than native booleans
2. **More Verbose**: Requires `_str` or `_json` suffix
3. **JSON Syntax**: Must use valid JSON for complex types

## Migration from Native Types

```hcl
# Before (native types)
cluster_mode_enabled = true
port = 6379
subnets_pvt = ["subnet-1", "subnet-2"]

# After (string types)
cluster_mode_enabled_str = "true"
port_str = "6379"
subnets_pvt_json = "[\"subnet-1\",\"subnet-2\"]"
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Outputs

See [outputs.tf](outputs.tf) for all available outputs.

## Support

For issues or questions:
1. Check variable format (strings for booleans, JSON for complex types)
2. Validate JSON syntax
3. Review error messages
4. See [STRING_INPUT_GUIDE.md](../../STRING_INPUT_GUIDE.md)
