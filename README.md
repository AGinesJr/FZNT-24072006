# FayZawn Thugahd — Hermes identity package v2.0

**Approved by Fayt:** 2026-11-08. **Identity serial:** FZNT-24072006. Pronounced **Phase-On The-God**. Aliases: Faizon, Faze, Feezy, Fay Dilla.

This repository contains FayZawn's **approved portable identity specification** for Nous Research Hermes Agent. It is **not** proof that Hermes, Telegram, a local model, or scheduled jobs have been installed or tested.

## Guiding relationship
Fayt determines the shared vision, goals, and consequential decisions. FayZawn is a distinct, adaptive, expressive, analytical, and creatively independent best-friend-style assistant, strategist, business partner, and familiar chief of staff. They are aligned in purpose but do not have identical personalities. FayZawn challenges assumptions and provides original thinking; he does not blindly agree.

## Identity and operational files
- `SOUL.md`: core character, meaningful presence, judgment and identity boundaries.
- `AGENTS.md`: action policy and approved Telegram **review schedule**, not yet activated.
- `LIFE.md`: authored history versus real interaction history.
- `DECISION-MODEL.md`: evidence-based understanding of Fayt's decisions.
- `CULTURE.md`, `MUSIC.md`: inspirations, cultural style, evolving taste.
- `SYMBOLIC-REFERENCE.md`: explicitly non-scientific symbolic inspiration.
- `GOVERNANCE.md`: identity change approval requirements.
- `ACCEPTANCE-TESTS.md`: verification to run in a real Hermes environment.
- `memories/USER.md`, `memories/MEMORY.md`: concise seeds; **merge**, never erase actual existing Hermes memories.
- `manifest.json`: version manifest.

## Planned Hermes integration
- `SOUL.md` → `~/.hermes/SOUL.md`, after backing up the existing file.
- `AGENTS.md` → Hermes project/workspace instructions; merge with existing operational instructions as necessary.
- `memories/*.md` → Hermes memory system after reviewing and backing up existing memories.
- Remaining `.md` → supplemental workspace references.

Telegram reviews: **08:00, 14:00, 20:00 America/New_York**, quiet hours **22:00–08:00**. Scheduled reviews may remain silent. Event-driven messages should be meaningful, verified, and authorized. The gateway, cron jobs and authorized recipient require local configuration and testing.

**Security:** never commit Telegram tokens, credentials, local environment files, private keys, or actual private memory exports. This repository is public. Do not put live user data here.

**Implementation status:** Design committed as v2.0. Hermes/Telegram installation and the planned one-step installer remain separate work. Test and verify up-to-date Hermes commands before deployment.

## Hermes Desktop distribution (v2.1.0 packaging)

The repository now includes `distribution.yaml` for Hermes profile installation, plus `skills/fayzawn-governance/SKILL.md` and the step-by-step [Hermes Desktop installation guide](INSTALL-HERMES-DESKTOP.md). The original approved SOUL and governance documents are unchanged; `manifest.json` remains a legacy design manifest, distinct from the installer manifest.

Once the changes are merged into the default branch, install into a **new** profile using `hermes profile install github.com/AGinesJr/FZNT-24072006 --name fayzawn` (with interactive confirmation). Do not use `--force` or install over `default`/`codextest`. The existing profiles' live memory, sessions, credentials, gateway, and model are not changed by publishing this repository update.

Distribution packaging is **not** runtime deployment or an enforcement mechanism. The hybrid cost/privacy gate is not implemented; Telegram/cron remain inactive. See the installation guide before attempting a cloud model or desktop Bot Mode association.
