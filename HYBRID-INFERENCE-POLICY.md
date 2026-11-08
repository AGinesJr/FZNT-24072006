# FayZawn hybrid inference policy — proposed v1

**State: design and test specification; NOT yet enforced by Hermes.** Approved direction: local-first, controlled cloud escalation, preserve current installation and settings. Do not claim this Markdown implements a runtime router.

## Observed environment (2026-11-08)
- Hermes Agent 0.23.0, local config v52; provider `ollama-launch`, model `qwen3.8:27b`; gateway running; no messaging platforms.
- Ollama 0.40.15; `qwen3.8:27b` Q4_K_M, 27.3B, 17GB disk; 71% CPU / 29% GPU at 4096 context.
- Benchmark: first test 100 generated tokens at 1.38 tok/s, blank visible response; warm `think=false` test returned "FayZawn is online." in 8 tokens, 4.55s generation (~1.76 tok/s). Model works but is too slow for responsive primary chat.
- Hermes reports Nous Portal and OpenAI Codex authenticated. Auth does not guarantee free or unlimited inference.
- Existing `SOUL.md`, `USER.md`, 20 sessions, 2,190 messages; preserve.
- Hermes image generation and Telegram dependencies are not ready.

## Routing tiers
1. **Local default**: personal context, sensitive content, routine Q&A, drafting, offline tasks. Keep existing Qwen model until a smaller local candidate passes evaluation; do not auto-download or change model.
2. **Cloud candidate**: user-approved difficult coding, long analysis, advanced planning, or local failure. Candidate providers: already authenticated Nous Portal and OpenAI Codex, subject to verified entitlement and pricing. Do not automatically send confidential content.
3. **Local specialist**: existing 27B model can be invoked intentionally for difficult private work when latency is acceptable.

## Hard approval gates
- No automatic cloud transmission until Fayt approves **both** the provider and the data category; present a concise description of what will be transmitted and whether attachments/memory are included.
- Explicit approval before first use of a paid API route and before any change to spend limits, model provider, data retention policy, or third-party recipients.
- All consequential external actions (spend, purchases, publishing, contacting third parties, deletion, secrets, core identity or permissions) require separate approval regardless of inference provider.
- Never bypass approval using Hermes `--yolo`, `-z` oneshot (auto-bypasses approvals), or unrestricted cron/agent automation.
- Unknown price, quota, billing status, or privacy classification => **no cloud escalation**; request clarification or remain local.

## Initial budget policy (pending Fayt confirmation)
- Default **$0 approved incremental paid API spend**.
- No automatic paid API calls; account-included subscription routes require verified entitlement and explicit provider approval, even if estimated marginal price is $0.
- Before each cloud call show provider, model, expected data transmitted, estimated cost if knowable, and reason. Log actual usage/cost when provider exposes it; never misrepresent unknown charges as $0.
- Per-task and daily monetary ceilings remain $0 until Fayt explicitly sets amounts. If the route cannot enforce a hard cap, do not describe it as hard-capped.
- Stop cloud routing when cap is reached, usage cannot be reliably checked, or credentials fail; do not silently fail over to a paid provider.

## Privacy and audit
- Minimize cloud payload; omit secrets, unnecessary chat history, and memory by default.
- Keep a local decision log: timestamp, task category, chosen route, reason, approval reference, model, estimated/actual charge, status. Exclude raw sensitive prompts and credentials.
- For Telegram, authenticate recipient before enabling gateway. Quiet hours and review schedule remain governed by AGENTS.md.
- Never commit private local `.env`, Hermes config, logs, or memory.

## Implementation gates
1. Capture sanitized Hermes status, model/fallback/config command help; inspect `SOUL.md` headings without revealing secrets.
2. Benchmark a smaller locally compatible tool-capable model after Fayt approves any download. Compare latency, quality, tool calls, memory, VRAM.
3. Confirm Hermes-supported routing/fallback mechanisms; fallback alone is not an approval or privacy firewall.
4. Implement a fail-closed approval and cost enforcement wrapper or supported gateway control; test no unapproved cloud calls, no over-budget calls, and no private payload leakage.
5. Only then change local Hermes configuration with a timestamped backup and rollback; test end-to-end.
