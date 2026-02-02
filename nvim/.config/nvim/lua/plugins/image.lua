return {
  "3rd/image.nvim",
  lazy = false, -- 確保載入
  opts = {
    backend = "kitty",
    processor = "magick_cli",
    integrations = {
      markdown = {
        enabled = true,
        download_remote_images = true,
        only_render_image_at_cursor = false,
      },
    },
    max_height_window_percentage = 50,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
}
