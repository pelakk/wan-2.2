# ComfyUI-WAN Docker Image

Docker image for ComfyUI with WAN (World Animate Network) 2.2 support.

## Features

- ComfyUI with WAN 2.2 models
- Pre-installed custom nodes for video generation
- JupyterLab interface
- Automatic model downloading
- GPU acceleration support

## Usage

```bash
docker run -d \
  --gpus all \
  -p 8188:8188 \
  -p 8888:8888 \
  -v $(pwd)/workspace:/workspace \
  pelakk/comfyui-wan:latest
```

## Ports

- `8188` - ComfyUI Web Interface
- `8888` - JupyterLab Interface

## Environment Variables

- `download_vace=true` - Download additional VACE models
- `CHECKPOINT_IDS_TO_DOWNLOAD` - Comma-separated CivitAI model IDs
- `LORAS_IDS_TO_DOWNLOAD` - Comma-separated LoRA model IDs

## Model Storage

Models are automatically downloaded on first run to:
- `/workspace/ComfyUI/models/` - Various model types
- Persistent storage recommended via volume mount

## Requirements

- NVIDIA GPU with CUDA support
- Docker with nvidia-container-toolkit
- At least 24GB GPU memory recommended for 14B models

## Source

Built from: https://github.com/pelakk/wan-2.2