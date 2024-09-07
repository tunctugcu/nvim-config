return {
	"nvim-tree/nvim-tree.lua",
	requires = {
		"nvim-tree/nvim-web-devicons" -- for file icons
	},
	config = function()
		require("nvim-tree").setup({	
			disable_netrw = true,
			hijack_netrw = true,
			update_cwd = true,
			view = {
				width = 30,
				side = "left", -- Can be set to "right" if you prefer
			},
			filters = {
				dotfiles = false,
			},
			hijack_directories = {
				enable = false,
			},
			renderer = {
				highlight_git = true,
				icons = {
					show = {
						git = true,
						folder = true,
						file = true,
						folder_arrow = true,
					},
				},
			},
		})
	end
}
