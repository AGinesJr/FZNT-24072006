# Canonical photo manifest and publication gate

The conversation contains uploaded images depicting FayZawn's proposed face, expressions, full-body front/back, and outfit variations. **No binary images have been committed to this repository.**

**Repository visibility verified: PUBLIC (2026-11-08).** A user selected inclusion *subject to explicit public visibility review*. Their GREENLIGHT authorizes implementation, but is not by itself the additional explicit confirmation to publish these particular images in a public repository. **Do not upload photos or LoRA weights until the user explicitly confirms public publication after seeing this status.**

When approved, ingest originals from the user's local machine via `scripts/visual_assets.py ingest --source PATH --kind ...`; inspect and manually classify. Default storage is local private `%LOCALAPPDATA%/FayZawn/visual-assets`. The script refuses publication; publishing to GitHub requires a separate reviewed Git action.

Recommended classifications: face-front, face-three-quarter, expression-grid, body-front, body-back, outfit-reference. Assign SHA-256 and metadata; retain original files unchanged. Avoid committing source screenshots with device UI if cleaner originals exist. Never assume that an image is licensed for public distribution without confirming ownership/permissions.

LoRA weights are also potentially identity-revealing and may be too large for ordinary Git. Keep private until a separate release decision; check license, GitHub limits, and whether Git LFS is appropriate.
