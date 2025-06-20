return {
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      {'mason-org/mason.nvim', opts = {}, config = function() require('mason').setup() end},
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('plugin-lsp-attach', { clear = true }),
        callback = function(event)

          -- helper
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')                          -- rename all instances of symbol
          map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction', { 'n', 'x' })  -- code actions
          map('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')                     -- jump to definition of symbol
          map('gD', vim.lsp.buf.declaration, '[g]oto [d]eclaration')                   -- jump to declaration of symbol
          map('gi', vim.lsp.buf.implementation, '[g]oto [i]mplementation')             -- jump to implementation of symbol
          map('gs', vim.lsp.buf.signature_help, '[g]et [s]ignature')
          map('ge', vim.diagnostic.open_float, '[g]et [e]rrors')                       -- display error
          map('gK', vim.lsp.buf.hover, '[g]et [k]nowledge')                            -- display symbol information

          -- two autocommands used to highlight references
          -- when cursor is moved, the highlights will be cleared
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('plugin-lsp-highlight', { clear = false })

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('plugin-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'plugin-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- keymap to toggle inlay hints
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- global lsp diagnostic
      vim.diagnostic.config({
        virtual_text = true,  -- show inline messages
        severity_sort = true, -- sort diagnostics by severity
      })

      -- specific lsp diagnostic
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { 'vim' },
              disable = { 'missing-fields' }
            }
          }
        }
      })

      -- specific lsp diagnostic
      vim.lsp.config('rust_analyzer', {
        server = {
          root_dir = function(startpath)
            require('lspconfig').util.root_pattern("Cargo.toml", "rust-project.json")(startpath)
          end,
        }
      })

      require('mason-lspconfig').setup()
    end,
  },
}

