# Read-only repository preflight. Run from the repository root after reviewing.
# No network, profile, or Hermes configuration modifications.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$required = @('distribution.yaml','SOUL.md','AGENTS.md','GOVERNANCE.md',
  'HYBRID-INFERENCE-POLICY.md','skills/fayzawn-governance/SKILL.md',
  'INSTALL-HERMES-DESKTOP.md')
$fail = @()
foreach ($f in $required) {
  if (-not (Test-Path (Join-Path $root $f) -PathType Leaf)) { $fail += "Missing required: $f" }
}
foreach ($f in @('config.yaml','.env','auth.json','memories/USER.md','memories/MEMORY.md','cron/jobs.json','mcp.json')) {
  if (Test-Path (Join-Path $root $f)) { $fail += "Unexpected distributed state: $f" }
}
$manifest = Get-Content (Join-Path $root 'distribution.yaml') -Raw
if ($manifest -notmatch '(?m)^name:\s*fayzawn\s*$') { $fail += 'Wrong distribution name' }
if ($manifest -match '(?m)^\s*-\s*(config.yaml|memories/|sessions/|\.env|auth.json)') { $fail += 'Unsafe distribution-owned entry' }
$legacy = Get-Content (Join-Path $root 'scripts/install-fayzawn.ps1') -Raw
if ($legacy -match 'Invoke-WebRequest|config\s+set|CopySafe|Invoke-RestMethod') { $fail += 'Legacy installer still contains active bootstrap operations' }
if ($fail.Count) { $fail | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host 'PASS: static distribution-source preflight. This does not validate Hermes installation, privacy routing, or Git history.'
