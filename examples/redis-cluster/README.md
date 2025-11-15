# Redis Cluster Mode Example

This example demonstrates deploying a Redis cluster with cluster mode (sharding) enabled for horizontal scalability and high availability.

## Features

- **Cluster Mode**: 3 shards (node groups) with 2 replicas each (9 total nodes)
- **High Availability**: Automatic failover enabled across multiple availability zones
- **Security**: Encryption at rest and in transit with optional AUTH token
- **Backup**: Daily automated snapshots with 7-day retention
- **Monitoring**: Optional CloudWatch log delivery for slow-log and engine-log

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Redis Cluster Mode                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Shard 1              Shard 2              Shard 3           │
│  ┌──────────┐        ┌──────────┐        ┌──────────┐       │
│  │ Primary  │        │ Primary  │        │ Primary  │       │
│  └────┬─────┘        └────┬─────┘        └────┬─────┘       │
│       │                   │                   │              │
│  ┌────┴─────┐        ┌────┴─────┐        ┌────┴─────┐       │
│  │ Replica  │        │ Replica  │        │ Replica  │       │
│  └──────────┘        └──────────┘        └──────────┘       │
│  ┌──────────┐        ┌──────────┐        ┌──────────┐       │
│  │ Replica  │        │ Replica  │        │ Replica  │       │
│  └──────────┘        └──────────┘        └──────────┘       │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Usage

1. Update the `terraform.tfvars` file with your VPC information:

```hcl
vpc_id         = "vpc-12345678"
vpc_cidr_block = "10.0.0.0/16"
subnets_pvt    = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]

# Optional: Enable encryption with AUTH token
auth_token = "your-secure-auth-token-here"

# Optional: Use custom KMS key for encryption
kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
```

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

3. Connect to your Redis cluster:

```bash
# Get the primary endpoint
PRIMARY_ENDPOINT=$(terraform output -raw primary_endpoint_address)
PORT=$(terraform output -raw port)

# Connect with redis-cli (with AUTH token)
redis-cli -h $PRIMARY_ENDPOINT -p $PORT --tls -a your-auth-token

# Or without AUTH token (if not configured)
redis-cli -h $PRIMARY_ENDPOINT -p $PORT --tls
```

## Configuration

### Cluster Sizing

The default configuration creates:
- **3 shards** (num_node_groups)
- **2 replicas per shard** (replicas_per_node_group)
- **9 total nodes** (3 primaries + 6 replicas)

Adjust these values in `variables.tf` or `terraform.tfvars` based on your needs:

```hcl
num_node_groups         = 5  # More shards = more write capacity
replicas_per_node_group = 1  # Fewer replicas = lower cost
```

### Node Types

The example uses `cache.r6g.xlarge` (memory-optimized, Graviton2). Consider:

- **Development**: `cache.t3.micro` or `cache.t3.small`
- **Production**: `cache.r6g.large` or larger
- **Data Tiering**: `cache.r6gd.*` types (requires `data_tiering_enabled = true`)

### Security

Enable encryption for production workloads:

```hcl
transit_encryption_enabled = true
at_rest_encryption_enabled = true
auth_token                 = "your-secure-token-min-16-chars"
kms_key_id                 = "arn:aws:kms:region:account:key/key-id"
```

## Outputs

| Output | Description |
|--------|-------------|
| cluster_id | Redis replication group identifier |
| primary_endpoint_address | Configuration endpoint for cluster mode |
| reader_endpoint_address | Reader endpoint for read operations |
| port | Redis port (default: 6379) |
| connection_string | Redis connection string |
| security_group_id | Security group ID |
| cluster_configuration | Summary of cluster settings |

## Cost Considerations

This example creates 9 nodes (3 shards × 3 nodes per shard). Estimated monthly cost with `cache.r6g.xlarge`:

- **On-Demand**: ~$1,620/month (9 nodes × $180/month)
- **Reserved (1-year)**: ~$1,080/month (33% savings)
- **Reserved (3-year)**: ~$810/month (50% savings)

Adjust node count and type based on your budget and requirements.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Notes

- Cluster mode requires at least 1 shard (num_node_groups >= 1)
- Automatic failover is automatically enabled with cluster mode
- AUTH token requires transit encryption to be enabled
- Cluster mode provides better write scalability through sharding
- Each shard handles a subset of the keyspace (hash slots)
