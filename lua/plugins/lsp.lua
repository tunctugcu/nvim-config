return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		lazy = false,
		config = false,
	},
	{
		'williamboman/mason.nvim',
		lazy = false,
		config = function()
			require('mason').setup()
		end,
	},

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
          {name = 'luasnip'},  -- Snippet completion
          {name = 'buffer'},   -- Buffer words completion
          {name = 'path'},     -- File path completion
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),    -- Trigger completion with Ctrl+Space
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),   -- Scroll up in the documentation
          ['<C-d>'] = cmp.mapping.scroll_docs(4),    -- Scroll down in the documentation
          ['<C-e>'] = cmp.mapping.abort(),           -- Close the completion menu
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm the selection
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      local lsp_attach = function(client, bufnr)
        local opts = {buffer = bufnr}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
          'ts_ls',
          'eslint',
          'sourcekit',  -- Swift LSP
          'html',       -- HTML LSP
          'gopls',      -- Go LSP
		  'intelephense', -- PHP
        },
        automatic_installation = true,  -- Enable automatic installation
      })

      require('mason-lspconfig').setup_handlers({
		  function(server_name)
			  if server_name == 'tsserver' then
				  server_name = 'ts_ls'
			  end
			  require('lspconfig')[server_name].setup({
				  on_attach = lsp_attach,
				  capabilities = require('cmp_nvim_lsp').default_capabilities(),
			  })
		  end
      })
    end
  }
}

