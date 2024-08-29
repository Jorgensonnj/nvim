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
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.set_log_level 'trace'
      require('vim.lsp.log').set_format_func(vim.inspect)
      local on_attach = function(_, bufnr)
        local function buf_set_option(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
      end

      mason_lspconfig.setup()
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities
          })
        end,
        ['lua_ls'] = function()
          lspconfig.lua_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
          }
        end,
        ['rust_analyzer'] = function()
          lspconfig.rust_analyzer.setup {
            on_attach = on_attach,
            capabilities = capabilities,
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

