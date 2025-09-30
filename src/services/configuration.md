# Configuration

Configuration for Veraison services is specified in YAML format. This document provides comprehensive guidance on configuring Veraison services securely and efficiently, addressing common challenges and best practices.

## Quick Start

By default, each executable will try to read configuration from a file called `config.yaml` in that executable's current working directory (i.e. the directory it was launched from -- not the directory the executable itself is located). An alternative configuration file may be specified using `--config` option when launching the executable.

### Using Configuration Templates

Start with one of the provided templates:
- **Development**: `src/services/templates/config.development.yaml` - Local development with minimal security
- **Production**: `src/services/templates/config.production.yaml` - Production-ready with full security

```bash
# Copy and customize a template
cp src/services/templates/config.production.yaml /opt/veraison/config/services/config.yaml

# Validate your configuration
./scripts/validate-config /opt/veraison/config/services/config.yaml
```

## Configuration Best Practices

### Security Best Practices

1. **TLS Configuration**
   - ✅ Always use HTTPS in production environments
   - ✅ Use strong TLS certificates (at least 2048-bit RSA or 256-bit ECC)
   - ✅ Rotate certificates regularly
   - ✅ Keep private keys secure and restrict access permissions (chmod 600)

2. **Authentication**
   - ✅ Enable authentication in production environments
   - ✅ Use strong passwords and rotate them regularly
   - ✅ Implement proper access control policies
   - ✅ Monitor authentication logs

3. **Database Security**
   - ✅ Use separate database users for different services
   - ✅ Implement least privilege access
   - ✅ Encrypt sensitive data at rest
   - ✅ Use connection pooling with reasonable limits
   - ✅ Enable SSL/TLS for database connections

4. **Logging**
   - ✅ Configure appropriate log levels for each environment
   - ✅ Implement log rotation
   - ✅ Monitor log storage usage
   - ✅ Include necessary audit logging
   - ⚠️ Avoid debug/trace levels in production

### Environment-Specific Guidelines

#### Development Environment
- Simplified configuration for rapid development
- Local-only services (127.0.0.1 bindings)
- Debug-level logging for troubleshooting
- In-memory stores for quick testing
- HTTP protocols (faster development)
- Authentication disabled for convenience

#### Production Environment
- Full security measures enabled
- Proper TLS configuration for all services
- Production-grade databases with connection pooling
- Limited debug logging (info/warn level)
- Proper monitoring and alerting
- Authentication required
- Firewall rules and network security

## Configuration Management

### Validation

Use the provided configuration validator to check your configuration:
```bash
# Basic validation
./scripts/validate-config /path/to/config.yaml

# Security-only checks
./scripts/validate-config --security-only /path/to/config.yaml

# Strict mode (warnings as errors)
./scripts/validate-config --strict /path/to/config.yaml
```

### Migration

Migrate configurations between versions:
```bash
# Migrate to latest version
./scripts/migrate-config /path/to/config.yaml

# Migrate to specific version
./scripts/migrate-config --target-version 2.0 /path/to/config.yaml

# Preview changes without modifying files
./scripts/migrate-config --dry-run /path/to/config.yaml
```

### Templates and Schema

- **Templates**: Standard templates for different environments
- **Schema**: Configuration structure is validated against `src/services/schema/config-schema.yaml`
- **Documentation**: This guide provides comprehensive configuration guidance

### Makefile Integration

The following make targets are available:
```bash
# Validate configuration
make validate-config

# Run security checks
make check-security

# Install validation dependencies
make install-config-tools
```

## Troubleshooting Guide

### Common Configuration Issues

#### 1. Service Won't Start

**Symptoms**: Service fails to start, error about configuration file
**Solutions**:
```bash
# Check if config file exists and is readable
ls -la /opt/veraison/config/services/config.yaml

# Validate configuration syntax
./scripts/validate-config /opt/veraison/config/services/config.yaml

# Check service logs
journalctl -u veraison-verification -f
```

#### 2. HTTPS/TLS Issues

