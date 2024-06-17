-- init.lua

----------------------------------- Helpers ------------------------------------

-- local function dump(var)
--    if type(var) == 'table' then
--       local str = '{ '
--       for key,val in pairs(var) do
--          if type(key) ~= 'number' then key = '"'..key..'"' end
--          str = str .. '['..key..'] = ' .. dump(val) .. ','
--       end
--       return str .. '} '
--    else
--       return tostring(var)
--    end
-- end

-------------------------------- Options ------------------------------------
local vg, vl, vw = vim.o, vim.bo, vim.wo     -- o->options_global, bo->options_buffer, wo->options_window
local indent = 2

-- Global Options
vg.mouse = 'nic'                             -- mouse is able to move cursor
vg.hidden = true                             -- Enable modified buffers in background
vg.syntax = 'on'                             -- Syntax highlighting
vg.scrolloff = 4                             -- Lines of context
vg.smartcase = true                          -- Don't ignore case with capitals
vg.lazyredraw = true                         -- Lazy redraw of buffer
vg.ignorecase = true                         -- Ignore case
vg.sidescrolloff = 8                         -- Columns of context
vg.shiftround = true                         -- Round indent
vg.splitbelow = true                         -- Put new windows below current
vg.splitright = true                         -- Put new windows right of current
vg.undolevels = 1000                         -- Number of undo levels
vg.encoding = 'utf-8'                        -- Encode utf-8
vg.foldlevelstart = 99                       -- Code will not be hidden on entry
vg.termguicolors = true                      -- True color support
vg.backspace = 'indent,start,eol'            -- Backspace behaviour
vg.wildmode = 'longest,list,full'            -- Command-line completion mode
vg.clipboard = 'unnamedplus'                 -- Clipboard
vg.completeopt = 'menuone,noinsert,noselect' -- Completion options (for deoplete)
vg.inccommand = 'nosplit'                    -- Shows the effects of the cmd incrementally

-- Buffer-local Options
vl.expandtab = true     -- Tabs expanded to spaces
vl.tabstop = indent     -- Number of columns tab crosses
vl.autoindent = true    -- New lines auto indent
vl.smartindent = true   -- Insert indents automatically
vl.shiftwidth = indent  -- Size of an indent
vl.softtabstop = indent -- Number of columns tab crosses

-- Window-local Options
vw.list = true                             -- Show some invisible characters (tabs...)
vw.wrap = false                            -- Disable line wrapping
vw.number = true                           -- Print line number
vw.foldmethod = 'expr'                     -- Hide code method
vw.foldexpr = 'nvim_treesitter#foldexpr()' -- Hide code using treesitter

-------------------------------- Plugins ---------------------------------------------
local package_manager_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(package_manager_path) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    package_manager_path,
  })
end
vim.opt.rtp:prepend(package_manager_path)

