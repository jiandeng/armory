# 🛡️ Armory (武库) 交付手册 (给 USER)

> **当前状态**：Apple Silicon (M4) 嵌入式开发环境已完成现代化重构，状态 100% 可用。

## 🚀 核心操作指南

### 1. 环境维护
- **配置源**：位于 `~/.armory` (隐藏目录)。
- **同步方式**：
  ```bash
  cd ~/.armory
  git pull                # 获取最新配置
  chezmoi apply --force   # 应用到系统（~/.zshrc, ~/.config/nvim 等）
  ./bootstrap.sh          # 修复/更新工具链（SDK, 插件）
  ```

### 2. 肌肉记忆 (Neovim)
- **Leader Key**: `,` (逗号)
- **快速退出**: `jk` 或 `kj` (在 Insert 模式下瞬发返回 Normal 模式)。
- **文件探索**: `,ef` (Explroe File) 侧边栏，`,es` (Explore Symbol) 代码大纲。
- **集成终端**: `,tt` 开启/关闭。
- **搜索**: `s` 或 `S` (Flash 瞬移)。

### 3. 终端技巧 (Zsh)
- **逐级删路**: `^w` 现在只会删到 `/` 为止，方便路径微调。
- **向前删除**: `^d` 补齐了 Emacs 风格的向前删除。
- **双架构**: 输入 `arm` 进入原生 M4 环境，`intel` 进入 Rosetta 环境。
- **路径保护**: 环境变量中有意将 `/usr/local/bin` 放在末尾，确保 `nrfjprog` 等工具可用但不冲突。

### 4. 工具链状态
- **Python**: 全面使用 **`uv`**。不要用 `pipx` (在 macOS 3.14+ 下不稳定)。
- **SDK**: Zephyr SDK v0.17.4 安装在 `~/.local/opt/zephyr-sdk` (软链接)，已自动注入环境变量。
- **移动端**: 已集成 `adb` (android-platform-tools) 和 `ack`。

---
**祝您在 M4 的强劲性能下，开发如飞！🛡️🚀**
