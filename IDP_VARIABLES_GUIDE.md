# IDP Variables Guide

Complete guide for configuring the ElastiCache module through an IDP that reads `variables.tf`.

## Variable Types

All variables in `variables.tf` are clearly marked with their type in the description:

- **[STRING]** - Text value
- **[NUMBER]** - Numeric value
- **[BOOLEAN]** - True/false value (native)
- **[LIST]** - Array of values (native)
- **[MAP]** - Key-value pairs (native)

## IDP Limitations Support

If your IDP can **ONLY** pass strings and numbers, use the `_str` or `_json` suffix variables:

### Boolean Variables → String Variables

| Native Variable (BOOLEAN) | String Alternative | Example Values |
|--------------------------|-------------------|----------------|
| `cluster_mode_enabled` | `cluster_mode_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `automatic_failover_enabled` | `automatic_failover_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `multi_az_enabled` | `multi_az_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `transit_encryption_enabled` | `transit_encryption_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `at_rest_encryption_enabled` | `at_rest_encryption_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `data_tiering_enabled` | `data_tiering_enabled_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `auto_minor_version_upgrade` | `auto_minor_version_upgrade_str` | `"true"`, `"false"`, `"1"`, `"0"` |
| `create_parameter_group` | `create_parameter_group_str` | `"true"`, `"false"`, `"1"`, `"0"` |

### Number Variables → String Variables

| Native Variable (NUMBER) | String Alternative | Example Values |
|-------------------------|-------------------|----------------|
| `port` | `port_str` | `"6379"`, `"11211"` |
| `num_node_groups` | `num_node_groups_str` | `"1"`, `"3"`, `"5"` |
| `replicas_per_node_group` | `replicas_per_node_group_str` | `"0"`, `"1"`, `"2"` |
| `num_cache_nodes` | `num_cache_nodes_str` | `"1"`, `"3"`, `"5"` |
| `snapshot_retention_limit` | `snapshot_retention_limit_str` | `"0"`, `"7"`, `"30"` |

### Complex Type Variables → JSON String Variables

| Native Variable (LIST/MAP) | JSON String Alternative | Example Values |
|---------------------------|------------------------|----------------|
| `subnets_pvt` | `subnets_pvt_json` | `"[\"subnet-abc\",\"subnet-def\"]"` |
| `tags` | `tags_json` | `"{\"Project\":\"MyApp\",\"Team\":\"Platform\"}"` |
| `parameters` | `parameters_json` | `"[{\"name\":\"timeout\",\"value\":\"300\"}]"` |
| `ingress_cidr_blocks` | `ingress_cidr_blocks_json` | `"[\"10.0.0.0/16\"]"` |
| `ingress_rules` | `ingress_rules_json` | `"[{\"from_port\":6379,\"to_port\":6379,\"protocol\":\"tcp\",\"cidr_blocks\":[\"10.0.0.0/16\"],\"description\":\"Redis\"}]"` |
| `snapshot_arns` | `snapshot_arns_json` | `"[\"arn:aws:elasticache:...\"]"` |
| `cloudwatch_log_exports` | `cloudwatch_log_exports_json` | `"[\"slow-log\",\"engine-log\"]"` |
| `log_delivery_configuration` | `log_delivery_configuration_json` | `"[{\"destination\":\"/aws/elasticache\",\"destination_type\":\"cloudwatch-logs\",\"log_format\":\"json\",\"log_type\":\"slow-log\"}]"` |
| `preferred_availability_zones` | `preferred_availability_zones_json` | `"[\"us-east-1a\",\"us-east-1b\"]"` |
| `additional_security_group_ids` | `additional_security_group_ids_json` | `"[\"sg-123456\"]"` |

## Required Variables

### Minimum Configuration

```
vpc_id                = "vpc-12345678"
vpc_cidr_block        = "10.0.0.0/16"
subnets_pvt_json      = "[\"subnet-abc123\",\"subnet-def456\"]"
name_prefix           = "myapp"
environment           = "dev"
engine                = "redis"
engine_version        = "7.0"
node_type             = "cache.t3.micro"
parameter_family      = "redis7"
```

### With IDP String-Only Limitations

```
vpc_id                         = "vpc-12345678"
vpc_cidr_block                 = "10.0.0.0/16"
subnets_pvt_json               = "[\"subnet-abc123\",\"subnet-def456\"]"
name_prefix                    = "myapp"
environment                    = "prod"
engine                         = "redis"
engine_version                 = "7.0"
node_type                      = "cache.r6g.large"
parameter_family               = "redis7"
tags_json                      = "{\"Project\":\"MyApp\",\"Team\":\"Platform\"}"
multi_az_enabled_str           = "true"
automatic_failover_enabled_str = "true"
transit_encryption_enabled_str = "true"
at_rest_encryption_enabled_str = "true"
replicas_per_node_group_str    = "2"
snapshot_retention_limit_str   = "7"
```

## Variable Priority

When both native and string/JSON variables are provided:

