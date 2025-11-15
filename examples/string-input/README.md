# String Input Example

This example demonstrates how to use the ElastiCache module when all complex inputs (lists, maps, objects) must be provided as JSON strings. This is useful when integrating with IDPs, APIs, or other systems that only support string inputs.

## Overview

Some platforms or integration layers require all Terraform variables to be passed as strings. This example shows how to:

1. Pass complex data structures as JSON strings
2. Have the module automatically convert them to the correct types
3. Maintain type safety and validation

## Usage

### 1. Copy the Example Configuration

```bash
cp terraform.tfvars.example terraform.tfvars
```

### 2. Update Variables

Edit `terraform.tfvars` with your values:

```hcl
vpc_id         = "vpc-12345678"
vpc_cidr_block = "10.0.0.0/16"

# Subnets as JSON string
subnets_pvt_json = "[\"subnet-abc123\",\"subnet-def456\"]"

# Tags as JSON string
tags_json = "{\"Project\":\"MyApp\",\"Team\":\"Platform\"}"
```

### 3. Apply

```bash
terraform init
terraform plan
terraform apply
```

## JSON String Format

### Lists of Strings

```hcl
subnets_pvt_json = "[\"subnet-123\",\"subnet-456\"]"
ingress_cidr_blocks_json = "[\"10.0.0.0/16\",\"172.16.0.0/12\"]"
cloudwatch_log_exports_json = "[\"slow-log\",\"engine-log\"]"
```

### Maps

```hcl
tags_json = "{\"Project\":\"MyApp\",\"Team\":\"Platform\",\"Environment\":\"prod\"}"
```

### Lists of Objects

```hcl
# Parameters
parameters_json = "[{\"name\":\"maxmemory-policy\",\"value\":\"allkeys-lru\"},{\"name\":\"timeout\",\"value\":\"300\"}]"

# Ingress rules
ingress_rules_json = "[{\"from_port\":6379,\"to_port\":6379,\"protocol\":\"tcp\",\"cidr_blocks\":[\"10.0.0.0/16\"],\"description\":\"Redis access\"}]"

# Log delivery configuration
log_delivery_configuration_json = "[{\"destination\":\"/aws/elasticache/redis\",\"destination_type\":\"cloudwatch-logs\",\"log_format\":\"json\",\"log_type\":\"slow-log\"}]"
```

### Null Values

For optional variables that should be null:

```hcl
snapshot_arns_json = "null"
ingress_cidr_blocks_json = "null"
preferred_availability_zones_json = "null"
```

## API Integration Example

If you're calling this module from an API or IDP:

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
  "subnets_pvt_json": "[\"subnet-abc123\",\"subnet-def456\"]",
  "tags_json": "{\"Project\":\"MyApp\",\"Team\":\"Platform\"}",
  "replicas_per_node_group": 2,
  "automatic_failover_enabled": true,
  "multi_az_enabled": true,
  "transit_encryption_enabled": true,
  "at_rest_encryption_enabled": true
}
```

## Validation

The module will automatically:

1. Parse JSON strings
2. Validate data types
3. Apply Terraform validations
4. Return clear error messages if JSON is invalid

### Invalid JSON Example

```hcl
# This will fail with a clear error
subnets_pvt_json = "[subnet-123, subnet-456]"  # Missing quotes

# Correct format
subnets_pvt_json = "[\"subnet-123\",\"subnet-456\"]"
```

## Advantages

1. **Platform Compatibility**: Works with systems that only support string inputs
2. **Type Safety**: Automatic conversion with validation
3. **Clear Errors**: JSON parsing errors are caught early
4. **Flexibility**: Mix string and native types as needed

## Limitations

1. **JSON Syntax**: Must use valid JSON (double quotes, proper escaping)
2. **Readability**: JSON strings are less readable than HCL
3. **IDE Support**: Less IDE autocomplete/validation for JSON strings

## Alternative: Native Types

If your platform supports native Terraform types, use the standard examples instead:

- [Redis Cluster](../redis-cluster/)
- [Redis Replication](../redis-replication/)
- [Memcached](../memcached/)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Inputs

See [variables.tf](variables.tf) for all available inputs.

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ElastiCache cluster identifier |
| primary_endpoint_address | Primary endpoint address |
| reader_endpoint_address | Reader endpoint address |
| port | Port number |
| security_group_id | Security group ID |
| subnet_group_name | Subnet group name |
