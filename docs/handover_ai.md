# 🤖 Armory Execution context (For AI Assistants)

> **Target Environment**: Apple Silicon M4, macOS 15+ (Darwin).
> **Source Root**: `~/.armory` (Managed by Chezmoi).

## 🛠️ Technical Architecture

### 1. Source of Truth
- The user uses **Chezmoi** to manage dotfiles.
- Source path is `~/.armory`, target is `$HOME`.
- **CRITICAL**: Do NOT edit files in `~/.config/nvim` or `~/.zshrc` directly. Always edit within `~/.armory` and run `chezmoi apply`.

### 2. Zsh & Path Isolation
- The `dot_zshrc` implements a strict architecture isolation.
- `arm64` shell prioritizes `/opt/homebrew/bin`.
- `/usr/local/bin` is added to the **END** of the path as a fallback for Universal Binaries (e.g., `nrfjprog`, `JLink`).
- `WORDCHARS` has been modified to exclude `/` for hierarchical path deletion (`Ctrl-w`).

### 3. Python Management (The `uv` Era)
- **Problem**: Homebrew Python 3.14 (and some 3.13) has broken `ensurepip` on macOS, making `pipx` unreliable.
- **Solution**: All Python tool installations must use **`uv`**.
- **User Preference**: No global library installation. Users manage project-specific virtualenvs via `uv venv --python 3.12`.

### 4. Toolchain Specifics
- **Zephyr SDK**: Manual install handled by `bootstrap.sh`. 
- **Symlink Strategy**: `~/.local/opt/zephyr-sdk` is a symlink to the current versioned directory.
- **SDK Manager**: nRF Connect SDK components are managed via `nrfutil`.

## 📌 Current Context & Next Steps
- **Environment**: Cleaned and optimized. All legacy Nordic tools integrated via Casks/Manual.
- **Recent focus**: ADB and mobile debug tools support.
- **Next Potential Work**: 
  - Integration of `scrcpy` if the user wants screen mirroring.
  - Deeper Neovim LSP configuration for specific NCS projects.
  - Github Action / CI templates for Armory projects.

**Always respect the " jk" muscle memory and the isolated PATH logic.**
