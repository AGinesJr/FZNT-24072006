# Install FayZawn into Hermes Desktop — safe profile distribution

Source: https://github.com/AGinesJr/FZNT-24072006

## What this package does
- Adds the official Hermes `distribution.yaml` manifest and the authored SOUL, governance, identity references, and a governance skill.
- Does **not** install models, configure OAuth, enable Telegram, add cron jobs, configure an MCP server, or implement a technical privacy/cost routing firewall.
- Does not ship `config.yaml`, credentials, memory databases, conversations, `.env`, `mcp.json`, or `cron/jobs.json`. Existing primary and test profiles must remain unchanged.
- Hermes distributions strip user credentials/memories/sessions on install, and preserve them on update. Nevertheless review the source: this repository is PUBLIC, and any previously tracked seed memories remain public.

## Preconditions
1. Merge the distribution PR into `main`; do not install an unmerged branch as though it were released.
2. Confirm in Hermes Desktop > Bots that the desired **FayZawn** bot does not already have a profile you need to retain.
3. In PowerShell, run `hermes profile list`. If `fayzawn` exists, **stop** rather than using `--force`; assess that profile first.
4. Back up existing profiles first if they contain meaningful data: inspect `hermes backup --help` or use Hermes's profile export. Never upload these backups to this public repo.

## Install as a new profile (one-time)
```powershell
hermes profile install github.com/AGinesJr/FZNT-24072006 --name fayzawn
```
Review the interactive manifest and confirm only if the target is **new**. Do not use `--force`, `--yes`, `--clone`, `--clone-all`, or `hermes profile use`.

The installer fetches the default branch. This does not replace the existing `default` or `codextest` profiles.

## Verify without switching the sticky default
```powershell
hermes profile list
hermes profile show fayzawn
hermes -p fayzawn config get model.provider
hermes -p fayzawn config get model.default
hermes config get model.provider
hermes config get model.default
hermes fallback list
```
Expected original `default` profile: `ollama-launch`, `qwen3.8:27b`, no fallback. The new profile's model must be reviewed; do not assume the distribution assigned a provider. The `fayzawn` profile may require model configuration in Desktop.

## Desktop Bot Mode
Open Bots, select or create the dedicated FayZawn bot, then associate it with the `fayzawn` profile **if that association is offered by the installed Desktop version**. UI labels and whether an existing bot can be bound to an installed profile may vary. Do not re-create or overwrite a profile merely to make the UI match.

Review its SOUL and installed skill, then choose Ollama for initial local use. Keep external actions and cloud routing disabled until approval controls are tested. A desktop bot registration and a Hermes profile are related but are **not automatically the same thing**.

## Updating later
```powershell
hermes profile info fayzawn
hermes profile update fayzawn
```
Review proposed updates first. Do not pass `--force-config` or skip confirmation. Hermes normally preserves local `config.yaml`, memories, credentials and sessions on updates; distribution-owned identity/docs/skill are updated. Back up local edits to distribution-owned files separately before an update.

## Cloud inference safety
Codex OAuth can be logged in even when a selected model is invalid. The previously observed HTTP 400 was caused by attempting `qwen3.8:27b` on the `openai-codex` provider. A working Codex model must be explicitly selected on a **separate, minimal test**; authentication or Plus subscription allowance is not blanket cost/privacy approval.

No automated cloud inference, scheduled messages, external posts, or additional paid API routes are activated by this package.

Official docs: https://hermes-agent.nousresearch.com/docs/user-guide/profile-distributions
