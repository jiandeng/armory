# 🛡️ Armory: Apple Silicon Embedded Dev Environment

> **Chezmoi-managed dotfiles for embedded development on Apple Silicon.**

## 🧠 Philosophy
- **Arm64 Native First**: Minimal reliance on Rosetta 2.
- **Architectural Isolation**: Strict separation between arm64 and x86_64 shells to prevent PATH pollution.
- **Minimalist & Clean**: No heavy frameworks like Oh My Zsh; raw performance and clarity.
- **Embedded Focused**: Tailored for C/C++ development with modern tools.

---

## 🧱 Stack
- **Manager**: [chezmoi](https://www.chezmoi.io/)
- **Toolchain**: [west](https://docs.zephyrproject.org/latest/develop/west/index.html) (Brew), [Zephyr SDK](https://github.com/zephyrproject-rtos/sdk-ng) (Native v0.17.4), [nrfutil](https://www.nordicsemi.com/Products/Development-tools/nRF-Util), [nRF Command Line Tools](https://www.nordicsemi.com/Products/Development-tools/nRF-Command-Line-Tools) (Universal Binaries)
- **GUI**: [nRF Connect for Desktop](https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-Desktop) (Optional Cask)
- **Shell**: Zsh (with Starship & fzf integration)
- **Multiplexer**: Tmux (Prefix: `Ctrl-a`)
- **Editor**: Neovim (Lua-based, Lazy.nvim)
- **Architecture**: ARM64 as default, Intel (x86_64) isolated.

---

## 🚀 Quick Start (Bootstrap)

To set up this environment on a fresh Mac:

1. Clone this repository into your workspace:
   ```bash
   git clone https://github.com/jiandeng/armory ~/.armory
   ```
2. Navigate to the directory and run the bootstrap script:
   ```bash
   cd ~/.armory && ./bootstrap.sh
   ```
3. Restart your terminal.

---

## 🐚 Usage & Shortcuts

### Architecture Isolation
- `arm`: Switch to a native arm64 Zsh shell.
- `intel`: Switch to an x86_64 Zsh shell (Rosetta 2).

### Shell Shortcuts (Emacs-style)
- `^a` (double-tap `C-a a`) / `^e`: Jump to beginning/end of line.
- `^f` / `^b`: Move forward/backward by character.
- `⌥b` / `⌥f`: Move forward/backward by word.
- `^w`: Delete backward (stops at `/` for paths).
- `^d`: Delete forward character.
- `^u`: Delete line backward.
- `^r`: Search command history.

### Editor (Neovim)
- `v` or `vi`: Launch Neovim.
- See the **Neovim Cheatsheet** section below for all navigation and editing shortcuts.

### Multiplexer (Tmux)
- `Ctrl-a s`: Split horizontal.
- `Ctrl-a v`: Split vertical.
- `Ctrl-h/j/k/l`: Seamlessly navigate between Neovim and Tmux panes.

---

## 📂 Structure
- `dot_zshrc`, `dot_zprofile`: Zsh configuration.
- `dot_tmux.conf`: Tmux configuration.
- `dot_gitconfig`: Global git settings & aliases.
- `private_dot_config/`:
  - `nvim/`: Modern Lua configuration for Neovim.
  - `starship.toml`: Minimalist prompt setting.
- `Brewfile`: Core dependencies and toolchains.
- `bootstrap.sh`: Automated setup script.

---

## ⌨️ Neovim Cheatsheet (Leader = `,`)

### 🚀 Search & Navigation
| Key | Action |
| :--- | :--- |
| `s` | **Flash Jump**: Instant move to any character |
| `S` | **Flash Treesitter**: Select/Jump to code blocks |
| `,ff` | **Find Files**: Search files by name |
| `,fg` | **Live Grep**: Search text inside files |
| `,fb` | **Buffers**: Switch between open files |
| `jk` | **Escape**: Return to Normal mode |

### 🌳 Git & Version Control
| Key | Action |
| :--- | :--- |
| `,gn` | **Next Hunk**: Jump to next change |
| `,gp` | **Prev Hunk**: Jump to previous change |
| `,gv` | **Preview**: See what changed in this hunk |
| `,gu` | **Undo**: Restore/Reset this change |
| `,gb` | **Blame**: See who edited this line |
| `,gd` | **Diff**: Inline diff comparison |

### 🛠️ Editing & Misc
| Key | Action |
| :--- | :--- |
| `,w` | **Save**: Fast save with `w!` |
| `Alt+j/k` | **Move Line**: Shift line up/down |
| `0` | **Home**: Jump to first non-blank char |
| `,ef` | **Explore File**: Toggle file tree (Neo-tree) |
| `,es` | **Explore Symbol**: Toggle code outline (Aerial) |
| `,tt` | **Terminal**: Toggle integrated terminal |
