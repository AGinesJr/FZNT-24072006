# FayZawn hybrid inference policy — v1.1 (user-approved routing rules)

**Policy selected 2026-11-08:** Allow cloud inference for nonsensitive tasks through **explicitly approved providers**, while requiring explicit approval for sensitive data and paid usage. **Runtime enforcement status: NOT IMPLEMENTED or TESTED.** This document is a contract, not a functioning privacy or billing firewall.

## Approved behavior, not blanket provider authorization
- **Local-first** for sensitive/personal context and whenever cloud eligibility is uncertain.
- **Nonsensitive** prompts may be routed to cloud without per-request approval **only after** Fayt has explicitly approved the specific provider/model route and its terms, billing status, and transmitted-data scope. Authentication alone is NOT provider approval.
- Existing Hermes credentials for Nous Portal and OpenAI Codex are **candidate routes**, not yet approved for unattended routing. No provider-specific approval was given by the general policy choice.
- **Sensitive**: secrets, credentials, personal memories, private files, unpublished work, sensitive personal or third-party data, financial/health/legal records, or messages whose context makes them confidential. Require approval describing destination and minimum payload **for each sensitive transmission**. Approval for one disclosure does not authorize another.
- **Paid**: explicit approval before any incremental charge; no automatic paid API calls or paid fallback. Verify subscription entitlements and quotas; unknown pricing = no automatic cloud routing.
- **Mixed/ambiguous** requests are sensitive until classified or stripped of sensitive context. Tool results, retrievals, system prompts, conversation history, and attachments are included in the data classification, not just the latest user text.
- Approval for inference never approves separate external actions: purchases, public posts, contacting third parties, deleting data, disclosing credentials, or changing core identity/permissions still need their own approval.

## Cost policy
- Incremental paid API budget: **$0** until Fayt explicitly changes it.
- Per-task and daily paid API ceilings: **$0**. No claimed hard spend guarantee unless an actual enforceable mechanism is verified.
- Subscription-included cloud routes are eligible only if their permitted use, limits, and lack of incremental billing are confirmed and Fayt approves the provider.
- Log provider, model, purpose, approval record, estimated and actual charges (when available), and outcome. Never log raw credentials or sensitive prompts.
- Quota exhausted, price unknown, or billing uncertain => stay local, request approval, or stop. Never silently fail over.

## Model routing
1. Local default: existing Ollama `qwen3.8:27b` until a smaller local model is benchmarked and explicitly chosen; preserve existing Hermes config.
2. Approved cloud for nonsensitive work: complex coding, analysis, research, or latency-sensitive tasks where a permitted cloud route improves results.
3. Local 27B specialist for complex private tasks when slower inference is acceptable.
4. No automatic cloud fallback for errors until enforcement tests prove classification, provider allowlist, approval, and cost gates are applied **before** every request.

## Runtime enforcement requirements
- Classify the complete outbound payload, including memory/tool attachments, before dispatch.
- Use a **default-deny provider/model allowlist**, plus explicit per-request consent for sensitive disclosures.
- Enforce paid-route approval and a verified billing cap or block paid routes altogether.
- Disable or guard unreviewed fallbacks, delegated agents, cron, tool-side model calls, and gateways that could bypass policy.
- Do not use `--yolo` or `hermes -z` as a substitute for interactive approvals; oneshot auto-bypasses tool approvals.
- Maintain audit records without private prompt contents; test unauthorized provider, sensitive prompt, paid route, fallback, tool call, and gateway scenarios.
- Back up existing Hermes configuration and identity files before any changes. Do not overwrite sessions, memory, credentials, or the current `SOUL.md`.

## Observed local environment
Hermes 0.23.0, config v52, provider `ollama-launch`, Qwen3.8 27B, gateway running. Nous Portal and OpenAI Codex are authenticated, but their route terms and privacy properties have not been verified. Qwen 27B generated ~1.76 tokens/s warm with thinking disabled and 71% CPU/29% GPU; preserve it while evaluating a smaller everyday model.

## Next implementation gates
1. Inspect `hermes model --help`, `hermes fallback --help`, `hermes config --help`, and `hermes gateway --help`; do not share tokens/config contents.
2. Inspect existing `SOUL.md` headings and model routing settings **locally**, with sanitized output.
3. Confirm which authenticated cloud provider Fayt authorizes first; review entitlement, terms, costs, and privacy.
4. Build and test fail-closed enforcement before switching any provider or enabling unattended routing.
5. Apply only reviewed changes with backup and rollback, then test local and cloud flows.
