# String Input Support Guide

## Problem

Some platforms or IDPs require all Terraform variables to be passed as strings, even for complex types like lists, maps, and objects. This causes type mismatch errors when the module expects native Terraform types.

## Solution

The module now supports **dual input modes**:

1. **Native Types** (default) - Use standard Terraform types
2. **String Variables** - Pass booleans and numbers as strings with `_str` suffix
3. **JSON Strings** - Pass complex types as JSON strings with `_json` suffix

## How It Works

The module includes two types of wrapper variables:

### String Variables (`_str` suffix)
For booleans and numbers that IDPs pass as strings:
- Accepts string representations: `"true"`, `"false"`, `"1"`, `"0"` for booleans
- Accepts numeric strings: `"6379"`, `"3"`, `"7"` for numbers
- Includes validation to ensure correct format
- Automatically converts to appropriate type internally

### JSON String Variables (`_json` suffix)
For complex types like lists and maps:
- Accepts valid JSON strings
- Decodes JSON to appropriate Terraform type
- Falls back to native variable if empty

Internally, the module:
1. Checks if a string/JSON variable is provided (non-empty)
2. If yes, converts/decodes the string to the appropriate type
3. If no, uses the native variable
4. Uses the final converted/native value throughout the module

## Usage

### Option 1: Native Types (Standard)

```hcl
module "elasticache" {
  source = "path/to/module"

  vpc_id         = "vpc-123"
  vpc_cidr_block = "10.0.0.0/16"
  subnets_pvt    = ["subnet-abc", "subnet-def"]
  
  tags = {
    Project = "MyApp"
    Team    = "Platform"
  }
}
```

### Option 2: String Variables (For IDPs - Booleans and Numbers)

```hcl
module "elasticache" {
  source = "path/to/module"

  vpc_id         = "vpc-123"
  vpc_cidr_block = "10.0.0.0/16"
  
  # Booleans as strings
  multi_az_enabled_str           = "true"
  transit_encryption_enabled_str = "true"
  
  # Numbers as strings
  port_str                    = "6379"
  replicas_per_node_group_str = "2"
  
  # Complex types still need JSON
  subnets_pvt_json = "[\"subnet-abc\",\"subnet-def\"]"
  tags_json        = "{\"Project\":\"MyApp\",\"Team\":\"Platform\"}"
}
```

## Supported String Variables

### Boolean Variables (as strings)

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

### Number Variables (as strings)

| Native Variable | String Variable | Example |
|----------------|-----------------|---------|
| `port` | `port_str` | `"6379"` |
| `num_node_groups` | `num_node_groups_str` | `"3"` |
| `replicas_per_node_group` | `replicas_per_node_group_str` | `"2"` |
| `num_cache_nodes` | `num_cache_nodes_str` | `"3"` |
| `snapshot_retention_limit` | `snapshot_retention_limit_str` | `"7"` |

### Complex Type Variables (as JSON strings)

| Native Variable | JSON String Variable | Type |
|----------------|---------------------|------|
| `tags` | `tags_json` | `map(string)` |
| `parameters` | `parameters_json` | `list(object)` |
| `subnets_pvt` | `subnets_pvt_json` | `list(string)` |
| `ingress_rules` | `ingress_rules_json` | `list(object)` |
| `snapshot_arns` | `snapshot_arns_json` | `list(string)` |
| `ingress_cidr_blocks` | `ingress_cidr_blocks_json` | `list(string)` |
| `cloudwatch_log_exports` | `cloudwatch_log_exports_json` | `list(string)` |
| `log_delivery_configuration` | `log_delivery_configuration_json` | `list(object)` |
| `preferred_availability_zones` | `preferred_availability_zones_json` | `list(string)` |
| `additional_security_group_ids` | `additional_security_group_ids_json` | `list(string)` |

## String Format Examples

### Boolean Values as Strings

```hcl
# All of these mean TRUE
cluster_mode_enabled_str = "true"
cluster_mode_enabled_str = "True"  # Case insensitive
cluster_mode_enabled_str = "1"

# All of these mean FALSE
cluster_mode_enabled_str = "false"
cluster_mode_enabled_str = "False"  # Case insensitive
cluster_mode_enabled_str = "0"
```

### Number Values as Strings

```hcl
port_str = "6379"
num_node_groups_str = "3"
replicas_per_node_group_str = "2"
snapshot_retention_limit_str = "7"
```