**Symptoms**: "TLS handshake failed", "certificate verify failed"
**Solutions**:
```bash
# Check certificate files exist and have correct permissions
ls -la /opt/veraison/certs/
chmod 600 /opt/veraison/certs/*.key
chmod 644 /opt/veraison/certs/*.crt

# Validate certificate
openssl x509 -in /opt/veraison/certs/verification.crt -text -noout

# Check certificate expiration
openssl x509 -in /opt/veraison/certs/verification.crt -checkend 86400
```

#### 3. Database Connection Issues

**Symptoms**: "connection refused", "authentication failed"
**Solutions**:
```bash
# Test database connectivity
psql "postgres://user:pass@host:5432/db" -c "SELECT 1;"

# Check connection pool settings
./scripts/validate-config --security-only config.yaml

# Verify database user permissions
psql -c "\\du" # List database users
```

#### 4. Plugin Loading Issues

**Symptoms**: "plugin not found", "plugin incompatible"
**Solutions**:
```bash
# Check plugin directory exists and is readable
ls -la /opt/veraison/plugins/

# Verify plugin file permissions
chmod +x /opt/veraison/plugins/*

# Check plugin compatibility
./scripts/validate-config config.yaml
```

#### 5. Authentication Issues

**Symptoms**: "authentication failed", "unauthorized"
**Solutions**:
```bash
# Verify Keycloak connectivity
curl -k https://keycloak.domain:8443/auth/realms/master

# Check authentication configuration
./scripts/validate-config --security-only config.yaml

# Review authentication logs
grep -i "auth" /opt/veraison/logs/*.log
```

### Performance Troubleshooting

#### High Memory Usage
- Reduce connection pool sizes in store configurations
- Lower log retention periods
- Monitor memory usage: `systemctl status veraison-*`

#### Slow Response Times
- Check database query performance
- Increase connection pool sizes if needed
- Review network latency between services
- Monitor with: `curl -w "@curl-format.txt" https://service/health`

#### High CPU Usage
- Review log levels (disable debug in production)
- Check for plugin performance issues
- Monitor with: `top -p $(pgrep veraison)`

### Configuration Validation Errors

Common validation errors and their fixes:

| Error | Cause | Solution |
|-------|-------|----------|
| "HTTPS enabled but no certificate specified" | Missing cert/cert-key in HTTPS service | Add `cert` and `cert-key` paths |
| "Invalid port number" | Port outside valid range (1-65535) | Use valid port number |
| "Weak password detected" | Using example/weak passwords | Replace with secure passwords |
| "Missing required section" | Required config section missing | Add missing section (usually `auth` or `vts`) |

### Log Analysis

Important log patterns to monitor:

```bash
# Security events
grep -E "(auth|security|cert|tls)" /opt/veraison/logs/*.log

# Performance issues
grep -E "(timeout|slow|error)" /opt/veraison/logs/*.log

# Configuration changes
grep -E "(config|reload)" /opt/veraison/logs/*.log
```

## Configuration Reference

### Quick Reference

Essential configuration patterns:

```yaml
# Minimal production configuration
auth:
  backend: keycloak
  host: keycloak.domain
  port: 8443

logging:
  level: info
  output-paths: [stdout, /opt/veraison/logs/service.log]

verification:
  listen-addr: 0.0.0.0:8080
  protocol: https
  cert: /opt/veraison/certs/verification.crt
  cert-key: /opt/veraison/certs/verification.key

vts:
  server-addr: vts.domain:50051
  tls: true
  cert: /opt/veraison/certs/vts.crt
  cert-key: /opt/veraison/certs/vts.key
  ca-certs: /opt/veraison/certs/ca-bundle.crt
```

## Deployment configuration

Services configured to run as part of a deployment (e.g. via systemd units)
will typically look for configuration in `config/services/config.yaml` under
the deployment's location. For example, services installed via `deb` or `rpm`
packages will have their configuration inside
`/opt/veraison/config/services/config.yaml`.

For `docker` and `aws` deployments, you normally shouldn't be modifying the
configuration inside the containers/EC2 instances directly. Please refer to the
deployments' documentation for information on how they may be configured.

## Top-level entries

The following top-level entries will be read for the config file:

- `auth`: authentication configuration (used by management and provisioning
  services)
