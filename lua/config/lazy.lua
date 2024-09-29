-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.expandtab = true       -- Convert tabs to spaces
vim.opt.tabstop = 2            -- Number of spaces per tab
vim.opt.shiftwidth = 2         -- Number of spaces for each indentation level
vim.opt.softtabstop = 2        -- Number of spaces a <Tab> counts for while editing


vim.api.nvim_set_hl(0, "Normal", { bg = "none" } )
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" } )

vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.splitright = true

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "<C-J>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-K>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>")

vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<leader>lss', ':LiveServerStart<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lst', ':LiveServerStop<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(e)
		local opts = { buffer = e.buf }
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	-- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	-- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.signature_help() end, opts)


  vim.keymap.set("n", "<leader>vcc", function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return action.title:lower():match("fix") and action.title:lower():match("prettier")
      end,
    })
  end, { noremap = true, silent = true })
	end
})

vim.keymap.set("n", "<leader>th", function()
  vim.cmd('vsplit')
  vim.cmd(':terminal')
end)

vim.api.nvim_create_augroup("AutoSaveFocusLost", { clear = true })
vim.api.nvim_create_autocmd("FocusLost", {
  group = "AutoSaveFocusLost",
  pattern = "*",
  callback = function()
    vim.cmd("silent! write")
  end,
})

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
  ui = {
    notify = false
  },
	change_detection = {
		notify = false
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

