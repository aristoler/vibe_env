# 🛠️ Vibe 配置架构备忘录 (Config Memo)

> 本文档面向系统维护者，解析 Vibe 环境的底层配置逻辑与扩展方式。

---

## 1. 核心设计理念

### 1.1 隔离性 (Isolation)
利用 Neovim 的 `NVIM_APPNAME="vibe"` 实现配置隔离，不污染 `~/.config/nvim`。

### 1.2 集中化 Shell 配置 (New!)
所有环境变量、PATH 设置、工具初始化逻辑全部集中在 **`bin/vibe-init.sh`**。
*   用户只需在 RC 文件中 source 这一个文件。
*   **优势**: 更新工具链时 (如引入 zoxide)，用户无需手动修改 RC 文件。

---

## 2. 目录映射
运行 `./setup.sh` 后建立的软链接：

| 系统路径 | 仓库源路径 | 作用 |
| :--- | :--- | :--- |
| `~/.config/vibe` | `./config/nvim` | Neovim 配置 |
| `~/.tmux.conf` | `./config/tmux/tmux.conf` | Tmux 配置 |
| `~/.vibe_init.sh`| `./bin/vibe-init.sh` | **Shell 初始化入口** |
| `~/.local/bin/vibe` | `./bin/vibe` | 编辑器启动器 |
| `~/.local/bin/vc` | `./bin/vibe-layout.sh` | IDE 布局启动器 |

---

## 3. 自动化脚本原理

### `install_deps.sh` (全能安装器)
*   **智能架构识别**: 自动区分 x86_64 与 aarch64 (ARM64)。
*   **本地化安装**: 所有工具 (nvim, lazygit, yazi, zoxide, fzf) 均安装至 `~/.local/bin`，**无需 Root 权限**。
*   **升级机制**: 支持 `--upgrade` 参数强制覆盖旧版本。

### `setup.sh` (配置部署器)
*   负责建立软链接。
*   检测并生成 `~/.vibe_secrets` 模板。
*   幂等设计，可重复运行。

---

## 4. 插件体系 (LazyVim)

基于 [LazyVim](https://www.lazyvim.org/) 框架。
*   **AI 模块**: `lua/plugins/avante.lua` (默认禁用 Copilot 侧边栏补全以防崩溃)。
*   **Tmux 导航**: `lua/plugins/tmux_nav.lua` 实现 Ctrl+h/j/k/l 无缝跳转。
