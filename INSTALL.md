# 📦 Vibe Environment Installation Guide

本指南将帮助你在 macOS 或 Linux 服务器上快速部署 Vibe 开发环境。

## 🚀 快速开始 (Quick Start)

### 1. 克隆仓库
```bash
git clone https://github.com/aristoler/vibe_env.git
cd vibe_env
```

### 2. 安装依赖与配置 (One-Step)

```bash
# 1. 自动下载工具 (Neovim 0.10+, Zoxide, FZF, Yazi...)
./install_deps.sh

# 2. 部署配置与软链接
./setup.sh
```

### 3. 激活环境 (只需一行)
打开你的 Shell 配置文件（Mac 是 `~/.zshrc`，Linux 通常是 `~/.bashrc`），添加**唯一**的一行：

```bash
[ -f ~/.vibe_init.sh ] && source ~/.vibe_init.sh
```

> **注意**: 这一行代码会自动处理：
> *   加载 API 密钥 (`~/.vibe_secrets`)
> *   设置 PATH (`~/.local/bin`)
> *   初始化 Zoxide (智能跳转)
> *   初始化 FZF (模糊搜索)
> *   设置别名 (如 `y` -> `yazi`)

---

## 📋 依赖清单 (Dependencies)

脚本会自动处理大部分依赖，但以下内容需知晓：

| 组件 | 说明 | 自动安装? |
| :--- | :--- | :--- |
| **Neovim** | 核心编辑器 (v0.10+) | ✅ (AppImage/Binary) |
| **Tmux** | 终端复用 | ❌ (Mac用brew / Linux用apt) |
| **Zoxide** | 智能目录跳转 | ✅ |
| **FZF** | 命令行模糊搜索 | ✅ |
| **Yazi** | 终端文件管理器 | ✅ |
| **Git & GCC** | 版本控制与编译环境 | ❌ (需系统预装) |

---

## 🅰️ 字体要求 (Nerd Font)

**仅需在客户端安装！**
请在你的 Mac/Windows 终端上安装 [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases) 以避免图标乱码。

---

## 🛠️ 常见问题 (Troubleshooting)

### Q1: 打开 Vim 发现全是方块乱码？
**A**: 客户端没装 Nerd Font。服务器不需要装。

### Q2: Copilot 报错？
**A**: 首次使用需登录。启动 Vim 后运行 `:Copilot auth`。

### Q3: 脚本在 ARM Linux 上报错？
**A**: 确保你拉取了最新代码。`install_deps.sh` 已完美支持 ARM64 (aarch64) 架构。

### Q4: 如何配置 API Key？
**A**: 编辑 `~/.vibe_secrets`。如果文件不存在，运行 `./setup.sh` 会自动生成模板。