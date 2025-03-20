# Arm PSA and CCA Attestation

Evaluation of Arm [Platform Security
Architecture](https://www.arm.com/architecture/security-features/platform-security)
and [Confidential Compute
Architecture](https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture) attestation evidence is implemented via `PSA_IOT` and `ARM_CCA` schemes, respectively.

## Endorsements and Trust Anchors

Endorsements and trust anchors for both schemes can be created and provisioned
using [`cocli` command line tool](https://github.com/veraison/cocli). The tool
has [sample
templates](https://github.com/veraison/gen-corim/tree/master/data/templates)
for describing endorsements and trust anchors for both attestation schemes.

Endorsements can also be generated from evidence using [`gen-corim` command
line tool](https://github.com/veraison/gen-corim).


## Attestation Evidence

Attestation evidence can be submitted for verification using [`evcli` command
line tool](https://github.com/veraison/evcli).

Evidence formats for both schemes are defined as [Entity Attestation
Token](https://datatracker.ietf.org/doc/draft-ietf-rats-eat/) (EAT) profiles.
See
[draft-tschofenig-rats-psa-token](https://datatracker.ietf.org/doc/draft-tschofenig-rats-psa-token/)
and
[draft-ffm-rats-cca-token](https://datatracker.ietf.org/doc/draft-ffm-rats-cca-token/).

Library support exists for PSA tokens in [Go](https://github.com/veraison/psatoken).

Library support exists for CCA tokens in [Go](https://github.com/veraison/ccatoken) and [Rust](https://github.com/veraison/rust-ccatoken).

