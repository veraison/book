# Veraison Remote Attestation

[Introduction](introduction.md)

- [Overview](overview.md)
- [Remote Attestation Services](services/overview.md)
    - [Architecture](services/architecture.md)
        - [Device and Supply Chain modelling](submods/docs/musings/device-and-supply-chain-modelling.md)
        - [Endorsement Queries](submods/docs/musings/queries.md)
        - [Attestation Tokens](submods/docs/musings/token-assumptions.md)
        - [Verification Machinery](submods/docs/musings/verification-machine.md)
        - [Veraison in a TEE](submods/docs/musings/veraison-in-a-tee.md)
    - [Deployments](services/deployments/overview.md)
        - [aws](services/deployments/aws.md)
        - [debian](services/deployments/debian.md)
        - [docker](services/deployments/docker.md)
        - [native](services/deployments/native.md)
        - [rpm](services/deployments/rpm.md)
    - [Configuration](services/configuration.md)
    - [Attestation Schemes](services/schemes/overview.md)
        - [Arm PSA and CCA](services/schemes/psa_and_cca.md)
        - [DICE](services/schemes/dice.md)
    - [Policies](services/policies.md)
    - [API](services/api/overview.md)
        - [Provisioning](services/api/provisioning.md)
        - [Challenge/Response](services/api/verification.md)
        - [Policy Management](services/api/management.md)
- [Endorsement and Reference Value Provisioning](provisioning.md)
    - [Extending CoRIM](extending-corim.md)
- [Attestation Results](attestation_result.md)
- [`Endorsement Distribution API`](submods/docs/musings/endorsement-api.md)
- [`Conceptual Message Collection Daemon`](ratsd.md)

