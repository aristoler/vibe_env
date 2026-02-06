#!/bin/bash

# Vibe Dotfiles Setup Script
# ---------------------------------------------------------
set -euo pipefail # -e: 遇错即停, -u: 变量未定义即停, -o pipefail: 管道错误即停

# 获取当前脚本所在目录的绝对路径
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "🚀 Starting Vibe Environment Setup..."
echo "📂 Repo Root: $REPO_ROOT"

# --- 0. 依赖检查提示 ---
if ! command -v nvim &>/dev/null; then
  echo "⚠️  [Warning] Neovim not found!"
  echo "   You can run './install_deps.sh' to try installing dependencies automatically."
  echo ""
fi

# --- 辅助函数：智能软链接 ---
link_file() {
  local source_path="$1"
  local target_path="$2"
  local target_dir
  target_dir="$(dirname "$target_path")"

  # 1. 确保目标父目录存在
  mkdir -p "$target_dir"

  # 2. 检查目标状态
  if [ -L "$target_path" ]; then
    local current_link
    current_link=$(readlink "$target_path")
    if [ "$current_link" == "$source_path" ]; then
      echo "  ✅ [OK] $target_path"
      return
    fi
    # 如果链接指向了错误的地方，先删除它以便重新链接
    rm "$target_path"
  elif [ -e "$target_path" ]; then
    # 如果是一个普通文件/目录，备份它
    local backup_path="${target_path}.backup_${TIMESTAMP}"
    echo "  ⚠️  [Backup] Moving existing $target_path to $backup_path"
    mv "$target_path" "$backup_path"
  fi

  # 3. 创建软链接 (f: 强制, n: 将目录链接视为文件)
  echo "  🔗 [Link] $target_path -> $source_path"
  ln -sfn "$source_path" "$target_path"
}

# --- 1. 部署 Neovim 配置 ---
echo "📦 Configuring Neovim..."
link_file "$REPO_ROOT/config/nvim" "$HOME/.config/nvim"

# --- 2. 部署 Tmux 配置 ---
echo "📦 Configuring Tmux..."
link_file "$REPO_ROOT/config/tmux/tmux.conf" "$HOME/.tmux.conf"

# --- 3. 部署可执行文件 ---
echo "🚀 Installing Binaries..."
mkdir -p "$HOME/.local/bin"
link_file "$REPO_ROOT/bin/vibe-layout.sh" "$HOME/.local/bin/vc"
chmod +x "$REPO_ROOT/bin/vibe" "$REPO_ROOT/bin/vibe-layout.sh"

# --- 4. 部署 Shell 集成脚本 ---
echo "🐚 Configuring Shell Integration..."
link_file "$REPO_ROOT/bin/vibe-init.sh" "$HOME/.vibe_init.sh"

# --- 5. 检查 API 密钥配置 ---
echo "🔑 Checking Secrets..."
SECRETS_FILE="$HOME/.vibe_secrets"
if [ ! -f "$SECRETS_FILE" ]; then
  echo "  ⚠️  Secrets file not found. Initializing from template..."
  cp "$REPO_ROOT/vibe_secrets.template" "$SECRETS_FILE"
  echo "  👉 ACTION: Please edit $SECRETS_FILE and add your API keys!"
else
  echo "  ✅ [OK] Secrets file exists at $SECRETS_FILE"
fi

# --- 6. 完成 ---
echo ""
echo "✨ Vibe Environment setup complete!"
echo ""
echo "👉 FINAL STEP: ONE-LINE CONFIGURATION"
echo "   Add the following SINGLE LINE to your ~/.zshrc (or ~/.bashrc):"
echo ""
echo "   [ -f ~/.vibe_init.sh ] && source ~/.vibe_init.sh"
echo ""
echo "   (This handles PATH, API Keys, Zoxide, FZF, and Aliases automatically)"
echo "✅ Done."

echo ""
echo "🚀 Optional: Enhance Your Terminal Experience!"
echo "   We now provide recommended example configurations for popular modern terminals."
echo "   You can find them here:"
echo "   👉 Kitty:    config/kitty/kitty.conf.example"
echo "   👉 WezTerm:  config/wezterm/wezterm.lua.example"
echo ""
echo "   To use one of these:"
echo "   1. Copy the example file to its respective config location (e.g., cp config/kitty/kitty.conf.example ~/.config/kitty/kitty.conf)."
echo "   2. Restart your terminal."
echo "   (Remember to install 'Sarasa Gothic SC Nerd Font' for optimal Chinese display and 'JetBrainsMono Nerd Font' for icons if you haven't already!)"

