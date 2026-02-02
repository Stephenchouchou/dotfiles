return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    -- 預設儲存圖片的資料夾
    default = {
      dir_path = "assets",
      file_name = "%Y-%m-%d-%H-%M-%S",
      use_absolute_path = false,
      relative_to_current_file = true,
    },

    -- 針對不同檔案類型的設定
    filetypes = {
      markdown = {
        url_encode_path = true,
        template = "![$CURSOR]($FILE_PATH)",
      },
    },
  },
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
    { "<leader>mf", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
  },
}