- `ear-signer`: EAR signer configuration (used by vts service)
- `en-store`: endorsements key-value store configuration (used by vts service)
- `logging`: logging configuration (used by all services)
- `management`: management REST API service configuration (used by management
  service)
- `plugin`: plugin loader configuration (used by vts and management services)
- `provisioning`: provisioning REST API service configuration (used by
  provisioning service)
- `po-store`: policy key-value store configuration (used by vts and management
  services)
- `sessionmanager`: verification service's session manager configuration (used
  by verification service)
- `ta-store`: trust anchors key-value store configuration (used by vts service)
- `verification`: verification REST API service configuration (used by
  verification service)
- `vts`: Veraison Trusted Services configuration (used by vts service)

Each service executable will only look for the top-level entries it expects and
will ignore the rest.

### `auth` configuration

See [Authentication configuration](#authentication-configuration) below.

{{#aa ../submods/services/vts/earsigner/README.md#sect?title=`ear-signer` configuration}}

### `en-store` configuration

See [KV Store configuration](#kv-store-configuration) below.

{{#aa ../submods/services/log/README.md#sect?title=`logging` configuration}}

{{#aa ../submods/services/management/cmd/management-service/README.md#sect?title=`management` configuration}}

{{#aa ../submods/services/vts/cmd/vts-service/README.md#sect?title=`plugin` configuration}}

### `po-store` configuration

See [KV Store configuration](#kv-store-configuration) below.

{{#aa ../submods/services/policy/README.md#sect?title=`po-agent` configuration}}

{{#aa ../submods/services/provisioning/cmd/provisioning-service/README.md#sect?title=`provisioning` configuration}}

{{#aa ../submods/services/verification/cmd/verification-service/README.md#sect?title=`sessionmanager` configuration}}

### `ta-store` configuration

See [KV Store configuration](#kv-store-configuration) below.

{{#aa ../submods/services/verification/cmd/verification-service/README.md#sect?title=`verification` configuration}}

{{#aa ../submods/services/vts/trustedservices/README.md#sect?title=`vts` configuration}}

{{#aa ../submods/services/auth/README.md#sect?title=Authentication configuration}}

{{#aa ../submods/services/kvstore/README.md#sect?title=KV Store configuration}}

## Example

This is an example of a complete configuration for all Veraison services.

```yaml
auth:
   backend: keycloak
   host: keycloak.example.com
   port: 11111
ear-signer:
  alg: ES256
  key: /opt/veraison/signing/skey.jwk
en-store:
  backend: sql
  sql:
    max_connections: 8
    driver: pgx
    datasource: postgres://veraison:p4ssw0rd@postgres.example.com:5432/veraison
    tablename: endorsements
logging:
  level: info
  output-paths:
    - stdout
    - /opt/veraison/logs/{{ .service }}-stdout.log
management:
  listen-addr: 0.0.0.0:8088
  protocol: https
  cert: /opt/veraison/certs/management.crt
  cert-key: /opt/veraison/certs/management.key
plugin:
  backend: go-plugin
  go-plugin:
    dir: /opt/veraison/plugins/
po-agent:
    backend: opa
po-store:
  backend: sql
  sql:
    max_connections: 8
    driver: pgx
    datasource: postgres://veraison:p4ssw0rd@postgres.example.com:5432/veraison
    tablename: policies
provisioning:
  listen-addr: 0.0.0.0:8888
  protocol: https
  cert: /opt/veraison/certs/provisioning.crt
  cert-key: /opt/veraison/certs/provisioning.key
sessionmanager:
  backend: memcached
  memcached:
    servers:
        - memcached1.example.com:11211
        - memcached2.example.com:11211
ta-store:
  backend: sql
  sql:
    max_connections: 8
    driver: pgx
    datasource: postgres://veraison:p4ssw0rd@postgres.example.com:5432/veraison
    tablename: trust_anchors
verification:
  listen-addr: 0.0.0.0:8080
  protocol: https
  cert: /opt/veraison/certs/verification.crt
  cert-key: /opt/veraison/certs/verification.key
vts:
  server-addr: localhost:50051
  tls: true
  cert: /opt/veraison/certs/vts.crt
  cert-key: /opt/veraison/certs/vts.key
  ca-certs: /opt/veraison/certs/rootCA.crt
```
