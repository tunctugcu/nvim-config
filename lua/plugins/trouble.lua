return {
	'folke/trouble.nvim',
	lazy = false,
	config = function()
		local trouble = require("trouble")
		trouble.setup({
			icons = false,
		})

		vim.keymap.set("n", "<leader>tt", function() trouble.toggle() end)
		vim.keymap.set("n", "[d", function() trouble.next({skip_groups = true, jumps = true}) end)
		vim.keymap.set("n", "]d", function() trouble.previous({skip_groups = true, jumps = true}) end)
	end
}
