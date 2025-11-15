# Memcached Cluster Example

This example demonstrates deploying a Memcached cluster for simple, distributed in-memory caching.

## Features

- **Multi-Node Cluster**: 3 cache nodes for distributed caching
- **Auto-Discovery**: Configuration endpoint for automatic node discovery
- **Simple Setup**: No replication or persistence - pure in-memory cache
- **Horizontal Scaling**: Add more nodes to increase cache capacity
- **Cost-Effective**: Simple architecture with lower operational overhead

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  Memcached Cluster                       │
├─────────────────────────────────────────────────────────┤
│                                                           │
│   ┌──────────┐      ┌──────────┐      ┌──────────┐     │
│   │  Node 1  │      │  Node 2  │      │  Node 3  │     │
│   │  (AZ-1)  │      │  (AZ-2)  │      │  (AZ-3)  │     │
│   └──────────┘      └──────────┘      └──────────┘     │
│                                                           │
│   Configuration Endpoint: cluster-name.cfg.use1.cache... │
│   (Auto-discovers all nodes)                             │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

## Usage

1. Update the `terraform.tfvars` file with your VPC information:

```hcl
vpc_id         = "vpc-12345678"
vpc_cidr_block = "10.0.0.0/16"
subnets_pvt    = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]

# Optional: Specify availability zones
preferred_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Optional: Adjust cluster size
num_cache_nodes = 5
```

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

3. Connect to your Memcached cluster:

```bash
# Get the configuration endpoint
CONFIG_ENDPOINT=$(terraform output -raw configuration_endpoint)
PORT=$(terraform output -raw port)

# Connect with telnet
telnet $CONFIG_ENDPOINT $PORT

# Or use a Memcached client library in your application
```

## Configuration

### Cluster Sizing

The default configuration creates **3 cache nodes**. Adjust based on your needs:

```hcl
num_cache_nodes = 5  # More nodes = more cache capacity
```

**Limits**: 1-40 nodes per cluster

### Node Types

Choose node type based on your memory requirements:

- **Development**: `cache.t3.micro` (0.5 GB) or `cache.t3.small` (1.4 GB)
- **Production**: `cache.t3.medium` (3.1 GB) or `cache.r6g.large` (13.1 GB)
- **High Memory**: `cache.r6g.xlarge` (26.3 GB) or larger

### Custom Parameters

Tune Memcached behavior with custom parameters:

```hcl
create_parameter_group = true
parameters = [
  {
    name  = "max_item_size"
    value = "2097152"  # 2MB max item size
  },
  {
    name  = "chunk_size_growth_factor"
    value = "1.25"
  }
]
```

Common parameters:
- `max_item_size`: Maximum size of a cache item (default: 1MB)
- `chunk_size_growth_factor`: Memory allocation growth factor
- `binding_protocol`: Protocol binding (ascii or binary)

### Availability Zones

Distribute nodes across AZs for better availability:

```hcl
preferred_availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]
```

## Client Configuration

### Auto-Discovery

Use the configuration endpoint for automatic node discovery:

```python
# Python example with pymemcache
from pymemcache.client.hash import HashClient

config_endpoint = "myapp-cache-prod.cfg.use1.cache.amazonaws.com"
port = 11211

client = HashClient([
    (config_endpoint, port)
], use_pooling=True)

# Set a value
client.set('key', 'value')

# Get a value
value = client.get('key')
```

### Manual Node List

Alternatively, connect to individual nodes:

```python
# Connect to specific nodes
nodes = [
    ('node1.cache.amazonaws.com', 11211),
    ('node2.cache.amazonaws.com', 11211),
    ('node3.cache.amazonaws.com', 11211),
]

client = HashClient(nodes)
```

## Outputs

| Output | Description |
|--------|-------------|
| cluster_id | Memcached cluster identifier |
| configuration_endpoint | Configuration endpoint with auto-discovery |
| port | Memcached port (default: 11211) |
| connection_string | Connection string for clients |
| security_group_id | Security group ID |
| cluster_configuration | Configuration summary |

## Cost Considerations

This example creates 3 nodes. Estimated monthly cost with `cache.t3.micro`:

- **On-Demand**: ~$15/month (3 nodes × $5/month)
- **Reserved (1-year)**: ~$10/month (33% savings)
- **Reserved (3-year)**: ~$7.50/month (50% savings)

With `cache.r6g.large`:
- **On-Demand**: ~$540/month (3 nodes × $180/month)

Memcached is generally more cost-effective than Redis for simple caching use cases.

## Memcached vs Redis

### Use Memcached When:
- You need simple key-value caching
- You don't need data persistence
- You don't need replication or high availability
- You want to minimize operational complexity
- You need horizontal scaling through sharding

### Use Redis Instead When:
- You need data persistence
- You need replication and automatic failover
- You need advanced data structures (lists, sets, sorted sets)
- You need pub/sub messaging
- You need transactions or Lua scripting

## Limitations

- **No Persistence**: Data is lost when nodes restart
- **No Replication**: No automatic failover or data redundancy
- **No Encryption**: Memcached doesn't support encryption at rest or in transit
- **No Authentication**: No built-in authentication mechanism
- **Simple Data Types**: Only supports string values (no complex data structures)

## Best Practices

1. **Use Auto-Discovery**: Configure clients to use the configuration endpoint
2. **Monitor Memory**: Set up CloudWatch alarms for memory usage
3. **Size Appropriately**: Each node should have enough memory for your working set
4. **Distribute Load**: Use consistent hashing in your client library
5. **Network Security**: Restrict access via security groups (VPC CIDR by default)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Notes

- Memcached clusters are simpler than Redis but less feature-rich
- No automatic backups or snapshots available
- Nodes are independent - data is sharded across nodes by the client
- Configuration endpoint enables automatic node discovery
- Maximum 40 nodes per cluster
- No support for encryption or authentication
