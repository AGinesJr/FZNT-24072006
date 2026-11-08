# FayZawn Windows one-step bootstrap (safe reuse mode)

## Run on your own Windows 11 computer

Open PowerShell (not as Administrator) and run this **one command** after reviewing the [installer source](./scripts/install-fayzawn.ps1):

```powershell
$u='https://raw.githubusercontent.com/AGinesJr/FZNT-24072006/main/scripts/install-fayzawn.ps1'; $p=Join-Path $env:TEMP 'install-fayzawn.ps1'; Invoke-WebRequest $u -OutFile $p; & $p -EnableTelegram -EnableSchedules
```

The installer reuses existing Hermes CLI, Ollama models, OpenCode, Qwen, and other tools. It **does not update or reinstall them**. If Hermes CLI is missing, it stops without touching Hermes Desktop; after confirming the desktop doesn't already provide a CLI, rerun with `-AllowHermesInstall` to use the official Hermes Windows installer.

**This is a single-command bootstrap, not a zero-touch guarantee.** The Telegram bot authorization, model/tool validation, and activating the paused scheduled jobs require user confirmation. A safe installer cannot assume or silently acquire a private bot token.

## Switches
- `-DryRun`: inventory tools and model availability; do not change files or settings.
- `-AllowHermesInstall`: if CLI is absent, install it using the official native Windows script (no desktop reinstall requested).
- `-EnableTelegram`: detect already authorized Telegram settings and ensure the gateway when configured.
- `-EnableSchedules`: create missing 08:00, 14:00, 20:00 Eastern review jobs **paused** (only if Telegram is configured).
- `-AllowCloud`: show manual OAuth/OpenRouter setup instructions, **never** enable paid API fallback automatically.

## Files and safety
- Local workspace: `%LOCALAPPDATA%\hermes\fayzawn` (or `HERMES_HOME\fayzawn`).
- Backups: `HERMES_HOME\fayzawn-backups\<timestamp>`.
- Existing `memories/USER.md` and `memories/MEMORY.md` are preserved; approved seeds are stored separately for review.
- Existing `config.yaml` is backed up before model selection.
- No tokens are printed, downloaded from GitHub, or committed.
- Telegram traffic and cloud inference are **not** private/offline. Local Ollama inference is local, but any enabled web tools can still transmit data.
- No automatic download of models, skills, dependencies, or toolchains.
- Scheduled reviews use a local model if Ollama is detected and configured; verify tool support before resuming.
- If an existing Hermes CLI is on PATH, its version is not changed.
- The script does not register a Windows login service. To opt in after testing, run `hermes gateway install`.

## Existing Qwen and other local models
The bootstrap queries the running Ollama API and chooses an existing Qwen 7B/8B/14B/coder model if available; otherwise it uses the first installed Ollama model. It never pulls another model. If Qwen is installed outside Ollama, use `hermes model` to select its existing compatible endpoint manually.

## ChatGPT and OpenRouter
Hermes supports ChatGPT/Codex OAuth through `hermes model` → ChatGPT or Codex Subscription, subject to your actual plan's eligibility and usage limits. **ChatGPT web subscription is not an unlimited free API.** OpenRouter can offer free-tier models subject to quotas, and paid models may bill your account. No automatic cloud fallback is enabled. Local inference has no per-token provider bill but is bounded by compute, memory and electricity.

## Final checks
```powershell
hermes --version
ollama list
hermes doctor
hermes chat
hermes cron list
hermes cron status
```
Then open Hermes Desktop → Messaging → Telegram to authorize your own account, or run `hermes gateway setup`. Confirm a working private chat and manually resume each named FayZawn review job. Test one job before enabling all. Verify the selected Qwen model can reliably call tools; not every Qwen checkpoint supports agentic actions.

Official references: https://hermes-agent.nousresearch.com/docs/user-guide/windows-native , https://hermes-agent.nousresearch.com/docs/guides/local-ollama-setup , https://hermes-agent.nousresearch.com/docs/user-guide/messaging/telegram , https://hermes-agent.nousresearch.com/docs/user-guide/features/cron
