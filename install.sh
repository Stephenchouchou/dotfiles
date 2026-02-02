#!/bin/bash

set -e

echo "=========================================="
echo "  Arch Linux + Hyprland Dotfiles 安裝腳本"
echo "=========================================="

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 檢查是否為 Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}此腳本僅支援 Arch Linux${NC}"
    exit 1
fi

# 確認安裝
echo -e "${YELLOW}此腳本將安裝套件並部署配置文件${NC}"
read -p "是否繼續？ [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==========================================
# 1. 安裝 yay (AUR helper)
# ==========================================
if ! command -v yay &> /dev/null; then
    echo -e "${GREEN}[1/5] 安裝 yay...${NC}"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
else
    echo -e "${GREEN}[1/5] yay 已安裝，跳過${NC}"
fi

# ==========================================
# 2. 安裝官方倉庫套件
# ==========================================
echo -e "${GREEN}[2/5] 安裝官方倉庫套件...${NC}"
sudo pacman -S --needed - < "$DOTFILES_DIR/packages/pkglist.txt"

# ==========================================
# 3. 安裝 AUR 套件
# ==========================================
echo -e "${GREEN}[3/5] 安裝 AUR 套件...${NC}"
yay -S --needed - < "$DOTFILES_DIR/packages/pkglist-aur.txt"

# ==========================================
# 4. 安裝 Oh My Zsh 和插件
# ==========================================
echo -e "${GREEN}[4/5] 設定 Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 安裝 Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# 安裝 zsh 插件
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
[ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ] && git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab

# ==========================================
# 5. 使用 Stow 部署配置
# ==========================================
echo -e "${GREEN}[5/5] 部署配置文件...${NC}"

# 安裝 stow
sudo pacman -S --needed stow

cd "$DOTFILES_DIR"

# 備份現有配置
backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

for dir in hypr waybar kitty wlogout fcitx5 nvim; do
    if [ -d "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ]; then
        echo "備份 $dir 到 $backup_dir"
        mv "$HOME/.config/$dir" "$backup_dir/"
    fi
done

# 備份 zsh 配置
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$backup_dir/"
[ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$backup_dir/"

# 使用 stow 建立 symlink
for pkg in hypr waybar kitty wlogout fcitx5 nvim; do
    echo "部署 $pkg..."
    stow -v -t "$HOME" "$pkg"
done

# 部署 zsh 配置
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# ==========================================
# 完成
# ==========================================
echo ""
echo -e "${GREEN}=========================================="
echo "  安裝完成！"
echo "==========================================${NC}"
echo ""
echo "請執行以下步驟："
echo "  1. 登出並選擇 Hyprland 作為 session"
echo "  2. 如需還原配置，備份位於: $backup_dir"
echo ""
echo "建議重新啟動系統以確保所有設定生效。"
