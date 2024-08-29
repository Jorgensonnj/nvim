return {
  {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lspconfig= require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      mason_lspconfig.setup()
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup {}
        end,
        ['lua_ls'] = function()
          lspconfig.lua_ls.setup {
            settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
          }
        end,
        ['rust_analyzer'] = function()
          lspconfig.rust_analyzer.setup {
            server = {
              root_dir = function(startpath)
                lspconfig.util.root_pattern("Cargo.toml", "rust-project.json")(startpath)
              end,
            }
          }
        end,
      })
    end,
  },
}

