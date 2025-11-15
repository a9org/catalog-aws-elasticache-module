# String Input Support Guide

## Problem

Some platforms or IDPs require all Terraform variables to be passed as strings, even for complex types like lists, maps, and objects. This causes type mismatch errors when the module expects native Terraform types.

## Solution

The module now supports **dual input modes**:

1. **Native Types** (default) - Use standard Terraform types
2. **JSON Strings** - Pass complex types as JSON strings

## How It Works

The module includes wrapper variables with `_json` suffix that accept JSON strings. Internally, the module:

1. Checks if a JSON string variable is provided (non-empty)
2. If yes, decodes the JSON string to the appropriate type
3. If no, uses the native variable
4. Uses the final decoded/native value throughout the module

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

### Option 2: JSON Strings (For IDPs)

```hcl
module "elasticache" {
  source = "path/to/module"

  vpc_id         = "vpc-123"
  vpc_cidr_block = "10.0.0.0/16"
  subnets_pvt_json = "[\"subnet-abc\",\"subnet-def\"]"
  
  tags_json = "{\"Project\":\"MyApp\",\"Team\":\"Platform\"}"
}
```

## Supported JSON Variables

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

1. **wrapper-variables.tf** - Defines `_json` suffix variables
2. **wrapper-locals.tf** - Removed (logic moved to locals.tf)
3. **locals.tf** - Updated with JSON decoding logic
4. **examples/string-input/** - Complete example

### Files Modified

1. **locals.tf** - Added JSON decoding with fallback to native variables
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
