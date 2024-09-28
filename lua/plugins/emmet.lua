return {
  'mattn/emmet-vim',
  config = function()
    vim.g.user_emmet_install_global = 1  -- Enable Emmet globally

    -- Custom Emmet settings for HTML to ensure correct meta tags are inserted
    vim.g.user_emmet_settings = {
      html = {
        snippets = {
          ["html:5"] = [[
            <!DOCTYPE html>
            <html lang="en">
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Document</title>
            </head>
            <body>

            </body>
            </html>
          ]]
        }
      }
    }

    -- Function to expand Emmet abbreviation and auto-indent the expanded code
    local function expand_and_indent()
      -- Expand abbreviation using Emmet
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(emmet-expand-abbr)', true, true, true))
      -- Re-indent the current line/block
      vim.lsp.buf.format({ async = true })
    end

    -- Use vim.keymap.set to map <C-i> in insert mode
    vim.keymap.set('i', '<C-i>', expand_and_indent, { noremap = true, silent = true })
  end
}
