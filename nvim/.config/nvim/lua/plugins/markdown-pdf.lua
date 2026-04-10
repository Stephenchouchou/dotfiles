-- Markdown export: PDF document & Marp slide deck
--
-- Keybindings:
--   <leader>mp  — Export as A4 PDF document (pandoc + weasyprint)
--   <leader>ms  — Export as 16:9 slide PDF  (Marp)
--   <leader>mw  — Export as PPTX slide      (Marp)
--
-- Output: saved in the same directory as the source .md file
--   <leader>mp → filename.pdf
--   <leader>ms → filename-slides.pdf
--   <leader>mw → filename-slides.pptx
--
-- Dependencies (Arch Linux):
--   sudo pacman -S pandoc python-weasyprint noto-fonts-cjk
--   npm install -g mermaid-filter @marp-team/marp-cli
--
-- Note: Marp uses a wrapper script at ~/.local/bin/marp-export
--       for logging (see /tmp/marp-export.log on failure).
--       --no-stdin is required because Neovim jobstart pipes stdin,
--       which causes Marp to wait for stdin instead of reading the file.

return {
  "nvim-lua/plenary.nvim",
  keys = {
    -- Marp: Markdown → Slide PDF
    {
      "<leader>ms",
      function()
        local file = vim.fn.expand("%:p")
        local output = vim.fn.expand("%:p:r") .. "-slides.pdf"
        vim.fn.jobstart({ "marp-export", "--no-stdin", file, "--pdf", "--allow-local-files", "-o", output }, {
          on_exit = function(_, code)
            vim.schedule(function()
              if code == 0 then
                vim.notify("Slide PDF exported: " .. output, vim.log.levels.INFO)
                vim.fn.jobstart({ "xdg-open", output })
              else
                vim.notify("Marp failed, see /tmp/marp-export.log", vim.log.levels.ERROR)
              end
            end)
          end,
        })
        vim.notify("Exporting slides to PDF...", vim.log.levels.INFO)
      end,
      desc = "Marp Slide to PDF",
    },
    -- Marp: Markdown → PPTX
    {
      "<leader>mw",
      function()
        local file = vim.fn.expand("%:p")
        local output = vim.fn.expand("%:p:r") .. "-slides.pptx"
        vim.fn.jobstart({ "marp-export", "--no-stdin", file, "--pptx", "--allow-local-files", "--image-scale", "6", "-o", output }, {
          on_exit = function(_, code)
            vim.schedule(function()
              if code == 0 then
                vim.notify("PPTX exported: " .. output, vim.log.levels.INFO)
                vim.fn.jobstart({ "xdg-open", output })
              else
                vim.notify("Marp PPTX failed, see /tmp/marp-export.log", vim.log.levels.ERROR)
              end
            end)
          end,
        })
        vim.notify("Exporting slides to PPTX...", vim.log.levels.INFO)
      end,
      desc = "Marp Slide to PPTX",
    },
    -- Pandoc: Markdown → A4 PDF document
    {
      "<leader>mp",
      function()
        local file = vim.fn.expand("%:p")
        local output = vim.fn.expand("%:p:r") .. ".pdf"

        local css = [[
          @page { size: A4; margin: 1cm; }
          body { font-family: "Noto Sans CJK TC", sans-serif; font-size: 12px; line-height: 1.3; margin: 0; }
          h1, h2, h3, h4 { margin-top: 0.6em; margin-bottom: 0.3em; }
          p { margin: 0.3em 0; }
          table { border-collapse: collapse; width: auto; margin: 0.5em 0; table-layout: fixed; }
          th, td { border: 1px solid #333; padding: 4px 6px; text-align: left; vertical-align: top; font-size: 11px; }
          th { background-color: #f0f0f0; font-weight: bold; }
          code { background-color: #f4f4f4; padding: 1px 3px; border-radius: 2px; font-size: 11px; }
          pre { background-color: #f4f4f4; padding: 0.5em; overflow-x: auto; font-size: 11px; }
          input[type="checkbox"] { margin-right: 0.3em; }
          li { margin: 0.2em 0; }
          h1, h2, h3 { page-break-after: avoid; }
          table { page-break-inside: avoid; }
        ]]

        local css_file = vim.fn.tempname() .. ".css"
        local f = io.open(css_file, "w")
        f:write(css)
        f:close()

        local cmd = string.format(
          'pandoc "%s" -o "%s" --from=gfm --to=html5 --pdf-engine=weasyprint --css="%s" -F mermaid-filter',
          file, output, css_file
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
