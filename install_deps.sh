#!/bin/bash
# Vibe Dependencies Installer (v1.2)
# Fixes: ARM64 support, robust arch detection
# Usage: ./install_deps.sh [--upgrade]

set -e

FORCE_UPGRADE=false
if [[ "$1" == "--upgrade" || "$1" == "-u" ]]; then
    FORCE_UPGRADE=true
    echo "🔄 Upgrade mode enabled: Will force reinstall tools."
fi

# 目录准备
INSTALL_BIN="$HOME/.local/bin"
INSTALL_OPT="$HOME/.local/opt"
mkdir -p "$INSTALL_BIN" "$INSTALL_OPT"

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_err() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- 架构与系统检测 ---
OS="$(uname -s)"
ARCH="$(uname -m)"
echo_info "Detected OS: $OS, Arch: $ARCH"

# 映射架构名称
if [ "$ARCH" = "x86_64" ]; then
    NVIM_ARCH="linux64"
    LAZYGIT_ARCH="x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    NVIM_ARCH="linux-arm64"
    LAZYGIT_ARCH="arm64"
else
    echo_err "Unsupported Architecture: $ARCH"
    exit 1
fi

echo_info "Target Architecture Mapped: Neovim($NVIM_ARCH), Lazygit($LAZYGIT_ARCH)"

# --- 1. Install Neovim ---
install_nvim() {
    if command -v nvim &> /dev/null && [ "$FORCE_UPGRADE" = false ]; then
        echo_info "Neovim is already installed: $(nvim --version | head -n 1)"
        return
    fi

    echo_info "Installing Neovim (Latest Stable)..."
    
    if [ "$OS" = "Linux" ]; then
        # 清理旧安装
        rm -rf "$INSTALL_OPT/nvim" "$INSTALL_BIN/nvim"

        if [ "$ARCH" = "x86_64" ]; then
            # x86: 使用 AppImage (最简单)
            echo_info "Downloading nvim.appimage (x86_64)..."
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
            chmod u+x nvim.appimage
            mv nvim.appimage "$INSTALL_BIN/nvim"
        else
            # ARM64: 使用 Tarball (官方无 ARM AppImage)
            echo_info "Downloading nvim-$NVIM_ARCH.tar.gz..."
            curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-$NVIM_ARCH.tar.gz"
            
            echo_info "Extracting to $INSTALL_OPT/nvim..."
            tar xf "nvim-$NVIM_ARCH.tar.gz"
            mv "nvim-$NVIM_ARCH" "$INSTALL_OPT/nvim"
            
            # 建立软链接
            ln -sf "$INSTALL_OPT/nvim/bin/nvim" "$INSTALL_BIN/nvim"
            
            # 清理
            rm "nvim-$NVIM_ARCH.tar.gz"
        fi
        
    elif [ "$OS" = "Darwin" ]; then
        if command -v brew &> /dev/null; then
             brew upgrade neovim || brew install neovim
        fi
    fi
}

# --- 2. Install Lazygit ---
install_lazygit() {
    if command -v lazygit &> /dev/null && [ "$FORCE_UPGRADE" = false ]; then
        echo_info "Lazygit is already installed."
        return
    fi

    echo_info "Installing Lazygit..."
    if [ "$OS" = "Linux" ]; then
        # 动态获取最新版 Tag
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        echo_info "Latest Lazygit version: $LAZYGIT_VERSION"
        
        FILENAME="lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
        URL="https://github.com/jesseduffield/lazygit/releases/latest/download/${FILENAME}"
        
        echo_info "Downloading $FILENAME..."
        curl -Lo lazygit.tar.gz "$URL"
        
        echo_info "Installing to $INSTALL_BIN..."
        tar xf lazygit.tar.gz lazygit
        install lazygit "$INSTALL_BIN"
        rm lazygit lazygit.tar.gz
        
    elif [ "$OS" = "Darwin" ]; then
         if command -v brew &> /dev/null; then
             brew upgrade lazygit || brew install lazygit
         fi
    fi
}

# --- 3. Ripgrep & Fd Check ---
check_tools() {
    MISSING=""
    if ! command -v rg &> /dev/null; then MISSING="$MISSING ripgrep"; fi
    
    # Check for 'fd' OR 'fdfind' (Ubuntu/Debian rename)
    if ! command -v fd &> /dev/null && ! command -v fdfind &> /dev/null; then 
        MISSING="$MISSING fd-find"; 
    fi
    
    if [ -n "$MISSING" ]; then
        echo_warn "Missing suggested tools:$MISSING"
        if [ "$OS" = "Linux" ]; then
            # 检测包管理器
            if command -v apt &> /dev/null; then
                echo_info "Suggestion: Run 'sudo apt install ripgrep fd-find' (Ubuntu/Debian)"
            elif command -v yum &> /dev/null; then
                echo_info "Suggestion: Run 'sudo yum install ripgrep fd-find' (CentOS/RHEL)"
            fi
        fi
    fi
}

# --- Main ---
install_nvim
install_lazygit
check_tools

echo ""
echo_info "Done! Please verify installation by running:"
echo "      $INSTALL_BIN/nvim --version"