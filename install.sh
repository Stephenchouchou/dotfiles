#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "  Arch Linux + Hyprland Dotfiles Installer"
echo "=========================================="

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}This script only supports Arch Linux${NC}"
    exit 1
fi

# Confirm installation
echo -e "${YELLOW}This script will install packages and deploy config files${NC}"
read -p "Continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==========================================
# 1. Install yay (AUR helper)
# ==========================================
if ! command -v yay &> /dev/null; then
    echo -e "${GREEN}[1/5] Installing yay...${NC}"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
else
    echo -e "${GREEN}[1/5] yay already installed, skipping${NC}"
fi

# ==========================================
# 2. Install official repository packages
# ==========================================
echo -e "${GREEN}[2/5] Installing official packages...${NC}"
sudo pacman -S --needed - < "$DOTFILES_DIR/packages/pkglist.txt"

# ==========================================
# 3. Install AUR packages
# ==========================================
echo -e "${GREEN}[3/5] Installing AUR packages...${NC}"
yay -S --needed - < "$DOTFILES_DIR/packages/pkglist-aur.txt"

# ==========================================
# 4. Setup Oh My Zsh and plugins
# ==========================================
echo -e "${GREEN}[4/5] Setting up Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
[ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ] && git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab

# ==========================================
# 5. Deploy configs with Stow
# ==========================================
echo -e "${GREEN}[5/5] Deploying config files...${NC}"

# Install stow
sudo pacman -S --needed stow

cd "$DOTFILES_DIR"

# Backup existing configs
backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

for dir in hypr waybar kitty wlogout fcitx5 nvim kanshi; do
    if [ -d "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ]; then
        echo "Backing up $dir to $backup_dir"
        mv "$HOME/.config/$dir" "$backup_dir/"
    fi
done

# Backup zsh configs
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$backup_dir/"
[ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$backup_dir/"

# Use stow to create symlinks
for pkg in hypr waybar kitty wlogout fcitx5 nvim kanshi; do
    echo "Deploying $pkg..."
    stow -v -t "$HOME" "$pkg"
done

# Deploy zsh configs
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# ==========================================
# Done
# ==========================================
echo ""
echo -e "${GREEN}=========================================="
echo "  Installation complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Log out and select Hyprland as your session"
echo "  2. Config backup location: $backup_dir"
echo ""
echo "A system reboot is recommended."
