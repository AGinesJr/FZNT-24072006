# Local-first visual generation

Status: architecture prepared, **not installed, trained, or runtime-tested**.

Pipeline: select canonical local references → choose outfit from verified catalog → construct prompt with locked identity → generate locally using an installed compatible engine → review face consistency and reject drift → save approved variant with provenance.

Start with reference-conditioned generation before LoRA. Detect existing ComfyUI/other engines; do not overwrite or duplicate installations. Ollama/Qwen provide language inference, not necessarily image generation. Photorealistic default, cinematic/stylized optional. Hardware target: RTX 3070 Laptop 8 GB; choose memory-aware workflows after real diagnostics.

Do not claim a guarantee of identical facial identity. Do not automatically publish outputs.
