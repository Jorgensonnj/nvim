return {
  {
    'romgrk/barbar.nvim',
    lazy = false,
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      icons = {
        filetype = {
          enabled = false,
          custom_colors = true
        }
      }
    },
    keys = {
     {'<TAB>', '<CMD>BufferNext<CR>'},                    -- move buffer focus to the right
     {'<S-TAB>', '<CMD>BufferPrevious<CR>'},              -- move buffer focus to the left
     {'<Space><TAB>', '<CMD>BufferMoveNext<CR>'},         -- move buffer tab to the right
     {'<Space><S-TAB>', '<CMD>BufferMovePrevious<CR>'},   -- move buffer tab to the left
     {'<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>'}, -- sort buffers by number
     {'<Space>bn', '<Cmd>BufferOrderByName<CR>'},         -- sort buffers by name
     {'<Space>bd', '<Cmd>BufferOrderByDirectory<CR>'},    -- sort buffers by directory
     {'<Space>bl', '<Cmd>BufferOrderByLanguage<CR>'},     -- sort buffers by language
     {'<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>'}  -- sort buffers by window number
    }
  },
  {
    'nvim-lualine/lualine.nvim', -- Status line
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'filename', path = 1 }, 'diagnostics' },
        lualine_c = { "require('nvim-treesitter').statusline(200)" },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
      }
    }
  },
  {
    'norcalli/nvim-colorizer.lua', -- RGB and hex background colorizer
    config = function()
      require('colorizer').setup()
    end,
  },
}

--     -- Language & Syntax Plugins
--     {
--       'nvim-treesitter/nvim-treesitter', -- Tree-sitter manager
--       opts = {
--         highlight = { enable = true },
--         indent    = { enable = true },
--       }
--     },
--     { 'neovim/nvim-lspconfig' }, -- LSP Config
--     {
--       'williamboman/mason.nvim', -- package installer
--       config = function()
--         require("mason").setup()
--       end,
--     },
--     {
--       'williamboman/mason-lspconfig', -- LSP installer
--       dependencies = {
--         'williamboman/mason.nvim'
--       },
--       config = function()
--         local lspconfig, mason_lspconfig = require('lspconfig'), require('mason-lspconfig')
--         mason_lspconfig.setup()
--         mason_lspconfig.setup_handlers({
--           function(server_name)
--             lspconfig[server_name].setup {}
--           end,
--           ['lua_ls'] = function()
--             lspconfig.lua_ls.setup {
--               settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
--             }
--           end,
--           ['rust_analyzer'] = function()
--             lspconfig.rust_analyzer.setup {
--               server = {
--                 root_dir = function(startpath)
--                   lspconfig.util.root_pattern("Cargo.toml", "rust-project.json")(startpath)
--                 end,
--               }
--             }
--           end,
--         })
--       end,
--     },
--     -- Completion Plugins
--     {
--       'hrsh7th/nvim-cmp',           -- Completion Core
--       dependencies = {
--         'hrsh7th/cmp-nvim-lsp',     -- Completion LSP Source
--         'hrsh7th/cmp-buffer',       -- Completion Buffer Sourc
--         'hrsh7th/cmp-path',         -- Completion Path Source
--         'saadparwaiz1/cmp_luasnip', -- Completion Snip Source
--         'L3MON4D3/LuaSnip',         -- Completion Snip Source
--       },
--       config = function()
--         local cmp = require('cmp')
--         local luasnip = require('luasnip')
-- 
--         local has_words_before = function()
--           local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--           return
--               col ~= 0 and
--               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--         end
-- 
--         cmp.setup({
--           snippet = {
--             expand = function(args)
--               luasnip.lsp_expand(args.body)
--             end,
--           },
--           mapping = {
--             ['<Tab>'] = cmp.mapping(function(fallback)
--               if cmp.visible() then
--                 cmp.select_next_item()
--               elseif luasnip.expand_or_jumpable() then
--                 luasnip.expand_or_jump()
--               elseif has_words_before() then
--                 cmp.complete()
--               else
--                 fallback()
--               end
--             end, { "i", "s" }),
--             ['<S-Tab>'] = cmp.mapping(function(fallback)
--               if cmp.visible() then
--                 cmp.select_prev_item()
--               elseif luasnip.jumpable(-1) then
--                 luasnip.jump(-1)
--               else
--                 fallback()
--               end
--             end, { "i", "s" }),
--             ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
--             ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
--           },
--           sources = {
--             {name = 'nvim_lsp'},
--             {name = 'path'},
--             {name = 'luasnip'},
--             {name = 'buffer', keyword_length = 4},
--           },
--           view = {
--             entries = 'native',
--           },
--           experimental = {
--             -- ghost_text = true,
--           }
--         })
--       end,
--     },
