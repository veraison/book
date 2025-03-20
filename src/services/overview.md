# Remote Attestation Verification Services

Veraison provides a reference implementation of remote verification of
attestation services. This implementation provides REST API for

- provisioning of trust anchors and endorsements/reference values
- verification of evidence based on pre-defined attestation scheme, and
  (optionally) deployment-specific policies
- management of deployment-specific policies

The implementation broadly adheres to RATS architectures defined by [RFC
9334](https://www.ietf.org/rfc/rfc9334.html). The core functionality is
agnostic of attestation scheme details. Scheme-specific logic is provided via
plugins. [OPA](https://www.openpolicyagent.org/)-based policies can optionally
be used to augment the plugin-defined process.

This implementation can be found on
[GitHub](https://github.com/veraison/services).

For installation instructions please see [Deployments](deployments/overview.md).
