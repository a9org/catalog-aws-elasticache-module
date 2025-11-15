# Redis Replication Group Example

This example demonstrates deploying a Redis replication group with high availability, encryption, and automatic failover without cluster mode (sharding).

## Features

- **High Availability**: 1 primary + 2 replicas with automatic failover
- **Multi-AZ**: Nodes distributed across multiple availability zones
- **Security**: Encryption at rest and in transit with AUTH token support
- **Backup**: Daily automated snapshots with 7-day retention
- **Read Scaling**: Reader endpoint for distributing read traffic across replicas

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Redis Replication Group                     │
├─────────────────────────────────────────────────────────┤
│                                                           │
│                    ┌──────────────┐                      │
│                    │   Primary    │                      │
│                    │   (AZ-1)     │                      │
│                    └──────┬───────┘                      │
│                           │                              │
│              ┌────────────┴────────────┐                 │
│              │                         │                 │
│         ┌────▼─────┐            ┌─────▼────┐            │
│         │ Replica  │            │ Replica  │            │
│         │  (AZ-2)  │            │  (AZ-3)  │            │
│         └──────────┘            └──────────┘            │
│                                                           │
│  Primary Endpoint: Write operations                      │
│  Reader Endpoint:  Read operations (load balanced)       │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

## Usage

1. Update the `terraform.tfvars` file with your VPC information:

```hcl
vpc_id         = "vpc-12345678"
vpc_cidr_block = "10.0.0.0/16"
subnets_pvt    = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]

# Enable encryption with AUTH token
auth_token = "your-secure-auth-token-min-16-chars"

# Optional: Use custom KMS key for encryption
kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

# Optional: Restore from snapshot
snapshot_arns = ["arn:aws:elasticache:us-east-1:123456789012:snapshot:my-snapshot"]
```

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

3. Connect to your Redis cluster:

```bash
# Get endpoints
PRIMARY_ENDPOINT=$(terraform output -raw primary_endpoint_address)
READER_ENDPOINT=$(terraform output -raw reader_endpoint_address)
PORT=$(terraform output -raw port)

# Connect to primary for writes (with AUTH token)
redis-cli -h $PRIMARY_ENDPOINT -p $PORT --tls -a your-auth-token

# Connect to reader endpoint for reads
redis-cli -h $READER_ENDPOINT -p $PORT --tls -a your-auth-token
```

## Configuration

### Replication Setup

The default configuration creates:
- **1 primary node** (handles writes)
- **2 replica nodes** (handle reads and provide failover)
- **3 total nodes** across multiple availability zones

Adjust replica count in `variables.tf` or `terraform.tfvars`:

```hcl
replicas_per_node_group = 1  # Minimum for automatic failover
# or
replicas_per_node_group = 3  # More replicas = higher read capacity
```

### High Availability

For production workloads, enable:

```hcl
automatic_failover_enabled = true  # Auto-promote replica on primary failure
multi_az_enabled           = true  # Distribute nodes across AZs
```

**Note**: Automatic failover requires at least 1 replica.

### Security

Enable encryption for production:

```hcl
transit_encryption_enabled = true
at_rest_encryption_enabled = true
auth_token                 = "your-secure-token-min-16-chars"
kms_key_id                 = "arn:aws:kms:region:account:key/key-id"
```

### Custom Parameters

Tune Redis behavior with custom parameters:

```hcl
create_parameter_group = true
parameters = [
  {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  },
  {
    name  = "timeout"
    value = "300"
  }
]
```

### Backup and Recovery

Configure automated backups:

```hcl
snapshot_retention_limit = 7              # Keep 7 days of snapshots
snapshot_window          = "03:00-05:00"  # Daily backup window
maintenance_window       = "sun:05:00-sun:07:00"  # Weekly maintenance
```

Restore from existing snapshot:

```hcl
snapshot_arns = [
  "arn:aws:elasticache:us-east-1:123456789012:snapshot:my-snapshot"
]
```

## Endpoints

### Primary Endpoint
- **Purpose**: Write operations
- **Usage**: All write operations must go to the primary endpoint
- **Failover**: Automatically updated when a replica is promoted

### Reader Endpoint
- **Purpose**: Read operations
- **Usage**: Distributes read traffic across all replica nodes
- **Load Balancing**: AWS automatically balances connections

## Outputs

| Output | Description |
|--------|-------------|
| cluster_id | Redis replication group identifier |
| primary_endpoint_address | Primary endpoint for writes |
| reader_endpoint_address | Reader endpoint for reads |
| port | Redis port (default: 6379) |
| primary_connection_string | Primary connection string |
| reader_connection_string | Reader connection string |
| security_group_id | Security group ID |
| replication_configuration | Configuration summary |

## Cost Considerations

This example creates 3 nodes (1 primary + 2 replicas). Estimated monthly cost with `cache.r6g.large`:

- **On-Demand**: ~$540/month (3 nodes × $180/month)
- **Reserved (1-year)**: ~$360/month (33% savings)
- **Reserved (3-year)**: ~$270/month (50% savings)

Adjust replica count and node type based on your budget and requirements.

## Failover Behavior

When automatic failover is enabled:

1. **Primary Failure Detected**: AWS detects primary node failure
2. **Replica Promotion**: One replica is automatically promoted to primary
3. **Endpoint Update**: Primary endpoint DNS is updated (30-60 seconds)
4. **Failed Node Recovery**: Original primary rejoins as a replica

**Application Impact**: Brief connection interruption during DNS update. Use connection retry logic.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Notes

- Automatic failover requires at least 1 replica
- Multi-AZ requires automatic failover to be enabled
- AUTH token requires transit encryption to be enabled
- Reader endpoint only available when replicas exist
- This configuration does NOT use cluster mode (no sharding)
- For horizontal write scaling, use cluster mode instead
