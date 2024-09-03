return  {
	'windwp/nvim-autopairs',
	event = 'InsertEnter',
	config = function()
		require('nvim-autopairs').setup({
			-- Options can be customized here
			disable_filetype = { "TelescopePrompt" , "vim" },
		})
	end
}

