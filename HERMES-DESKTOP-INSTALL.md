# Install FayZawn as a Hermes Desktop Bot

This repository is a Hermes **profile distribution**, using `distribution.yaml`. The distribution name is `fayzawn`. Hermes Desktop Bot Mode displays profiles as Bots. The package includes the approved `SOUL.md` and an on-demand `fayzawn-guide` skill with reviewed, public reference documents.

**Status:** GitHub packaging only. Installation and runtime behavior still require verification on the user's Windows desktop.

## Before installing
1. Review the current branch/PR before merging; install from `main` only after merge.
2. Make a local Hermes backup via its documented backup/export controls. Never commit that backup, `.env`, credentials, memory, or session databases to GitHub.
3. In Hermes Desktop → Bots, see whether a Bot/profile named `fayzawn` already exists. If it does, **do not run the install command over it**: review its data and choose an unused profile name instead or plan a separate, approved migration.
4. Keep `default` and `codextest` unchanged. Don't clone main-profile memory or credentials to test cloud models.

## Install the distribution (one-time command)
After the PR is merged and the name is available, run this in **PowerShell**, not inside a Hermes chat:

```powershell
hermes profile install https://github.com/AGinesJr/FZNT-24072006.git --name fayzawn
```

Read the installation preview and confirm only when the preview matches this document. Do **not** use `--force`, `--yes`, or `--alias` during the first install.

The same `fayzawn` profile should then be available through Hermes Desktop's Bots interface. If the interface requires selecting or refreshing a profile, do so without creating a duplicate.

## Configure locally in Hermes Desktop
- Bot display name: FayZawn Thugahd; profile identifier: `fayzawn`.
- Select local Ollama model `qwen3.8:27b` if it is installed and present in the model picker. This distribution intentionally contains **no `config.yaml`** and does not override provider/model settings.
- Leave cloud fallback disabled. Codex Plus and Nous Free authentication/quotas are not permission to use cloud automatically.
- Do not enable Telegram, scheduled routines, plugin installs, paid services, or unsupervised tool access yet.
- Review `SOUL.md` in Bot settings and enable the `fayzawn-guide` skill if per-Bot skill toggles are shown.
- Existing curated `memories/*.md` in the GitHub design are **not imported as live memory** by the distribution. Review any memory seeds manually, with provenance, rather than copying over existing memory.

## Verify
From **PowerShell**, after installation:

```powershell
hermes profile show fayzawn
hermes -p fayzawn config get model.provider
hermes -p fayzawn config get model.default
hermes -p fayzawn fallback list
hermes config get model.provider
hermes config get model.default
```

Expected primary profile: `ollama-launch` / `qwen3.8:27b`; no changes to `default`. For the new profile, select a local model explicitly if the initial provider/model differ.

Test with a nonsensitive local prompt in Hermes Desktop and confirm FayZawn follows his persona without claiming invented memories or actions.

## Updating from GitHub
After reviewing a future release and confirming the installed profile uses this distribution:

```powershell
hermes profile info fayzawn
hermes profile update fayzawn
```

Hermes preserves profile-local memories, sessions, and credentials on distribution updates, but replaces distribution-owned SOUL and skill reference files. Do not use `--force-config`. Review changes and keep a backup for rollback.

## Boundaries
The files are instructions and **do not technically enforce** a network egress firewall or a $0 paid-API spending cap. A tested, fail-closed cloud router is future work. The distribution itself installs no cloud configuration, autonomous schedule, or messaging recipient.

Docs: https://hermes-agent.nousresearch.com/docs/user-guide/profile-distributions
