# Overview

This is an overview of the major components that par part of Veraison, and the
related git repositories.

## Remote attestation verification service

The main part of the project is the remote attestation verification service
implemented inside [services](https://github.com/veraison/services) repo. This
service provides REST API for verifying attestation evidence based on
provisioned endorsements and polices.

Client-side libraries for the services API are inside
[apiclient](https://github.com/veraison/apiclient) (for Go),
[c-apiclient](https://github.com/veraison/c-apiclient) (for C), and
[rust-apiclient](https://github.com/veraison/rust-apiclient) (for Rust) repos.

There are also command line interface application for interacting with the
service:

- [cocli](https://github.com/veraison/cocli) for compiling and provisioning PSA
  and CCA endorsements and trust anchors.
- [evcli](https://github.com/veraison/evcli) for verifying PSA and CCA evidence.
- [pocli](https://github.com/veraison/pocli) for managing verification
  policies.

{{#aa submods/docs/repo-guide.md#sect?title=Standards}}

{{#aa submods/docs/repo-guide.md#sect?title=Architecture specific}}

---

**See also**: [repo
guide](https://github.com/veraison/docs/blob/main/repo-guide.md) inside
[docs](https://github.com/veraison/docs) repo.


