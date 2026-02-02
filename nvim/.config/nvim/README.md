# Neovim Configuration

基於 [LazyVim](https://www.lazyvim.org/) 的個人 Neovim 配置。

## 特色

- LazyVim 作為基礎框架
- Markdown 終端渲染 (render-markdown.nvim)
- Markdown 瀏覽器即時預覽 (markdown-preview.nvim)
- Zettelkasten 筆記管理 (zk-nvim)
- 剪貼簿貼圖 (img-clip.nvim)
- Markdown 編輯增強 (markdown.nvim)
- 終端機內圖片預覽 (image.nvim，需 Kitty)

## 安裝

### 前置需求

- Neovim >= 0.9.0
- Git
- [Nerd Font](https://www.nerdfonts.com/) (推薦)
- Node.js (Markdown 預覽需要)
- [zk](https://github.com/zk-org/zk) (筆記管理需要)
- [ImageMagick](https://imagemagick.org/) (圖片預覽需要)
- [Kitty](https://sw.kovidgoyal.net/kitty/) >= 28.0 (圖片預覽需要)

### 安裝步驟

```bash
# 備份現有配置
mv ~/.config/nvim ~/.config/nvim.bak

# Clone 此 repo
git clone https://github.com/Stephenchouchou/nvim-config.git ~/.config/nvim

# 開啟 Neovim，插件會自動安裝
nvim
```

## 自訂快捷鍵

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>cp` | 開啟/關閉 Markdown 瀏覽器預覽 |
| `<leader>p` | 貼上剪貼簿圖片 |
| `<leader>mx` | 切換 checkbox |
| `<leader>zn` | 建立新筆記 |
| `<leader>zo` | 開啟筆記列表 |
| `<leader>zt` | 依標籤瀏覽筆記 |
| `<leader>zf` | 搜尋筆記 |
| `<leader>zb` | 顯示反向連結 |
| `<leader>zl` | 顯示正向連結 |

> `<leader>` 預設是空白鍵

## 目錄結構

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins/
│       ├── image.lua
│       ├── img-clip.lua
│       ├── markdown-extra.lua
│       ├── markdown_view.lua
│       └── zk.lua
└── lazy-lock.json
```

## 自訂設定

- `lua/config/options.lua` - Vim 選項 (conceallevel 等)
- `lua/plugins/` - 自訂插件配置

## 參考

- [LazyVim 文件](https://www.lazyvim.org/)
- [usage.md](./usage.md) - 詳細使用說明與快捷鍵列表
