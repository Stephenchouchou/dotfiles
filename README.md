# Arch Linux + Hyprland Dotfiles

我的 Arch Linux + Hyprland 桌面環境配置。

## 截圖

<!-- 可以加入你的桌面截圖 -->

## 包含配置

| 項目 | 說明 |
|------|------|
| **Hyprland** | Wayland compositor 配置、快捷鍵、多螢幕設定 |
| **Waybar** | 狀態列配置，支援多螢幕 |
| **Kitty** | 終端機配置 |
| **wlogout** | 登出選單 (關機/重啟/休眠等) |
| **fcitx5** | 中文輸入法 (新酷音) |
| **Neovim** | LazyVim 配置 |
| **Zsh** | Oh My Zsh + Powerlevel10k |

## 安裝

### 快速安裝

```bash
# Clone 此倉庫
git clone https://github.com/Stephenchouchou/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 執行安裝腳本
chmod +x install.sh
./install.sh
```

### 手動安裝

1. **安裝官方套件**
   ```bash
   sudo pacman -S --needed - < packages/pkglist.txt
   ```

2. **安裝 AUR 套件** (需要 yay 或 paru)
   ```bash
   yay -S --needed - < packages/pkglist-aur.txt
   ```

3. **使用 GNU Stow 部署配置**
   ```bash
   cd ~/dotfiles
   stow hypr waybar kitty wlogout fcitx5 nvim

   # Zsh 配置
   ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
   ln -sf ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
   ```

## 目錄結構

```
dotfiles/
├── hypr/           # Hyprland 配置
│   └── .config/hypr/
├── waybar/         # Waybar 狀態列
│   └── .config/waybar/
├── kitty/          # Kitty 終端機
│   └── .config/kitty/
├── wlogout/        # 登出選單
│   └── .config/wlogout/
├── fcitx5/         # 輸入法
│   └── .config/fcitx5/
├── nvim/           # Neovim (LazyVim)
│   └── .config/nvim/
├── zsh/            # Zsh 配置
│   ├── .zshrc
│   └── .p10k.zsh
├── packages/       # 套件清單
│   ├── pkglist.txt
│   └── pkglist-aur.txt
├── install.sh      # 安裝腳本
└── README.md
```

## 快捷鍵

### Hyprland

| 按鍵 | 功能 |
|------|------|
| `Super + Q` | 開啟終端機 (Kitty) |
| `Super + C` | 關閉視窗 |
| `Super + E` | 檔案管理員 (Dolphin) |
| `Super + R` | 啟動器 (Wofi) |
| `Super + V` | 切換浮動視窗 |
| `Super + F` | 全螢幕 |
| `Super + L` | 鎖定螢幕 |
| `Super + W` | 隨機切換桌布 |
| `Super + Shift + Q` | 登出選單 |
| `Super + 1-0` | 切換工作區 |
| `Super + Shift + 1-0` | 移動視窗到工作區 |
| `Print` | 截圖 (選取區域) |

## 依賴

### 主要元件
- Hyprland (Wayland compositor)
- Waybar (狀態列)
- Wofi (啟動器)
- Kitty (終端機)
- Dolphin (檔案管理員)

### 輸入法
- fcitx5 + fcitx5-chewing (新酷音)

### 其他工具
- [awww](https://codeberg.org/LGFae/awww) (動態桌布，支援 GIF)
- hyprlock (鎖屏)
- hyprshot (截圖)
- wlogout (登出選單)

## 自訂

### 螢幕配置

編輯 `~/.config/hypr/hyprland.conf` 中的 monitor 設定：

```conf
monitor=DP-4,3840x2560@60,0x0,1.0
monitor=eDP-1,1920x1200@60,3840x0,1.0
```

### Waybar

每個螢幕有獨立的配置文件：
- `config-DP-4.jsonc` - 主螢幕
- `config-eDP-1.jsonc` - 筆電螢幕

## License

MIT
