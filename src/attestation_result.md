# Attestation Results

Attestation results produced by [Remote Attestation
Services](services/overview.md) are in [EAT Attestation
Result](https://datatracker.ietf.org/doc/draft-fv-rats-ear/) (EAR) format.

There is library support for working with EARs available for
[Go](https://github.com/veraison/ear),
[Rust](https://github.com/veraison/rust-ear),
[C](https://github.com/veraison/c-ear), and
[Python](https://github.com/veraison/python-ear) languages.

At the core of an EAR is a Trust Vector defined by [AR4SI IETF
Draft](https://datatracker.ietf.org/doc/draft-ietf-rats-ar4si/), which breaks
down the appraisal of attestation evidence into eight categories (a
particular [Attestation Scheme](services/schemes/overview.md) may not utilize
all of the categories).

EARs maybe serialised as either [JWT](https://www.ietf.org/rfc/rfc7519.html) or
[COSE](https://www.ietf.org/rfc/rfc9052.html) messages ([Remote Attestation
Services](services/overview.md) produces results as JWT only).

## Example attestation result

This is JSON serialization of a sample attestation result as produced by
[Remote Attestation Services](services/overview.md) for Arm PSA evidence.

```json
{
    "ear.status": "affirming",
    "ear.trustworthiness-vector": {
      "instance-identity": 2,
      "configuration": 0,
      "executables": 2,
      "file-system": 0,
      "hardware": 2,
      "runtime-opaque": 2,
      "storage-opaque": 2,
      "sourced-data": 0
    },
    "ear.appraisal-policy-id": "policy:PSA_IOT",
    "ear.veraison.annotated-evidence": {
      "eat-profile": "http://arm.com/psa/2.0.0",
      "psa-client-id": 1,
      "psa-security-lifecycle": 12288,
      "psa-implementation-id": "YWNtZS1pbXBsZW1lbnRhdGlvbi1pZC0wMDAwMDAwMDE=",
      "psa-boot-seed": "3q2+796tvu/erb7v3q2+796tvu/erb7v3q2+796tvu8=",
      "psa-software-components": [
        {
          "measurement-type": "BL",
          "measurement-value": "h0KPxSKAPTEGXnvOPPA/5HUJZjHl4Hu9eg/eYMTPJcc=",
          "signer-id": "rLsRx+TaIXIFUjzkzhokWuGiOa48a/2eeHH35di66Gs=",
          "version": "2.1.0"
        },
        {
          "measurement-type": "PRoT",
          "measurement-value": "AmOCmYm2/ZVPcrqvL8ZLwuLwHWktTecphuqAj26ZgT8=",
          "signer-id": "rLsRx+TaIXIFUjzkzhokWuGiOa48a/2eeHH35di66Gs=",
          "version": "1.3.5"
        },
        {
          "measurement-type": "ARoT",
          "measurement-value": "o6XnFfDMV0pzw/m+u2vCTzL/1bZ7OHJEwskJ2neaFHg=",
          "signer-id": "rLsRx+TaIXIFUjzkzhokWuGiOa48a/2eeHH35di66Gs=",
          "version": "0.1.4"
        }
      ],
      "psa-instance-id": "Ac7rrnuJJ6MiflMDz14PH3s0u1Qq1yUKwD+83jbsLxUI",
      "psa-verification-service-indicator": "https://psa-verifier.org",
      "psa-nonce": "QUp8F0FBs9DpodKK8xUg8NQimf6sQAfe2J1ormzZLxk="
    }
}
```


