#!/bin/bash
# Vibe Dependencies Installer
# 专注于在 Linux/Mac 上安装核心依赖工具 (Neovim, Lazygit 等)
# 优先使用无需 Root 权限的本地安装方式 (~/.local/bin)

set -e

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_err() { echo -e "${RED}[ERROR]${NC} $1"; }

OS="$(uname -s)"
ARCH="$(uname -m)"

echo_info "Detected OS: $OS, Arch: $ARCH"
echo_info "Installation Target: $INSTALL_DIR"
echo_info "PATH Check: Ensure $INSTALL_DIR is in your PATH."

# --- 1. Install Neovim ---
install_nvim() {
    if command -v nvim &> /dev/null; then
        echo_info "Neovim is already installed: $(nvim --version | head -n 1)"
        # 这里可以加版本检查逻辑，暂时略过
        return
    fi

    echo_info "Installing Neovim (Latest Stable)..."
    if [ "$OS" = "Linux" ]; then
        # Linux: Download AppImage (Universal & Newest)
        echo_info "Downloading nvim.appimage..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        mv nvim.appimage "$INSTALL_DIR/nvim"
        
        # AppImage 可能需要 FUSE，如果无法运行，提示用户
        echo_warn "If ./nvim fails to run, you might need to extract the AppImage manually or install fuse."
    elif [ "$OS" = "Darwin" ]; then
        echo_warn "On macOS, it's recommended to use Homebrew: 'brew install neovim'"
    fi
}

# --- 2. Install Lazygit ---
install_lazygit() {
    if command -v lazygit &> /dev/null; then
        echo_info "Lazygit is already installed."
        return
    fi

    echo_info "Installing Lazygit..."
    if [ "$OS" = "Linux" ]; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        echo_info "Latest Lazygit version: $LAZYGIT_VERSION"
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        install lazygit "$INSTALL_DIR"
        rm lazygit lazygit.tar.gz
    elif [ "$OS" = "Darwin" ]; then
         echo_warn "On macOS, please use: 'brew install lazygit'"
    fi
}

# --- 3. Install Tmux (System Level usually) ---
check_tmux() {
    if ! command -v tmux &> /dev/null; then
        echo_warn "Tmux is missing!"
        if [ "$OS" = "Linux" ]; then
            echo_warn "Please install tmux using your package manager (e.g., sudo apt install tmux)."
        else
            echo_warn "Please run: 'brew install tmux'"
        fi
    else
        echo_info "Tmux is installed."
    fi
}

# --- 4. Ripgrep & Fd ---
check_tools() {
    if ! command -v rg &> /dev/null; then
        echo_warn "ripgrep (rg) is missing. It is required for fast searching."
    fi
    if ! command -v fd &> /dev/null; then
        echo_warn "fd is missing. It is required for file finding."
    fi
}

# --- Main ---
install_nvim
install_lazygit
check_tmux
check_tools

echo ""
echo_info "Dependency check/installation complete."
echo_info "If you installed new tools, please restart your terminal or source your shell config."
