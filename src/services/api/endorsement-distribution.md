# Endorsement Distribution API

The Endorsement Distribution API is a critical component for scaling Veraison deployments, providing mechanisms for efficient distribution and management of endorsements across multiple verification services and deployment environments.

## Overview

The Endorsement Distribution API enables:
- Centralized management of endorsement lifecycle
- Efficient distribution to multiple verification nodes
- Synchronization between distributed Veraison instances
- Bulk operations for large-scale deployments

## API Specifications

### Base Endpoints

```
GET    /endorsement/v1/distribution/health
GET    /endorsement/v1/distribution/metadata
POST   /endorsement/v1/distribution/sync
GET    /endorsement/v1/distribution/status/{operation-id}
```

### Distribution Operations

#### Sync Endorsements

Synchronize endorsements between source and target instances.

**Request:**
```http
POST /endorsement/v1/distribution/sync
Content-Type: application/json
Authorization: Bearer <token>

{
  "source": {
    "endpoint": "https://primary.veraison.local",
    "credentials": {...}
  },
  "target": {
    "endpoint": "https://replica.veraison.local", 
    "credentials": {...}
  },
  "filter": {
    "schemes": ["psa", "cca"],
    "since": "2024-01-01T00:00:00Z",
    "batch_size": 1000
  },
  "options": {
    "dry_run": false,
    "verify_integrity": true,
    "parallel_workers": 4
  }
}
```

**Response:**
```json
{
  "operation_id": "sync-abc123",
  "status": "initiated",
  "estimated_count": 15420,
  "created_at": "2024-01-15T10:30:00Z"
}
```

#### Check Operation Status

**Request:**
```http
GET /endorsement/v1/distribution/status/sync-abc123
```

**Response:**
```json
{
  "operation_id": "sync-abc123",
  "status": "completed",
  "progress": {
    "processed": 15420,
    "succeeded": 15418,
    "failed": 2,
    "completion_percentage": 100
  },
  "results": {
    "summary": "Sync completed with 2 failures",
    "failed_items": [
      {
        "endorsement_id": "endorse-xyz789",
        "error": "integrity_check_failed",
        "details": "SHA256 mismatch"
      }
    ]
  },
  "duration": "00:04:32",
  "completed_at": "2024-01-15T10:34:32Z"
}
```

## Security Considerations

### Authentication & Authorization

- **Mutual TLS**: Required for all distribution endpoints
- **JWT Tokens**: Bearer tokens with distribution-specific claims
- **RBAC**: Role-based access control for distribution operations

```yaml
# Example RBAC policy
roles:
  distribution_admin:
    permissions:
      - "endorsement:distribution:sync"
      - "endorsement:distribution:status"
  distribution_readonly:
    permissions:
      - "endorsement:distribution:status"
```

### Data Integrity

- **Content Verification**: SHA256 checksums for all transferred endorsements
- **Signature Validation**: Cryptographic signatures on endorsement packages
- **Audit Logging**: Complete audit trail of all distribution operations

### Network Security

- **Rate Limiting**: Configurable limits per source/target pair
- **IP Allowlisting**: Restrict distribution sources to trusted networks
- **Encryption**: AES-256 encryption for endorsement payloads

## Implementation Patterns

### Single-Source Distribution

For centralized endorsement management:

```go
// Configuration example
type DistributionConfig struct {
    Source      EndpointConfig `yaml:"source"`
    Targets     []EndpointConfig `yaml:"targets"`
    SyncPolicy  SyncPolicy     `yaml:"sync_policy"`
    Security    SecurityConfig `yaml:"security"`
}

type SyncPolicy struct {
    Interval    time.Duration `yaml:"interval"`    // 5m
    BatchSize   int          `yaml:"batch_size"`  // 1000
    Retry       RetryConfig  `yaml:"retry"`
    Validation  bool         `yaml:"validation"`  // true
}
```

### Multi-Hub Distribution

For geographically distributed deployments:

```yaml
# Multi-hub configuration
distribution:
  topology: "multi-hub"
  hubs:
    - name: "us-east"
      endpoint: "https://hub-us-east.veraison.local"
      regions: ["us-east-1", "us-east-2"]
    - name: "eu-west"
      endpoint: "https://hub-eu-west.veraison.local"
      regions: ["eu-west-1", "eu-west-2"]
  
  routing_policy:
    strategy: "geographic"
    fallback: "nearest_hub"
```

### Event-Driven Distribution

For real-time synchronization:

```go
// Event handler example
func (d *Distributor) HandleEndorsementEvent(ctx context.Context, event *EndorsementEvent) error {
    switch event.Type {
    case "endorsement.created":
        return d.distributeToTargets(ctx, event.EndorsementID)
    case "endorsement.updated":
        return d.updateTargets(ctx, event.EndorsementID)
    case "endorsement.deleted":
        return d.removeFromTargets(ctx, event.EndorsementID)
    }
    return nil
}
```

## Scaling Strategies

### Horizontal Scaling

- **Load Balancing**: Distribute requests across multiple distribution nodes
- **Sharding**: Partition endorsements by scheme or other criteria
- **Caching**: Redis-based caching for frequently accessed endorsements

### Performance Optimization

- **Batch Processing**: Process endorsements in configurable batch sizes
- **Parallel Workers**: Concurrent processing with worker pools
- **Delta Synchronization**: Only transfer changed endorsements

