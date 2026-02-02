return {
  "tadmccorkle/markdown.nvim",
  ft = "markdown",
  opts = {
    -- 啟用智慧貼上（選取文字後貼上 URL 自動變成連結）
    on_attach = function(bufnr)
      local map = vim.keymap.set
      local opts = { buffer = bufnr }

      -- 切換 checkbox
      map({ "n", "v" }, "<leader>mx", "<cmd>MDTaskToggle<cr>",
        vim.tbl_extend("force", opts, { desc = "Toggle checkbox" }))

      -- 清單操作
      map("n", "<leader>ml", "<cmd>MDListItemBelow<cr>",
        vim.tbl_extend("force", opts, { desc = "Add list item below" }))
      map("n", "<leader>mL", "<cmd>MDListItemAbove<cr>",
        vim.tbl_extend("force", opts, { desc = "Add list item above" }))

      -- 插入表格
      map("n", "<leader>mt", "<cmd>MDInsertToc<cr>",
        vim.tbl_extend("force", opts, { desc = "Insert table of contents" }))
    end,

    -- inline 樣式切換 (gs + 動作)
    inline_surround = {
      emphasis = {
        key = "i",
        txt = "*",
      },
      strong = {
        key = "b",
        txt = "**",
      },
      strikethrough = {
        key = "s",
        txt = "~~",
      },
      code = {
        key = "c",
        txt = "`",
      },
    },

    -- 連結相關
    link = {
      paste = {
        enable = true, -- 貼上 URL 時自動轉換成 Markdown 連結
      },
    },
  },
}
