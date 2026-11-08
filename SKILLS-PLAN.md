# Recommended Hermes skills — installation policy

**Reuse existing installed skills. Do not bulk-install from unverified sources.** Skills may execute shell commands and handle sensitive data; review each before enabling.

## Core (already supported by Hermes)
- File and terminal operations, Git/GitHub workflows, research verification, cron scheduling, persistent memory.
- Decision modeling: use `DECISION-MODEL.md`; separate evidence from symbolic hypotheses.
- Identity governance: use `GOVERNANCE.md`; require approval for core changes.
- Meaningful Telegram reviews: use `AGENTS.md`; silence is valid.

## Optional, after functional tests
- Browser/web research, local document and PDF analysis, spreadsheets, coding assistance, backup/restore, music analysis.
- Add one at a time using Hermes' official skills UI/CLI; check prerequisites, permissions, tool reliability, and data handling.
- Existing OpenCode is an optional external coding tool; bootstrap does not install or modify it.

Official catalog: https://github.com/NousResearch/hermes-agent/tree/main/skills
Official skills documentation: https://hermes-agent.nousresearch.com/docs/user-guide/features/skills

No third-party skill is installed automatically. This prevents double installations, supply-chain surprises, and unapproved data access.
