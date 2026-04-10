-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- -- 允許隱藏文字標記（Markdown 渲染必備）
vim.opt.conceallevel = 2

-- 自動偵測 Big5/GBK 編碼，避免中文亂碼
vim.opt.fileencodings = "ucs-bom,utf-8,big5,gb2312,gbk,latin1"
