# FayZawn visual identity & autonomous style v3.0

**Implementation status:** design, specifications, local asset-ingestion CLI and offline fashion catalog CLI committed. No user images or LoRA weights published. No LoRA trained, model downloaded, image engine installed, or local integration verified.

## Decisions
1. Very strict recognizable face across every representation.
2. Realistic hair and beard variation within identity lock.
3. FayZawn chooses outfits independently within existing governance.
4. Real-product catalog with price, budget, and alternatives.
5. Photorealistic default; optional cinematic/stylized versions.
6. Autonomous evolving style, informing Fayt of significant changes.
7. Canonical uploads can support local LoRA training after compatibility testing.

## Public visibility gate
This repository is **PUBLIC** as of 2026-11-08. Before committing any canonical uploaded photographs or identity LoRA weights, obtain a distinct explicit user confirmation that those specific assets may be published to a public repository. GREENLIGHT for implementation is not a substitute for this informed publication decision. This gate does not prevent committing source code, manifests, and design documentation.

## Local first-run commands
```powershell
python scripts/visual_assets.py ingest --source "C:\path\to\reference.png" --kind face-front
python scripts/visual_assets.py list
python scripts/fashion_catalog.py list
python scripts/fashion_catalog.py verify
```

No package installation needed for these commands. Files are saved under `%LOCALAPPDATA%\FayZawn` and not pushed to GitHub.

## Next integration milestones
- Confirm public release of specific photo assets or keep private locally.
- Inspect the Windows machine for existing visual-generation engines and compatible checkpoints.
- Validate reference-based local generation, then determine whether a LoRA is useful and feasible.
- Integrate the optional visual tools into Hermes only after model, resource, and permission tests.
- Return to Hermes/Ollama/Telegram bootstrap testing without replacing existing installations.
