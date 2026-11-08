# Canonical image publication

Fayt has explicitly authorized publication of the **13 canonical reference JPEGs** to this **PUBLIC** GitHub repository. **LoRA weights are NOT authorized for publication.**

The source photographs are enumerated in `assets-manifest.json` with size and SHA-256 prefix checks. The metadata is committed, but **image bytes have not yet been uploaded** because the connected GitHub write interface does not have access to the local image bytes.

To finish from a Windows checkout, put all 13 original JPEGs in one local directory and run:

```powershell
python scripts/stage_public_images.py --repo "C:\path\to\FZNT-24072006" --source "C:\path\to\images" --confirm-public
git -C "C:\path\to\FZNT-24072006" diff --cached --stat
git -C "C:\path\to\FZNT-24072006" commit -m "assets: publish approved canonical FayZawn references"
git -C "C:\path\to\FZNT-24072006" push origin main
```

This script stages only the approved, hash-verified image names. It deliberately does not stage LoRA weights, train a model, or commit/push without a separate manual action.

Publishing these images exposes them to anyone on the internet, and removing them later does not guarantee deletion from forks or caches.