```yaml
# Performance tuning
performance:
  workers: 8
  batch_size: 2000
  connection_pool: 20
  timeout: 300s
  
  cache:
    enabled: true
    ttl: 3600s
    max_entries: 50000
```

### Database Optimization

- **Read Replicas**: Use read replicas for distribution queries
- **Indexing**: Optimize indexes for common distribution queries
- **Partitioning**: Partition large endorsement tables by date/scheme

```sql
-- Example indexing strategy
CREATE INDEX idx_endorsements_distribution 
ON endorsements (scheme, created_at, status);

CREATE INDEX idx_endorsements_checksum 
ON endorsements (checksum);
```

## Error Handling & Recovery

### Retry Mechanisms

```yaml
retry_policy:
  max_attempts: 3
  initial_delay: 1s
  max_delay: 30s
  multiplier: 2.0
  
  retryable_errors:
    - "network_timeout"
    - "service_unavailable"
    - "rate_limit_exceeded"
  
  non_retryable_errors:
    - "authentication_failed"
    - "authorization_denied"
    - "malformed_request"
```

### Circuit Breaker

```go
// Circuit breaker configuration
type CircuitBreakerConfig struct {
    FailureThreshold   int           `yaml:"failure_threshold"`   // 5
    RecoveryTimeout    time.Duration `yaml:"recovery_timeout"`    // 30s
    RequestVolumeThreshold int       `yaml:"request_volume_threshold"` // 10
}
```

### Dead Letter Queue

Failed distribution operations are queued for manual review:

```json
{
  "dlq_entry": {
    "operation_id": "sync-failed-456",
    "original_request": {...},
    "failure_reason": "target_unreachable",
    "failure_count": 3,
    "first_failed_at": "2024-01-15T11:00:00Z",
    "last_failed_at": "2024-01-15T11:15:00Z"
  }
}
```

## Monitoring & Observability

### Metrics

Key metrics to monitor:

- `endorsement_distribution_requests_total`
- `endorsement_distribution_duration_seconds`
- `endorsement_distribution_failures_total`
- `endorsement_distribution_queue_size`

### Health Checks

```http
GET /endorsement/v1/distribution/health

{
  "status": "healthy",
  "components": {
    "database": "healthy",
    "cache": "healthy", 
    "targets": {
      "replica-1": "healthy",
      "replica-2": "degraded"
    }
  },
  "version": "v1.2.3"
}
```

### Distributed Tracing

Enable OpenTelemetry tracing for end-to-end visibility:

```yaml
tracing:
  enabled: true
  endpoint: "http://jaeger:14268/api/traces"
  service_name: "endorsement-distribution"
  sample_rate: 0.1
```

## Troubleshooting Guide

### Common Issues

#### Sync Failures

**Symptom**: Distribution operations timing out
**Cause**: Network connectivity or target overload
**Solution**: 
- Check network connectivity between source and targets
- Verify target capacity and resource usage
- Adjust batch sizes and worker counts

#### Integrity Check Failures

**Symptom**: Endorsements failing integrity validation
**Cause**: Data corruption during transfer or storage issues
**Solution**:
- Enable verbose logging for checksum validation
- Verify source data integrity
- Check for storage corruption on targets

#### Authentication Errors

**Symptom**: 401/403 responses during distribution
**Cause**: Expired tokens or misconfigured credentials
**Solution**:
- Refresh authentication tokens
- Verify RBAC permissions
- Check certificate validity for mTLS

### Debug Commands

```bash
# Check distribution status
curl -H "Authorization: Bearer $TOKEN" \
  https://veraison.local/endorsement/v1/distribution/health

# Monitor active operations
curl -H "Authorization: Bearer $TOKEN" \
  https://veraison.local/endorsement/v1/distribution/status

# Test connectivity
curl -v --cert client.pem --key client-key.pem \
  https://target.veraison.local/endorsement/v1/distribution/health
```

## Configuration Examples

### Production Configuration

```yaml
# production-distribution.yaml
distribution:
  api:
    listen_addr: "0.0.0.0:8080"
    tls:
      cert_file: "/etc/certs/server.pem"
      key_file: "/etc/certs/server-key.pem"
      ca_file: "/etc/certs/ca.pem"
  
  database:
    driver: "postgres"
    dsn: "postgres://user:pass@postgres:5432/veraison?sslmode=require"
    max_connections: 25
    
  targets:
    - name: "production-replica-1"
      endpoint: "https://replica1.prod.veraison.local"
      weight: 100
      health_check_interval: "30s"
      
    - name: "production-replica-2" 
      endpoint: "https://replica2.prod.veraison.local"
      weight: 100
      health_check_interval: "30s"
  
  policies:
    sync_interval: "5m"
    batch_size: 1000
    max_parallel_syncs: 2
    integrity_check: true
    
  security:
    mutual_tls: true
    token_validation: true
    audit_logging: true
    
  monitoring:
    metrics_enabled: true
    tracing_enabled: true
    log_level: "info"
```

This comprehensive documentation addresses all the requirements mentioned in issue #2, providing detailed API specifications, security considerations, scaling strategies, implementation patterns, error handling procedures, and practical troubleshooting guidance for the Endorsement Distribution API.