# DEPRECATED: legacy bootstrap is intentionally disabled.
# It previously changed the shared default Hermes SOUL.md and model configuration.
# Use the reviewed Hermes profile distribution instead. This file performs NO actions.
[CmdletBinding()]
param(
  [switch]$AllowHermesInstall,
  [switch]$EnableTelegram,
  [switch]$EnableSchedules,
  [switch]$AllowCloud,
  [switch]$DryRun
)
Write-Error "Legacy FayZawn bootstrap is retired to protect the existing Hermes default profile. Read INSTALL-HERMES-DESKTOP.md and use the dedicated distribution profile after approval."
exit 1
