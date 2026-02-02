# Neovim 配置使用說明

基於 [LazyVim](https://www.lazyvim.org/) 的個人配置。

## 自訂設定

### Options (`lua/config/options.lua`)

| 設定 | 值 | 說明 |
|------|-----|------|
| `conceallevel` | 2 | 隱藏 Markdown 標記符號，讓渲染效果更好 |

### 自訂插件

#### render-markdown.nvim (`lua/plugins/markdown_view.lua`)

在終端機內渲染 Markdown，讓標題、程式碼區塊、checkbox 等有視覺效果。

- 程式碼區塊有背景色
- 隱藏 `##` 符號，直接顯示為標題樣式
- 支援 checkbox 渲染

#### markdown-preview.nvim (`lua/plugins/markdown_view.lua`)

在瀏覽器中即時預覽 Markdown。

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>cp` | 開啟/關閉瀏覽器預覽 |

#### image.nvim (`lua/plugins/image.lua`)

在終端機內直接預覽圖片（需要 Kitty 終端機）。

**支援格式：** PNG, JPG, JPEG, GIF, WebP, AVIF

**功能：**
- 開啟圖片檔案時直接顯示
- Markdown 中的圖片自動渲染
- 自動下載遠端圖片

**前置需求：**
- Kitty >= 28.0
- ImageMagick (`sudo pacman -S imagemagick`)

#### img-clip.nvim (`lua/plugins/img-clip.lua`)

從剪貼簿貼上圖片到 Markdown。

**使用方式：**
1. 截圖或複製圖片到剪貼簿
2. 在 Neovim 中按 `<leader>p`
3. 圖片會自動儲存到 `assets/` 資料夾並插入連結

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>p` | 貼上剪貼簿圖片 |
| `<leader>mf` | 貼上剪貼簿圖片 (同上) |

#### markdown.nvim (`lua/plugins/markdown-extra.lua`)

Markdown 編輯增強工具。

**智慧貼上連結：**
1. 選取文字 (Visual mode)
2. 複製 URL 到剪貼簿
3. 按 `p` 貼上，自動變成 `[選取文字](URL)`

**快捷鍵：**

| 快捷鍵 | 模式 | 說明 |
|--------|------|------|
| `<leader>mx` | Normal/Visual | 切換 checkbox |
| `<leader>ml` | Normal | 在下方新增清單項目 |
| `<leader>mL` | Normal | 在上方新增清單項目 |
| `<leader>mt` | Normal | 插入目錄 (TOC) |

**Inline 樣式切換 (gs + 動作)：**

| 快捷鍵 | 說明 | 效果 |
|--------|------|------|
| `gsiwb` | 粗體 (word) | `**word**` |
| `gsiwi` | 斜體 (word) | `*word*` |
| `gsiws` | 刪除線 (word) | `~~word~~` |
| `gsiwc` | 程式碼 (word) | `` `word` `` |

> 也可以用 Visual 模式選取後按 `gsb`、`gsi` 等

#### zk-nvim (`lua/plugins/zk.lua`)

Zettelkasten 筆記管理工具，整合 [zk](https://github.com/zk-org/zk) CLI。

**前置需求：** 需先安裝 zk CLI

```bash
# Arch Linux
sudo pacman -S zk

# macOS
brew install zk

# 或從 GitHub 下載
# https://github.com/zk-org/zk/releases
```

**初始化筆記庫：**

```bash
# 在你的筆記資料夾初始化
cd ~/notes
zk init
```

**快捷鍵：**

| 快捷鍵 | 模式 | 說明 |
|--------|------|------|
| `<leader>zn` | Normal | 建立新筆記 |
| `<leader>zo` | Normal | 開啟筆記列表 (依修改時間排序) |
| `<leader>zt` | Normal | 依標籤瀏覽筆記 |
| `<leader>zf` | Normal | 搜尋筆記內容 |
| `<leader>zb` | Normal | 顯示反向連結 (誰連到這篇) |
| `<leader>zl` | Normal | 顯示正向連結 (這篇連到誰) |
| `<leader>zi` | Normal | 插入筆記連結 |
| `<leader>zi` | Visual | 將選取文字轉為連結 |
| `<leader>znt` | Visual | 以選取文字為標題建立新筆記 |
| `<leader>znc` | Visual | 以選取文字為內容建立新筆記 |

**常用指令：**

| 指令 | 說明 |
|------|------|
| `:ZkNew` | 建立新筆記 |
| `:ZkNotes` | 開啟筆記列表 |
| `:ZkTags` | 依標籤瀏覽 |
| `:ZkBacklinks` | 反向連結 |
| `:ZkLinks` | 正向連結 |
| `:ZkIndex` | 重新索引筆記庫 |
| `:ZkCd` | 切換到筆記庫根目錄 |

---

## LazyVim 常用快捷鍵

> `<leader>` 預設是 `空白鍵 (Space)`

### 一般操作

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>` | 顯示快捷鍵選單 (which-key) |
| `<leader>qq` | 離開 Neovim |
| `<leader>l` | 開啟 Lazy 插件管理器 |

### 檔案與搜尋 (Telescope)

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>ff` | 搜尋檔案 |
| `<leader>fg` | 全域文字搜尋 (grep) |
| `<leader>fb` | 搜尋已開啟的 buffer |
| `<leader>fr` | 最近開啟的檔案 |
| `<leader><leader>` | 搜尋檔案 (同 `<leader>ff`) |
| `<leader>/` | 在當前 buffer 搜尋 |

### 檔案總管 (Neo-tree)

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>e` | 開啟/關閉檔案總管 |
| `<leader>E` | 開啟檔案總管 (當前檔案位置) |

### Buffer 操作

| 快捷鍵 | 說明 |
|--------|------|
| `<S-h>` | 上一個 buffer |
| `<S-l>` | 下一個 buffer |
| `<leader>bd` | 刪除當前 buffer |
| `<leader>bo` | 刪除其他 buffer |

### 視窗操作

| 快捷鍵 | 說明 |
|--------|------|
| `<C-h/j/k/l>` | 切換視窗 (左/下/上/右) |
| `<leader>-` | 水平分割視窗 |
| `<leader>\|` | 垂直分割視窗 |

### 程式碼 (LSP)

| 快捷鍵 | 說明 |
|--------|------|
| `gd` | 跳到定義 |
| `gr` | 查看引用 |
| `K` | 顯示文件說明 (hover) |
| `<leader>ca` | 程式碼動作 (Code Action) |
| `<leader>cr` | 重新命名 |
| `<leader>cf` | 格式化程式碼 |

### 診斷與問題

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>xx` | 開啟 Trouble (問題列表) |
| `]d` | 下一個診斷訊息 |
| `[d` | 上一個診斷訊息 |

### Git

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>gg` | 開啟 LazyGit |
| `<leader>gf` | 搜尋 Git 檔案 |
| `<leader>gc` | 搜尋 Git commits |
| `]h` | 下一個 hunk (變更區塊) |
| `[h` | 上一個 hunk |

### 終端機

| 快捷鍵 | 說明 |
|--------|------|
| `<C-/>` | 開啟/關閉終端機 |
| `<leader>ft` | 開啟浮動終端機 |

### 其他實用功能

| 快捷鍵 | 說明 |
|--------|------|
| `<leader>sn` | Noice 訊息歷史 |
| `<leader>un` | 關閉搜尋高亮 |
| `<leader>ur` | 重新繪製畫面 |

---

## 常用指令

| 指令 | 說明 |
|------|------|
| `:Lazy` | 開啟插件管理器 |
| `:LazyExtras` | 管理 LazyVim extras |
| `:Mason` | 開啟 LSP/工具安裝器 |
| `:checkhealth` | 檢查 Neovim 健康狀態 |
| `:MarkdownPreview` | 開啟 Markdown 瀏覽器預覽 |
| `:MarkdownPreviewStop` | 關閉 Markdown 預覽 |

---

## 目錄結構

```
~/.config/nvim/
├── init.lua              # 入口，載入 lazy.nvim
├── lazy-lock.json        # 插件版本鎖定檔
├── lazyvim.json          # LazyVim extras 設定
└── lua/
    ├── config/
    │   ├── autocmds.lua  # 自動指令
    │   ├── keymaps.lua   # 自訂快捷鍵
    │   ├── lazy.lua      # lazy.nvim 設定
    │   └── options.lua   # Vim 選項設定
    └── plugins/
        ├── image.lua         # 終端機圖片預覽 (Kitty)
        ├── img-clip.lua      # 剪貼簿貼圖
        ├── markdown-extra.lua # Markdown 編輯增強
        ├── markdown_view.lua # Markdown 渲染與預覽設定
        └── zk.lua            # Zettelkasten 筆記管理
```

---

## 參考資源

- [LazyVim 官方文件](https://www.lazyvim.org/)
- [LazyVim Keymaps](https://www.lazyvim.org/keymaps)
- [lazy.nvim 文件](https://lazy.folke.io/)