-- Plugins
local lazy = require("lazy")
lazy.setup({
    -- Color Schemes
    {
      'ayu-theme/ayu-vim',           -- Color Scheme
      config = function()
        vim.cmd([[colorscheme ayu]]) -- Select color scheme
      end,
    },
    -- UI Plugins
    {
      'ap/vim-buftabline',           -- Tab manager
      config = function()
        vim.g.buftabline_show = 1    -- Tabs are shown
        vim.g.buftabline_numbers = 2 -- Tabs now numbers
      end,
    },
    {
      'nvim-lualine/lualine.nvim', -- Status line
      opts = {
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
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
    {
      'ellisonleao/glow.nvim',
      config = true,
      cmd = "Glow"
    },
    -- Language & Syntax Plugins
    {
      'nvim-treesitter/nvim-treesitter', -- Tree-sitter manager
      opts = {
        highlight = { enable = true },
        indent    = { enable = true },
      }
    },
    { 'neovim/nvim-lspconfig' }, -- LSP Config
    {
      'williamboman/mason.nvim', -- package installer
      config = function()
        require("mason").setup()
      end,
    },
    {
      'williamboman/mason-lspconfig', -- LSP installer
      dependencies = {
        'williamboman/mason.nvim'
      },
      config = function()
        local lspconfig, mason_lspconfig = require('lspconfig'), require('mason-lspconfig')
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
    -- Completion Plugins
    {
      'hrsh7th/nvim-cmp',           -- Completion Core
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',     -- Completion LSP Source
        'hrsh7th/cmp-buffer',       -- Completion Buffer Sourc
        'hrsh7th/cmp-path',         -- Completion Path Source
        'saadparwaiz1/cmp_luasnip', -- Completion Snip Source
        'L3MON4D3/LuaSnip',         -- Completion Snip Source
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return
              col ~= 0 and
              vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = {
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
            ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
          },
          sources = {
            {name = 'nvim_lsp'},
            {name = 'path'},
            {name = 'luasnip'},
            {name = 'buffer', keyword_length = 4},
          },
          view = {
            entries = 'native',
          },
          experimental = {
            -- ghost_text = true,
          }
        })
      end,
    },
  },
  {
    ui = {
      icons = {
        ft = "📂",
        lazy = "💤",
        event = "📅",
        config = "🛠",
        cmd = "⌘",
        keys = "🗝",
        start = "🚀",
        plugin = "🔌",
        init = "⚙",
        task = "📌",
        source = "📄",
        runtime = "💻",
      }
    }
  })

-------------------------------- Mappings ------------------------------------------
local vk, vlb, vd = vim.keymap, vim.lsp.buf, vim.diagnostic
local silent = { silent = true }

-- General
vk.set('n', 'n', 'nzzzv', silent) -- Next item in search is centered, folds are opened
vk.set('n', 'N', 'Nzzzv', silent) -- Previous item in search is centered, folds are opened
vk.set('n', 'U', '<C-r>', silent) -- Previous item in search is centered, folds are opened
-- vk.set('v', '<D-x>', '"+x',   silent) -- Cut
-- vk.set('v', '<D-c>', '"+y',   silent) -- Copy
-- vk.set('n', '<D-v>', '"+P',   silent) -- Paste

-- Buftabline
vk.set('n', '<TAB>', ':bnext<CR>', silent)   -- Next Tab
vk.set('n', '<S-TAB>', ':bprev<CR>', silent) -- Previous Tab

-- cmp
vk.set('n', '<space>e', vd.open_float, silent)
vk.set('n', '[d', vd.goto_prev, silent)
vk.set('n', ']d', vd.goto_next, silent)
vk.set('n', '<space>q', vd.setloclist, silent)

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vl[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vk.set('n', 'gD', vlb.declaration, opts)
    vk.set('n', 'gd', vlb.definition, opts)
    vk.set('n', 'K', vlb.hover, opts)
    vk.set('n', 'gi', vlb.implementation, opts)
    vk.set('n', '<C-k>', vlb.signature_help, opts)
    vk.set('n', '<space>wa', vlb.add_workspace_folder, opts)
    vk.set('n', '<space>wr', vlb.remove_workspace_folder, opts)
    vk.set('n', '<space>D', vlb.type_definition, opts)
    vk.set('n', '<space>rn', vlb.rename, opts)
    vk.set('n', 'gr', vlb.references, opts)
    vk.set('n', '<space>f', vlb.format, opts)
    vk.set({ 'n', 'v' }, '<space>ca', vlb.code_action, opts)

    vk.set('n', '<space>wl', function()
      print(vim.inspect(vlb.list_workspace_folders()))
    end, opts)
  end,
})

-------------------------------- Snippet ------------------------------------

local luasnip = require('luasnip')
local snippet, text_node, insert_node = luasnip.snippet, luasnip.text_node, luasnip.insert_node

luasnip.add_snippets("all", {
  snippet("println!", {
    text_node("println!(\"{}\", "),
    insert_node(1, "var"),
    text_node(" );"),
  }, {
    key = "all",
  })
})
