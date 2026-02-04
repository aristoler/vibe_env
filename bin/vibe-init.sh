#!/usr/bin/env bash
# =============================================================================
# 🔮 Vibe Environment Shell Integration
# =============================================================================
# 此文件集中管理所有 Vibe 环境的环境变量、别名和工具初始化。
# 使用方法：在 ~/.zshrc 或 ~/.bashrc 中添加一行：
# [ -f ~/.vibe_init.sh ] && source ~/.vibe_init.sh

# --- 1. 核心路径 (Ensure Local Bin is first) ---
# 确保 ~/.local/bin 在 PATH 最前面，优先使用我们安装的新版工具
case ":$PATH:" in
*":$HOME/.local/bin:"*) ;;
*) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# --- 2. 加载密钥 (API Keys) ---
if [ -f "$HOME/.vibe_secrets" ]; then
  source "$HOME/.vibe_secrets"
fi

# --- 3. Shell 类型检测 ---
_vibe_shell=""
if [ -n "$ZSH_VERSION" ]; then
  _vibe_shell="zsh"
elif [ -n "$BASH_VERSION" ]; then
  _vibe_shell="bash"
else
  # Fallback detection
  _vibe_shell=$(basename "$SHELL")
fi

# --- 4. 高阶工具集成 ---

# Zoxide (智能目录跳转)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init "$_vibe_shell")"
fi

# FZF (模糊搜索)
if [ "$_vibe_shell" = "zsh" ] && [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
elif [ "$_vibe_shell" = "bash" ] && [ -f "$HOME/.fzf.bash" ]; then
  source "$HOME/.fzf.bash"
fi

# Yazi (文件管理器别名)
if command -v yazi &>/dev/null; then
  alias y="yazi"
fi

# alias for vibe
alias vibe="nvim"

# --- 5. 其他实用别名 ---
# 防止误删 (可选，如果不喜欢可以注释掉)
# alias rm='rm -i'
