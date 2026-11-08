# FayZawn Windows bootstrap v1 - PowerShell 5.1+; non-destructive and idempotent.
[CmdletBinding()]
param([switch]$AllowHermesInstall,[switch]$EnableTelegram,[switch]$EnableSchedules,[switch]$AllowCloud,[switch]$DryRun)
$ErrorActionPreference='Stop'
$repo='https://raw.githubusercontent.com/AGinesJr/FZNT-24072006/main'
$homeDir=if($env:HERMES_HOME){$env:HERMES_HOME}else{Join-Path $env:LOCALAPPDATA 'hermes'}
$work=Join-Path $homeDir 'fayzawn'
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss'
$backup=Join-Path $homeDir "fayzawn-backups\$stamp"
$log=Join-Path $env:TEMP "fayzawn-bootstrap-$stamp.log"
function Note([string]$s){Write-Host "[FayZawn] $s"; Add-Content -LiteralPath $log -Value $s}
function Cmd([string]$n){Get-Command $n -ErrorAction SilentlyContinue}
function CopySafe([string]$src,[string]$dest){
 if(Test-Path -LiteralPath $dest){$old=Join-Path $backup ($dest.Substring($homeDir.Length).TrimStart('\'));New-Item -ItemType Directory -Force -Path (Split-Path $old) | Out-Null;Copy-Item -LiteralPath $dest -Destination $old -Force}
 if(-not $DryRun){New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null;Copy-Item -LiteralPath $src -Destination $dest -Force}
}
function H([string[]]$arguments){ & hermes @arguments; if($LASTEXITCODE -ne 0){throw "Hermes command failed: $($arguments -join ' ')" }}
Note "Starting; no package upgrades, no Ollama model pulls, no OpenCode or Qwen installs."
Note "Hermes home: $homeDir; backup: $backup"
foreach($n in @('hermes','ollama','opencode','git','python','node')){ $c=Cmd $n; if($c){Note "$n: $($c.Source)"}else{Note "$n: not found in PATH"} }
$hermesCmd=Cmd 'hermes'
if(-not $hermesCmd){
 $launcher=Join-Path $homeDir 'bin\hermes.exe'
 if(Test-Path $launcher){$env:PATH=(Split-Path $launcher)+';'+$env:PATH;$hermesCmd=Cmd 'hermes'}
}
if(-not $hermesCmd){
 if(-not $AllowHermesInstall){Note 'Hermes CLI not found. Hermes Desktop may exist without PATH launcher. No install attempted. Re-run with -AllowHermesInstall only if needed.';return}
 if($DryRun){Note 'Dry run: would install Hermes CLI using official script.';return}
 $official=Join-Path $env:TEMP "hermes-official-install-$stamp.ps1"
 Invoke-WebRequest -Uri 'https://hermes-agent.nousresearch.com/install.ps1' -OutFile $official
 Note "Official installer downloaded to $official; running noninteractive (no desktop reinstall)."
 & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $official -NonInteractive
 if($LASTEXITCODE -ne 0){throw 'Hermes CLI install failed'}
 $env:PATH=(Join-Path $homeDir 'bin')+';'+$env:PATH
 if(-not (Cmd 'hermes')){throw 'Hermes installer finished but CLI is not accessible. Open a new PowerShell terminal.'}
}
Note "Hermes: $((& hermes --version 2>&1) -join ' ')"
$tags=$null
try{$tags=Invoke-RestMethod -Uri 'http://127.0.0.1:11434/api/tags' -TimeoutSec 5}catch{Note 'Ollama endpoint unavailable; will not install or launch Ollama.'}
$models=@()
if($tags -and $tags.models){$models=@($tags.models | ForEach-Object {$_.name});Note ('Existing Ollama models: '+($models -join ', '))}
$choice=$null
if($models.Count -gt 0){
 $choice=@($models | Where-Object {$_ -match 'qwen' -and $_ -match '(7b|8b|14b|coder)' } | Select-Object -First 1)[0]
 if(-not $choice){$choice=$models[0]}
 Note "Chosen existing local model: $choice (verify tool calling separately)."
}else{Note 'No running Ollama models detected; leave existing model provider configuration unchanged.'}
if($DryRun){Note 'Dry run: no files or config changed.';return}
New-Item -ItemType Directory -Force -Path $work,$backup | Out-Null
$files=@('SOUL.md','AGENTS.md','LIFE.md','DECISION-MODEL.md','CULTURE.md','MUSIC.md','SYMBOLIC-REFERENCE.md','GOVERNANCE.md','ACCEPTANCE-TESTS.md')
foreach($f in $files){
 $tmp=Join-Path $env:TEMP "fayzawn-$stamp-$f"
 Invoke-WebRequest -Uri "$repo/$f" -OutFile $tmp
 CopySafe $tmp (Join-Path $work $f)
 Remove-Item $tmp -Force
}
# Identity is backed up, then installed; existing USER/MEMORY are deliberately never overwritten.
CopySafe (Join-Path $work 'SOUL.md') (Join-Path $homeDir 'SOUL.md')
foreach($f in @('USER.md','MEMORY.md')){
 $dest=Join-Path $homeDir "memories\$f"
 $seed=Join-Path $work "seed-$f"
 Invoke-WebRequest -Uri "$repo/memories/$f" -OutFile $seed
 if(-not (Test-Path $dest)){CopySafe $seed $dest;Note "Created missing memory file $f"}else{Note "Preserved existing memory $f; seed available at $seed for review."}
}
# Cron jobs can load the workspace AGENTS.md with --workdir.
$config=Join-Path $homeDir 'config.yaml'
if(Test-Path $config){Copy-Item $config (Join-Path $backup 'config.yaml') -Force}
if($choice){
 try{
  H @('config','set','model.provider','custom')
  H @('config','set','model.base_url','http://127.0.0.1:11434/v1')
  H @('config','set','model.default',$choice)
  Note "Hermes configured to use existing Ollama model $choice."
 }catch{Note "WARNING: model configuration failed; restore backup if needed. $($_.Exception.Message)"}
}
if($AllowCloud){
 Note 'Cloud providers are opt-in. Run hermes model and choose ChatGPT/Codex Subscription OAuth or OpenRouter manually. No cloud API keys are installed, and no automatic paid fallback is configured.'
}else{Note 'Cloud disabled by policy of this bootstrap: no paid provider/fallback added.'}
if($EnableTelegram){
 $envFile=Join-Path $homeDir '.env'
 $raw=if(Test-Path $envFile){Get-Content $envFile -Raw}else{''}
 if($raw -notmatch '(?m)^TELEGRAM_BOT_TOKEN=\S+' -or $raw -notmatch '(?m)^TELEGRAM_ALLOWED_USERS=\d+'){
  Note 'Telegram not configured: use Hermes Desktop Messaging > Telegram Create with QR, or hermes gateway setup. Do not paste token into this script.'
 }else{
  Note 'Existing Telegram token and allowed user ID found (not printed).'
  try{H @('gateway','ensure')}catch{Note "Gateway ensure requires manual review: $($_.Exception.Message)"}
 }
}
if($EnableSchedules){
 $envFile=Join-Path $homeDir '.env'
 $raw=if(Test-Path $envFile){Get-Content $envFile -Raw}else{''}
 if($raw -notmatch '(?m)^TELEGRAM_BOT_TOKEN=\S+' -or $raw -notmatch '(?m)^TELEGRAM_ALLOWED_USERS=\d+'){
  Note 'Schedules NOT created: configure and authorize Telegram first.'
 }else{
  $existing=(& hermes cron list 2>&1) -join "`n"
  $jobs=@(@('08:00','0 8 * * *','morning'),@('14:00','0 14 * * *','afternoon'),@('20:00','0 20 * * *','evening'))
  foreach($j in $jobs){
   $name="FayZawn-$($j[2])-review"
   if($existing -match [regex]::Escape($name)){Note "Existing job $name preserved.";continue}
   $prompt="FayZawn $($j[2]) review. Examine only accessible, verified updates relevant to Fayt. If nothing material warrants a message, respond [SILENT]. Never fabricate activity, urgency, memories or opportunities. Respect quiet hours, approval rules and the meaningful-presence principle."
   try{H @('cron','create',$j[1],$prompt,'--timezone','America/New_York','--name',$name,'--deliver','telegram','--workdir',$work,'--grace-minutes','0','--paused','--paused-reason','Verify gateway and local model before enabling');Note "Created paused job $name."}catch{Note "WARNING: Could not create $name: $($_.Exception.Message)"}
  }
  Note 'Schedules are PAUSED for a controlled canary. Verify with hermes cron list; resume individually when ready.'
 }
}
Note 'Bootstrap complete. Run hermes chat to test local inference; hermes doctor; hermes cron list. Review logs and backups. No services auto-installed or cloud spend enabled.'
