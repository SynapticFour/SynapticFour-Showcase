# Key custody — one-pager

**Audience:** security / procurement
**Products:** Ferrum · Solum (shared Crypt4GH family)
**Date:** 2026-08-12

---

## Default model (pilots and on-prem)

| Principle | Practice |
|-----------|----------|
| **Customer-held keys** | Operator generates and stores Crypt4GH key material; Synaptic Four does not hold production keys |
| **At rest** | Objects/fields encrypted under operator keys when Crypt4GH is enabled |
| **In process** | Encrypt/decrypt **briefly touches plaintext in memory** — not TEE/HSM enclave today |
| **Revocation** | Operator rotates keys + Passport/OIDC credentials on staff turnover; products do not replace HR offboarding |

---

## Ferrum

- Node master key encrypts DRS objects when Crypt4GH enabled.
- Download **re-wraps header** for requester pubkey **after** authorization.
- Optional plaintext `/stream` over TLS — enable only with eyes open (see Ferrum CRYPT4GH.md).
- Edge/Pi: same model; stolen-device risk → encrypt at rest + wipe runbook.

## Solum

- **CustomerHeld** files via CLI/sidecar (`--keypair`, `--keys-dir`) — default.
- **Optional AWS KMS:** wraps Crypt4GH **seed** at rest; unwrap still loads seed into process memory. Not required; not multi-cloud complete (Azure/etc. backlog-only under spine freeze).
- Never use ephemeral keys in regulated pilot profiles.

---

## Staff turnover checklist

1. Remove person from IdP groups / Passport issuers.
2. Rotate gateway/sidecar secrets and Crypt4GH keys if they had filesystem access.
3. Review audit export for anomalous access.
4. Update this site’s IR contacts.

---

## What we do **not** claim

- Cryptographic zero-knowledge for all processing
- HSM-backed X25519 inside AWS KMS native
- Synaptic Four as key custodian in Stage-1 on-prem

---

## Related

- Ferrum [CRYPT4GH.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/CRYPT4GH.md) · [THREAT_MODEL.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/THREAT_MODEL.md)
- Solum [CRYPTO.md](https://github.com/SynapticFour/Solum/blob/main/docs/CRYPTO.md) · [SECURITY-OVERVIEW.md](https://github.com/SynapticFour/Solum/blob/main/docs/customer/SECURITY-OVERVIEW.md)
- [co-custody.md](co-custody.md)
