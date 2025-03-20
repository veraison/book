# Configuration

Configuration for Veraison services is specified in YAML format. By default,
each executable will try to read configuration from a file called `config.yaml`
in that executable's current working directory (i.e. the directory it was
launched from -- not the directory the executable itself is located). An
alternative configuration file may be specified using `--config` option when
launching the executable.

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
