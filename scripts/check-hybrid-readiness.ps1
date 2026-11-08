# Read-only inventory for FayZawn hybrid inference. Does not inspect or print secrets.
$ErrorActionPreference = "Continue"
Write-Host "=== HERMES ==="
hermes --version
hermes status
Write-Host "`n=== MODEL AND FALLBACK COMMANDS ==="
hermes model --help
hermes fallback --help
Write-Host "`n=== CONFIG COMMAND HELP (not config contents) ==="
hermes config --help
Write-Host "`n=== GATEWAY COMMAND HELP ==="
hermes gateway --help
Write-Host "`n=== OLLAMA ==="
ollama list
ollama ps
Write-Host "`n=== PERSONA FILE METADATA ==="
$soul = Join-Path $env:LOCALAPPDATA 'hermes\SOUL.md'
if (Test-Path $soul) {
  Get-Item $soul | Select-Object FullName, Length, LastWriteTime
  Get-Content $soul | Where-Object { $_ -match '^#{1,6}\s' }
}
Write-Host "`n=== FREE DISK SPACE ==="
Get-CimInstance Win32_LogicalDisk | Where-Object DriveType -eq 3 |
  Select-Object DeviceID, @{N='FreeGB';E={[math]::Round($_.FreeSpace/1GB,1)}}
Write-Host "`nDo not share secrets, tokens, or unredacted configuration files."
