# Windows installation preparation — v3.2

**Status:** repository-side plan only. No access to Fayt's Windows machine has been established; nothing is installed or verified there by this commit.

## Safe order
1. Pull latest repository and preserve existing local Hermes, Ollama, Qwen, OpenCode, and Telegram settings. Inventory before modifying anything.
2. Check Windows version, NVIDIA GPU driver, available VRAM, Python, Git, Node, disk space, and existing AI processes.
3. Inspect `scripts/install-fayzawn.ps1` and existing Hermes configuration; run in dry-run/review mode where supported. Do not overwrite `SOUL.md`, memory, or credentials.
4. Stage approved v3.2 clean-base image locally; verify hash and inspect against the manifest.
5. Test reference-conditioned local image generation with compatible existing engine and memory-aware settings.
6. If reference generation fails, evaluate optional local LoRA training with a curated dataset and license review. **Do not publish weights.**
7. Verify FayZawn's assistant behaviors, approval gates, and Telegram schedule separately from visual generation.
8. Capture installation test evidence before marking operational.

## Inventory commands (read-only)
```powershell
git --version
python --version
node --version
nvidia-smi
Get-Command ollama, hermes, opencode -ErrorAction SilentlyContinue | Select-Object Name,Source
Get-Process ollama, python, node -ErrorAction SilentlyContinue | Select-Object ProcessName,Id,Path
```

Do not print API tokens, Telegram bot secrets, or private configuration contents. Installing Hermes, models, and optional image tooling may require downloads, disk, and user decisions.
