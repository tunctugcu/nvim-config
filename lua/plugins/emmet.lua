return {
    'mattn/emmet-vim',
    config = function()
        vim.g.user_emmet_install_global = 1
        vim.api.nvim_set_keymap('i', '<C-i>', '<Plug>(emmet-expand-abbr)', { noremap = true, silent = true })
    end
}
