# 🛠️ Vibe 配置架构备忘录 (Config Memo)

> 本文档面向系统维护者，解析 Vibe 环境的底层配置逻辑与扩展方式。

---

## 1. 核心设计理念

### 1.1 隔离性 (Isolation)
Vibe 利用 Neovim 的 `NVIM_APPNAME` 环境变量实现完全隔离。
*   **启动命令**: `NVIM_APPNAME=vibe nvim` (封装在 `bin/vibe` 中)
*   **优势**: 不会干扰你本机默认的 `~/.config/nvim` 配置，可与原有 Vim 共存。

### 1.2 目录映射
运行 `./setup.sh` 后，系统路径与仓库路径建立如下软链接：

| 系统路径 | 仓库源路径 | 作用 |
| :--- | :--- | :--- |
| `~/.config/vibe` | `./config/nvim` | Neovim 核心配置 |
| `~/.tmux.conf` | `./config/tmux/tmux.conf` | Tmux 配置文件 |
| `~/.local/bin/vibe` | `./bin/vibe` | 编辑器启动脚本 |
| `~/.local/bin/vc` | `./bin/vibe-layout.sh` | IDE 布局启动脚本 |

---

## 2. 插件体系 (LazyVim)

基于 [LazyVim](https://www.lazyvim.org/) 框架构建。

### 2.1 关键文件结构
```text
config/nvim/lua/
├── config/
│   ├── keymaps.lua    # 自定义快捷键
│   ├── options.lua    # Vim 基础选项 (行号, 缩进等)
│   └── autocmds.lua   # 自动命令
└── plugins/
    ├── avante.lua     # AI 助手 (DeepSeek/Gemini)
    ├── tmux_nav.lua   # Vim-Tmux 导航集成
    ├── example.lua    # 用户自定义插件示例
    └── ...
```

### 2.2 如何添加新插件
1. 在 `lua/plugins/` 下新建一个 `.lua` 文件（如 `python.lua`）。
2. 返回标准的 Lazy.nvim 插件表：
   ```lua
   return {
     { "plugin-author/plugin-name", opts = { ... } },
   }
   ```
3. 重启 Vibe，插件会自动安装。

---

## 3. AI 模块详解

### 3.1 Avante.nvim
位于 `lua/plugins/avante.lua`。
*   **Provider**: 默认为 `openai` (映射到 DeepSeek)。
*   **Gemini**: 作为备用 Provider，配置在 `gemini` 字段下。
*   **切换**: 使用 `<Leader>ap` 快捷键在模型间热切换。

### 3.2 密钥管理
出于安全考虑，API Key **绝不** 硬编码在 Lua 文件中。
*   机制：插件读取环境变量 `OPENAI_API_KEY` 或 `GEMINI_API_KEY`。
*   来源：由 `~/.vibe_secrets` 文件提供 (在 `.zshrc` 中加载)。

---

## 4. 自动化脚本原理

### `install_deps.sh`
*   智能检测 OS (Linux/Darwin)。
*   在 Linux 上优先下载 AppImage 或预编译 Tarball 到 `~/.local/bin`。
*   解决系统源软件版本过旧的问题。

### `setup.sh`
*   幂等性设计：可重复运行。
*   自动修复失效的软链接。
*   检测 `~/.vibe_secrets` 是否存在并提供模板。