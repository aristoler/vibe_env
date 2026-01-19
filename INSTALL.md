# 📦 Vibe Environment Installation Guide

本指南将帮助你在 macOS 或 Linux 服务器上快速部署 Vibe 开发环境。

## 🚀 快速开始 (Quick Start)

### 1. 克隆仓库
```bash
git clone https://github.com/aristoler/vibe_env.git
cd vibe_env
```

### 2. 安装 (分两步)

**Step A: 安装软件依赖 (可选)**
> 如果你的系统已经装好了 Neovim (v0.9+), Tmux, Lazygit 等，可跳过此步。
> *Linux 用户强烈建议运行，以获取最新版的 portable 二进制文件。*

```bash
./install_deps.sh
```

**Step B: 部署配置**
> 这一步会创建软链接并初始化环境。

```bash
./setup.sh
```

### 3. 首次启动
输入以下命令启动环境：
```bash
vc   # 启动完整 IDE 布局 (Vim + Terminal + Git)
# 或
vibe # 仅启动编辑器
```

---

## 📋 依赖清单 (Dependencies)

如果选择手动安装，请确保系统包含以下组件：

| 组件 | 版本要求 | 说明 |
| :--- | :--- | :--- |
| **Neovim** | **>= 0.9.0** | ⚠️ 系统默认源(apt/yum)通常太老，必须手动升级。 |
| **Tmux** | >= 3.0 | 终端复用，支持多窗口布局。 |
| **Git** | 最新版 | 版本控制。 |
| **C Compiler** | gcc / clang | **必须**。用于编译 TreeSitter 语法解析器。 |
| **Ripgrep** | (推荐) | 极速文件内容搜索 (`rg`)。 |
| **Lazygit** | (推荐) | 终端 Git GUI。 |
| **Node.js** | (推荐) | 部分 AI 插件 (Copilot/Avante) 需要。 |

---

## 🅰️ 字体要求 (Nerd Font)

**这是最重要的一点！**

Vibe 界面大量使用了图标（文件树、状态栏）。你需要安装 **Nerd Font** 才能正常显示。

*   **在哪里安装？** 
    *   **不需要**装在远程 Linux 服务器上。
    *   **必须**装在你当前使用的电脑（Client 端，如 Mac/Windows）上。
*   **推荐字体**: [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)
*   **配置**: 安装后，记得在你的终端软件 (iTerm2, Alacritty, VSCode Terminal) 的设置里选择该字体。

---

## 🛠️ 常见问题 (Troubleshooting)

### Q1: 打开 Vim 发现全是方块乱码？
**A**: 你的终端没有设置 Nerd Font。请参考上一节。

### Q2: 报错 `no C compiler found`？
**A**: TreeSitter 需要编译器。
*   **Ubuntu**: `sudo apt install build-essential`
*   **CentOS**: `sudo yum groupinstall "Development Tools"`

### Q3: 报错 `command not found: vibe`？
**A**: 确保 `~/.local/bin` 在你的 PATH 环境变量中。
`setup.sh` 运行完后，尝试执行 `source ~/.zshrc` 或重启终端。

### Q4: 如何配置 DeepSeek / Gemini API Key？
**A**: 
1. 复制模板: `cp vibe_secrets.template ~/.vibe_secrets`
2. 编辑填入 Key: `vim ~/.vibe_secrets`
3. 加载环境: `source ~/.zshrc`
