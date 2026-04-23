# 🛡️ Armory (武库) 交付手册 (给 USER)

> **当前状态**：Apple Silicon (M4) 环境已完成 Python 环境去中心化重构，状态 100% 可用。

## 🚀 核心操作指南

### 1. 环境维护
- **配置源**：位于 `~/.armory` (隐藏目录)。
- **同步方式**：
  ```bash
  cd ~/.armory
  git pull                # 获取最新配置
  chezmoi apply --force   # 应用到系统
  ./bootstrap.sh          # 自动安装 SDK 并同步 Python 环境 (requirements.txt)
  ```

### 2. Python 实验室 (Daily Driver)
- **默认环境**: 已自动激活 `~/.venv/default` (Python 3.12)。
- **内置利器**: `ipython`, `jupyterlab`, `west`, `pynrfjprog` 等 40+ 常用库已开机即得。
- **自定义**: 想要增加新包？只需修改 [requirements.txt](file:///Users/druid/study/chezmoi/armory/requirements.txt) 后运行 `./bootstrap.sh`。

### 3. 肌肉记忆 (Neovim)
- **Leader Key**: `,` (逗号)
- **快速退出**: `jk` 或 `kj` (在 Insert 模式下瞬发返回 Normal 模式)。
- **智能注释系统 (Smart Comment)**:
  - `,cc`: 以当前风格注释。
  - `,cu`: 智能识别风格并移除注释。
  - `,ca`: 切换注释风格（如 C 语言的 `//` 转 `/* */`），伴随状态提示。
- **文件探索**: `,ef` (Explore File), `,es` (Explore Symbol)。
- **逐级删路**: `Ctrl-w` (只删到 `/`)。

---
**祝您在 M4 的强劲性能下，开发如飞！🛡️🚀**
