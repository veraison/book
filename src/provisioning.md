# Endorsement and Reference Value Provisioning

## Concise Reference Integrity Manifest

The Concise Reference Integrity Manifest (CoRIM) is a format for representing
Endorsements and Reference Values as defined by the [RATS
architecture](https://www.ietf.org/rfc/rfc9334.html). See [this IETF
Draft](https://datatracker.ietf.org/doc/draft-ietf-rats-corim/07/) for the
detailed specification.

A Go implementation exists on
[GitHub](https://github.com/veraison/corim).

CoRIM is the format used for provisioning Endorsements and Reference Values by all attestation schemes currently supported by [Veraison Services](services/overview.md).

## Concise Software Identification Tags

Concise Software Identification Tags (CoSWID) is a format for describing
software components (eg. a specific release of software, a patch, or an
installation bundle). The full specification is defined by
[RFC9393](https://www.ietf.org/rfc/rfc9393.html).

A Go implementation exists on
[GitHub](https://github.com/veraison/swid).
