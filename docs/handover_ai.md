# 🤖 Armory Execution context (For AI Assistants)

> **Target Environment**: Apple Silicon M4, macOS 15+.
> **Architecture**: `~/.armory` (Managed by Chezmoi).

## 🛠️ Technical Architecture

### 1. Python Lab (The New Standard)
- **Isolation**: Instead of global tools, we use `~/.venv/default` (Python 3.12).
- **Automation**: `bootstrap.sh` uses `uv pip install -r requirements.txt` to maintain parity.
- **Auto-activation**: Handled via `dot_zshrc` with a silent check.

### 2. Zsh & Path Isolation
- Strict architecture isolation (`arm` vs `intel`).
- `/usr/local/bin` is a low-priority fallback for Universal Binaries (J-Link, nrfjprog).

### 3. Smart Comment System
- **Module**: `lua/core/comment.lua`.
- **Logic**: Custom abstraction layer over `Comment.nvim`. Detects blockwise availability and handles alternate styles via `,ca`. Auto-configures buffer-local keymaps.
- **Protobuf Advice**: Nanopb is the preferred standard for Zephyr/NCS.

## 📌 Next Steps
- Monitor `requirements.txt` growth.
- Consider prompt simplification (Starship) if requested by user.

**Always respect the "jk" muscle memory and the isolated PATH logic.**
