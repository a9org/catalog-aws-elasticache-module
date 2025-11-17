# ElastiCache Module - IDP Dual Input System Fix

## Problem
The module was receiving "Unsupported argument" errors when called by an IDP:
- `An argument named "port_str" is not expected here`
- `An argument named "tags_json" is not expected here`
- And similar errors for all `_str` and `_json` suffixed variables

## Root Cause
The IDP was trying to pass variables with `_str` and `_json` suffixes (like `port_str`, `tags_json`, etc.), but these variables were missing from `variables.tf`. The module was designed to support a dual-input system where IDPs that can only pass strings/numbers could use suffixed alternatives, but the suffixed variable definitions were not present.

## Solution
Restored the complete dual-input system by:

1. **Created `variables-dual-input.tf`** - Added all missing suffixed variables:
   - Boolean string alternatives: `*_str` (e.g., `cluster_mode_enabled_str`)
   - Number string alternatives: `*_str` (e.g., `port_str`)
   - Complex type JSON alternatives: `*_json` (e.g., `tags_json`, `subnets_pvt_json`)

2. **Updated `locals.tf`** - Implemented proper priority logic:
   ```hcl
   # Priority: _str/_json suffix → base variable → default
   cluster_mode_enabled_final = var.cluster_mode_enabled_str != "" ? 
     contains(["true", "1"], lower(var.cluster_mode_enabled_str)) : 
     (var.cluster_mode_enabled != "" ? contains(["true", "1"], lower(var.cluster_mode_enabled)) : false)
   ```

3. **Updated `outputs.tf`** - Fixed to use `local.port_final` instead of `var.port`

## How the Dual Input System Works

The module now accepts inputs in TWO ways:

### Option 1: Native Types (Preferred)
```hcl
module "elasticache" {
  port                     = 6379
  multi_az_enabled         = true
  subnets_pvt              = ["subnet-1", "subnet-2"]
  tags                     = {Project = "MyApp"}
}
```

### Option 2: String/JSON Alternatives (For IDP Limitations)
```hcl
module "elasticache" {
  port_str                 = "6379"
  multi_az_enabled_str     = "true"
  subnets_pvt_json         = "[\"subnet-1\",\"subnet-2\"]"
  tags_json                = "{\"Project\":\"MyApp\"}"
}
```

## Variable Priority

When both versions are provided:
1. **Suffixed variable is NOT empty** → Uses suffixed variable (converted)
2. **Suffixed variable is empty** → Uses base variable
3. **Both empty** → Uses default value

## Supported Conversions

### Boolean Strings (`_str` suffix)
- Accepts: `"true"`, `"false"`, `"1"`, `"0"` (case-insensitive)
- Variables: `cluster_mode_enabled_str`, `automatic_failover_enabled_str`, `multi_az_enabled_str`, etc.

### Number Strings (`_str` suffix)
- Accepts: Numeric strings like `"6379"`, `"3"`, `"7"`
- Variables: `port_str`, `num_node_groups_str`, `replicas_per_node_group_str`, etc.

### Complex Types (`_json` suffix)
- Accepts: Valid JSON strings
- Variables: `tags_json`, `subnets_pvt_json`, `parameters_json`, `ingress_rules_json`, etc.

## Files Modified

1. **variables-dual-input.tf** (NEW) - All suffixed variable definitions
2. **locals.tf** - Updated conversion logic with proper priority
3. **outputs.tf** - Fixed port output to use local value

## Testing
The module now accepts both native types and string alternatives. IDPs can use whichever format they support.
