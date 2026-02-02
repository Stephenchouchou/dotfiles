-- Markdown to PDF export using pandoc + weasyprint
--
-- Features:
--   - Export current Markdown file to PDF
--   - Support Chinese characters (CJK fonts)
--   - Support Mermaid diagrams
--   - Support GFM tables with borders
--   - Support checkboxes
--   - Auto open PDF after export
--
-- Keybinding: <leader>mp
--
-- Output: PDF will be saved in the same directory as the Markdown file
--
-- Dependencies (Arch Linux):
--   sudo pacman -S pandoc python-weasyprint noto-fonts-cjk
--   npm install -g mermaid-filter

return {
  "nvim-lua/plenary.nvim",
  keys = {
    {
      "<leader>mp",
      function()
        local file = vim.fn.expand("%:p")
        local output = vim.fn.expand("%:p:r") .. ".pdf"

        -- CSS for better styling
        local css = [[
@page { margin: 1.5cm; }
body { font-family: "Noto Sans CJK TC", sans-serif; margin: 0; line-height: 1.6; }
table { border-collapse: collapse; width: auto; margin: 1em 0; table-layout: fixed; }
th, td { border: 1px solid #333; padding: 8px 12px; text-align: left; vertical-align: top; }
th { background-color: #f0f0f0; font-weight: bold; }
code { background-color: #f4f4f4; padding: 2px 4px; border-radius: 3px; font-family: monospace; }
pre { background-color: #f4f4f4; padding: 1em; overflow-x: auto; }
input[type="checkbox"] { margin-right: 0.5em; }
li { margin: 0.3em 0; }
]]
        local css_file = vim.fn.tempname() .. ".css"
        local f = io.open(css_file, "w")
        f:write(css)
        f:close()

        local cmd = string.format(
          'pandoc "%s" -o "%s" --from=gfm --to=html5 --pdf-engine=weasyprint --css="%s" -F mermaid-filter',
          file,
          output,
          css_file
        )
        vim.fn.jobstart(cmd, {
          on_exit = function(_, code)
            os.remove(css_file)
            if code == 0 then
              vim.notify("PDF exported: " .. output, vim.log.levels.INFO)
              vim.fn.jobstart({ "xdg-open", output })
            else
              vim.notify("PDF export failed", vim.log.levels.ERROR)
            end
          end,
        })
        vim.notify("Exporting to PDF...", vim.log.levels.INFO)
      end,
      desc = "Markdown to PDF",
    },
  },
}
