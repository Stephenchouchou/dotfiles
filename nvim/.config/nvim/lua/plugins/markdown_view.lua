return {
  -- 1. 終端機內的偽 WYSIWYG 渲染 (讓 ## 變成粗體標題，表格對齊)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      code = {
        sign = false,
        width = "block", -- 讓程式碼區塊有背景色
        right_pad = 1,
      },
      heading = {
        sign = false, -- 隱藏 ## 符號
        icons = {}, -- 不使用額外 icon
      },
      checkbox = {
        enabled = true,
      },
    },
    ft = { "markdown", "norg", "rmd", "org" },
  },

  -- 2. 瀏覽器即時預覽 (如果需要看複雜圖表或 Mermaid)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- 設定預覽時的瀏覽器，Arch Linux 下通常不需要設，如果打不開可指定
      -- vim.g.mkdp_browser = 'firefox'
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview (Browser)" },
    },
  },
}
