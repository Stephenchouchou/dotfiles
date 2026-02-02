return {
  {
    "zk-org/zk-nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("zk").setup({
        -- 使用 Telescope 作為選擇器
        picker = "telescope",

        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
          },
          -- 在 zk notebook 中自動啟用 LSP
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })

      local opts = { noremap = true, silent = false }

      -- 筆記導航
      vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
        vim.tbl_extend("force", opts, { desc = "New note" }))
      vim.keymap.set("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
        vim.tbl_extend("force", opts, { desc = "Open notes" }))
      vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>",
        vim.tbl_extend("force", opts, { desc = "Open by tag" }))
      vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
        vim.tbl_extend("force", opts, { desc = "Find notes" }))

      -- 連結相關
      vim.keymap.set("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>",
        vim.tbl_extend("force", opts, { desc = "Backlinks" }))
      vim.keymap.set("n", "<leader>zl", "<Cmd>ZkLinks<CR>",
        vim.tbl_extend("force", opts, { desc = "Links" }))

      -- 視覺模式：從選取文字建立新筆記
      vim.keymap.set("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection<CR>",
        vim.tbl_extend("force", opts, { desc = "New note from title" }))
      vim.keymap.set("v", "<leader>znc", ":'<,'>ZkNewFromContentSelection<CR>",
        vim.tbl_extend("force", opts, { desc = "New note from content" }))

      -- 插入連結
      vim.keymap.set("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>",
        vim.tbl_extend("force", opts, { desc = "Insert link" }))
      vim.keymap.set("v", "<leader>zi", ":'<,'>ZkInsertLinkAtSelection<CR>",
        vim.tbl_extend("force", opts, { desc = "Insert link from selection" }))
    end,
  },
}
