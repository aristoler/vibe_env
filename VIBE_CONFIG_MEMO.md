# 🛠️ Vibe 环境配置备忘录 (Config Memo)

> 本文档供系统维护者或高级用户参考，记录了环境的底层配置逻辑、文件路径和关键参数。
> 日常开发请参考 `VIBERCODER_PLAYBOOK.md`。

---

## 1. 目录结构 (Directory Structure)

Vibe 环境利用 Neovim 的 `NVIM_APPNAME` 特性实现了与系统环境的完全隔离。

| 类别 | 路径 | 说明 |
| :--- | :--- | :--- |
| **配置根目录** | `~/.config/vibe/` | Lua 脚本、插件配置、键位映射 |
| **插件/数据** | `~/.local/share/vibe/` | Lazy.nvim 插件源码、Mason 安装的工具 |
| **状态信息** | `~/.local/state/vibe/` | 历史记录、日志、Shada 文件 |
| **缓存文件** | `~/.cache/vibe/` | 临时编译文件、交换文件 |

---

## 2. 关键配置文件 (Key Config Files)

### 2.1 核心入口
- **`~/.config/vibe/init.lua`**: 加载 LazyVim 框架。
- **`~/.config/vibe/lua/config/keymaps.lua`**: 自定义快捷键（如 `<M-h>` 窗口调整）。
- **`~/.config/vibe/lua/config/options.lua`**: 基础 Vim 选项。

### 2.2 AI 引擎配置 (Avante)
- **文件**: `~/.config/vibe/lua/plugins/avante.lua`
- **当前 Providers**:
    - `openai` (Mapped to **DeepSeek**): 主力模型 `deepseek-chat`。
    - `gemini` (**Gemini 1.5 Pro**): 备用模型，适合长文本 (继承自 openai)。
    - `copilot`: 用于行间自动补全 (Auto Suggestions)。

### 2.3 终端集成 (Tmux)
- **文件**: `~/.tmux.conf` (如果你使用系统级配置) 或 `~/.config/tmux/tmux.conf`。
- **导航插件**: `~/.config/vibe/lua/plugins/tmux_nav.lua`
    - 实现了 `Ctrl+h/j/k/l` 在 Vim 分割窗口和 Tmux 面板间的无缝跳转。

---

## 3. 自动化脚本 (Automation Scripts)

### `vibe-layout.sh`
- **位置**: `bin/vibe-layout.sh`
- **作用**: 一键启动/重置 Tmux 开发环境。
- **逻辑**:
    1. 检测当前目录名作为 Session ID。
    2. 创建 `Editor` 窗口。
    3. 根据布局参数 (`dev`, `debug`, `zen`) 发送 `split-window` 指令。

### `.zshrc` 全局入口
```bash
vc() {
    bash "$HOME/GitHere/termPower/bin/vibe-layout.sh" "$@"
}
```

---

## 4. 维护与重置 (Maintenance)

### 强制重装环境
如果你想彻底从头开始，请执行以下命令（⚠️ 会删除所有 Vibe 配置和插件）：

```bash
# 1. 备份现有配置 (可选)
mv ~/.config/vibe ~/.config/vibe.bak

# 2. 清理所有残留
rm -rf ~/.local/share/vibe
rm -rf ~/.local/state/vibe
rm -rf ~/.cache/vibe

# 3. 重新克隆 LazyVim 模板
git clone https://github.com/LazyVim/starter ~/.config/vibe
rm -rf ~/.config/vibe/.git
```

---
*Last Updated: 2026-01-19 by Gemini CLI*