## JSON Format Examples

### Lists of Strings

```hcl
subnets_pvt_json = "[\"subnet-123\",\"subnet-456\",\"subnet-789\"]"
ingress_cidr_blocks_json = "[\"10.0.0.0/16\",\"172.16.0.0/12\"]"
```

### Maps

```hcl
tags_json = "{\"Project\":\"MyApp\",\"Team\":\"Platform\",\"Environment\":\"prod\"}"
```

### Lists of Objects

```hcl
# Parameters
parameters_json = "[{\"name\":\"maxmemory-policy\",\"value\":\"allkeys-lru\"},{\"name\":\"timeout\",\"value\":\"300\"}]"

# Ingress Rules
ingress_rules_json = "[{\"from_port\":6379,\"to_port\":6379,\"protocol\":\"tcp\",\"cidr_blocks\":[\"10.0.0.0/16\"],\"description\":\"Redis access\"}]"
```

### Null Values

For optional variables that should remain null:

```hcl
snapshot_arns_json = "null"
# Or simply omit the variable (defaults to empty string, which uses native variable)
```

## Implementation Details

### Files Added

1. **idp-variables.tf** - Defines `_str` suffix variables for booleans and numbers
2. **wrapper-variables.tf** - Defines `_json` suffix variables for complex types
3. **examples/idp-string-only/** - Complete example for IDP integration
4. **examples/string-input/** - Complete example for JSON string inputs

### Files Modified

1. **locals.tf** - Added string-to-boolean/number conversion and JSON decoding logic
2. **main.tf** - Updated to use `_final` local variables
3. **subnet-group.tf** - Updated to use `_final` local variables
4. **security-group.tf** - Updated to use `_final` local variables
5. **parameter-group.tf** - Updated to use `_final` local variables

## Validation

The module validates:

1. **JSON Syntax** - Invalid JSON will cause clear error
2. **Type Matching** - Decoded JSON must match expected type
3. **Terraform Validations** - All existing validations still apply

## Error Handling

### Invalid JSON

```hcl
# This will fail
subnets_pvt_json = "[subnet-123, subnet-456]"  # Missing quotes

# Error: Invalid JSON syntax
```

### Type Mismatch

```hcl
# This will fail
tags_json = "[\"tag1\",\"tag2\"]"  # Array instead of object

# Error: Expected map(string), got list(string)
```

## Best Practices

1. **Use Native Types When Possible** - More readable and IDE-friendly
2. **Use JSON Strings for IDP Integration** - When platform requires it
3. **Validate JSON** - Use a JSON validator before applying
4. **Escape Properly** - Use double quotes in JSON, escape as needed
5. **Document Format** - Add comments showing expected JSON structure

## Migration Guide

### From Native to JSON Strings

```hcl
# Before (native)
subnets_pvt = ["subnet-abc", "subnet-def"]
tags = {
  Project = "MyApp"
}

# After (JSON strings)
subnets_pvt_json = "[\"subnet-abc\",\"subnet-def\"]"
tags_json = "{\"Project\":\"MyApp\"}"
```

### From JSON Strings to Native

```hcl
# Before (JSON strings)
subnets_pvt_json = "[\"subnet-abc\",\"subnet-def\"]"
tags_json = "{\"Project\":\"MyApp\"}"

# After (native)
subnets_pvt = ["subnet-abc", "subnet-def"]
tags = {
  Project = "MyApp"
}
```

## Complete Example

See [examples/string-input/](examples/string-input/) for a complete working example with:

- All JSON string variables
- terraform.tfvars.example
- Detailed README
- API integration example

## Troubleshooting

### Error: "Invalid value for input variable"

**Cause**: Type mismatch between provided value and expected type

**Solution**: 
- Check if you're mixing native and JSON variables
- Ensure JSON syntax is valid
- Verify JSON structure matches expected type

### Error: "Invalid JSON syntax"

**Cause**: Malformed JSON string

**Solution**:
- Use a JSON validator
- Check for missing quotes, commas, brackets
- Ensure proper escaping

### Variables Not Being Used

**Cause**: Both native and JSON variables provided

**Solution**:
- JSON variables take precedence when non-empty
- Use either native OR JSON, not both
- Set JSON variable to empty string to use native

## Support

For issues or questions:
1. Check [examples/string-input/README.md](examples/string-input/README.md)
2. Validate JSON syntax
3. Review error messages carefully
4. Open an issue with example configuration
