return {
	"williamboman/mason-lspconfig.nvim",

	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/nvim-cmp',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'j-hui/fidget.nvim',
    'jose-elias-alvarez/null-ls.nvim', -- Add null-ls for Prettier integration
		'nvim-lua/plenary.nvim', -- Required by null-ls
	},
	config = function ()
		local cmp_lsp = require('cmp_nvim_lsp')
		local capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		cmp_lsp.default_capabilities()
		)
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				'html',
				'tailwindcss',
				'lua_ls',
				'ts_ls',
				'eslint',
				'html',
				'gopls',
			},
			handlers = {
				function(server_name)

					if server_name == 'tsserver' then
						server_name = 'ts_ls'
					end

					require('lspconfig')[server_name].setup({
						capabilities = capabilities
					})
				end,
				["lua_ls"] = function ()
					require('lspconfig').lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" }
								}
							}
						}
					})
				end
			},
		})

    -- Prettier setup using null-ls
		local null_ls = require('null-ls')
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.prettierd, -- Use Prettier daemon
			},
			on_attach = function(client, bufnr)
				if client.server_capabilities.documentFormattingProvider then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end,
		})

		local cmp = require('cmp')
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
				['<Tab>'] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
			}, {
				{ name = 'buffer' },
			})
		})

		vim.diagnostic.config({
			update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
			virtual_text = true,
		})
	end
}