1. **String/JSON variable is NOT empty** → Uses string/JSON variable (converted to proper type)
2. **String/JSON variable is empty** → Uses native variable
3. **Both empty** → Uses default value

Example:
```
# If IDP passes:
port = 6379
port_str = ""

# Module uses: port (6379)

# If IDP passes:
port = 6379
port_str = "6380"

# Module uses: port_str converted to number (6380)
```

## Validation Rules

### Boolean Strings

Accepted values (case-insensitive):
- `"true"`, `"True"`, `"TRUE"` → `true`
- `"false"`, `"False"`, `"FALSE"` → `false`
- `"1"` → `true`
- `"0"` → `false`

Invalid: `"yes"`, `"no"`, `"on"`, `"off"`, etc.

### Number Strings

Must be valid numbers:
- Valid: `"6379"`, `"0"`, `"100"`
- Invalid: `"abc"`, `"6379.5"` (for integers)

### JSON Strings

Must be valid JSON syntax:
- Valid: `"[\"item1\",\"item2\"]"`, `"{\"key\":\"value\"}"`
- Invalid: `"[item1, item2]"` (missing quotes), `"{'key':'value'}"` (single quotes)

## Common Configurations

### Redis with High Availability

```
engine                         = "redis"
engine_version                 = "7.0"
node_type                      = "cache.r6g.large"
parameter_family               = "redis7"
subnets_pvt_json               = "[\"subnet-1\",\"subnet-2\",\"subnet-3\"]"
multi_az_enabled_str           = "true"
automatic_failover_enabled_str = "true"
replicas_per_node_group_str    = "2"
transit_encryption_enabled_str = "true"
at_rest_encryption_enabled_str = "true"
snapshot_retention_limit_str   = "7"
```

### Redis Cluster Mode

```
engine                         = "redis"
engine_version                 = "7.0"
node_type                      = "cache.r6g.xlarge"
parameter_family               = "redis7"
subnets_pvt_json               = "[\"subnet-1\",\"subnet-2\",\"subnet-3\"]"
cluster_mode_enabled_str       = "true"
num_node_groups_str            = "3"
replicas_per_node_group_str    = "2"
automatic_failover_enabled_str = "true"
transit_encryption_enabled_str = "true"
```

### Memcached Cluster

```
engine               = "memcached"
engine_version       = "1.6.17"
node_type            = "cache.t3.micro"
parameter_family     = "memcached1.6"
subnets_pvt_json     = "[\"subnet-1\",\"subnet-2\"]"
num_cache_nodes_str  = "3"
```

## IDP Integration Example

### JSON Configuration for IDP

```json
{
  "vpc_id": "vpc-12345678",
  "vpc_cidr_block": "10.0.0.0/16",
  "subnets_pvt_json": "[\"subnet-abc\",\"subnet-def\"]",
  "name_prefix": "myapp",
  "environment": "prod",
  "engine": "redis",
  "engine_version": "7.0",
  "node_type": "cache.r6g.large",
  "parameter_family": "redis7",
  "tags_json": "{\"Project\":\"MyApp\",\"Team\":\"Platform\"}",
  "multi_az_enabled_str": "true",
  "automatic_failover_enabled_str": "true",
  "transit_encryption_enabled_str": "true",
  "at_rest_encryption_enabled_str": "true",
  "replicas_per_node_group_str": "2",
  "port_str": "6379",
  "snapshot_retention_limit_str": "7",
  "snapshot_window": "03:00-05:00",
  "maintenance_window": "sun:05:00-sun:07:00"
}
```

## Troubleshooting

### Error: "Invalid value for input variable"

**Cause**: Wrong type or format

**Solution**: Check variable description in `variables.tf` for expected type and format

### Error: "Must be 'true', 'false', '1', '0'"

**Cause**: Invalid boolean string value

**Solution**: Use only `"true"`, `"false"`, `"1"`, or `"0"` for `_str` boolean variables

### Error: "Invalid JSON syntax"

**Cause**: Malformed JSON in `_json` variable

**Solution**: 
- Use double quotes, not single quotes
- Escape quotes properly: `\"` 
- Validate JSON syntax before passing

### Variables Not Taking Effect

**Cause**: Both native and string/JSON variables provided

**Solution**: 
- String/JSON variables take precedence when non-empty
- Set string/JSON variable to empty string `""` to use native variable

## Best Practices

1. **Use Native Types When Possible**: More readable and validated by Terraform
2. **Use String/JSON Only When Required**: When IDP cannot pass native types
3. **Validate JSON**: Use a JSON validator before deploying
4. **Document Format**: Add comments in IDP configuration showing expected format
5. **Test Conversions**: Verify string values convert correctly to expected types

## Support

For issues or questions:
1. Check variable description in `variables.tf`
2. Verify value format matches expected type
3. Review [STRING_INPUT_GUIDE.md](STRING_INPUT_GUIDE.md)
4. See [examples/idp-string-only/](examples/idp-string-only/)
