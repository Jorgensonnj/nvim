-- init.lua

----------------------------------- Helpers ------------------------------------
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}    -- o->global, b->buffer-local, w->window-local

local silent  = { silent  = true }
local noremap = { noremap = true }
local silent_noremap = { silent = true, noremap = true }

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = noremap
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

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
local indent = 2

-- Global Options
opt('o', 'mouse', 'nic')                             -- mouse is able to move cursor
opt('o', 'hidden', true)                             -- Enable modified buffers in background
opt('o', 'syntax', 'on')                             -- Syntax highlighting
opt('o', 'scrolloff', 4)                             -- Lines of context
opt('o', 'smartcase', true)                          -- Don't ignore case with capitals
opt('o', 'lazyredraw', true)                         -- Lazy redraw of buffer
opt('o', 'ignorecase', true)                         -- Ignore case
opt('o', 'sidescrolloff', 8)                         -- Columns of context
opt('o', 'shiftround', true)                         -- Round indent
opt('o', 'splitbelow', true)                         -- Put new windows below current
opt('o', 'splitright', true)                         -- Put new windows right of current
opt('o', 'undolevels', 1000)                         -- Number of undo levels
opt('o', 'encoding', 'utf-8')                        -- Encode utf-8
opt('o', 'foldlevelstart', 99)                       -- Code will not be hidden on entry
opt('o', 'termguicolors', true)                      -- True color support
opt('o', 'backspace','indent,start,eol')             -- Backspace behaviour
opt('o', 'wildmode', 'longest,list,full')            -- Command-line completion mode
opt('o', 'clipboard','unnamedplus')                  -- Clipboard
opt('o', 'completeopt', 'menuone,noinsert,noselect') -- Completion options (for deoplete)
opt('o', 'inccommand', 'nosplit')                    -- Shows the effects of the cmd incrementally

-- Buffer-local Options
opt('b', 'expandtab', true)                          -- Tabs expanded to spaces
opt('b', 'tabstop', indent)                          -- Number of columns tab crosses
opt('b', 'autoindent', true)                         -- New lines auto indent
opt('b', 'smartindent', true)                        -- Insert indents automatically
opt('b', 'shiftwidth', indent)                       -- Size of an indent
opt('b', 'softtabstop', indent)                      -- Number of columns tab crosses

-- Window-local Options
opt('w', 'list', true)                               -- Show some invisible characters (tabs...)
opt('w', 'wrap', false)                              -- Disable line wrapping
opt('w', 'number', true)                             -- Print line number
opt('w', 'foldmethod', 'expr')                       -- Hide code method
opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')   -- Hide code using treesitter

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
    'ayu-theme/ayu-vim',               -- Color Scheme
    config = function()
      vim.cmd([[colorscheme ayu]])     -- Select color scheme
    end,
  },

  -- UI Plugins
  {
    'ap/vim-buftabline',               -- Tab manager
    config = function()
      vim.g.buftabline_show = 1        -- Tabs are shown
      vim.g.buftabline_numbers = 2     -- Tabs now numbers
    end,
  },
  {
    'nvim-lualine/lualine.nvim',       -- Status line
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = { { 'filename', path = 1 }, 'diagnostics'},
        lualine_c = {"require('nvim-treesitter').statusline(200)"},
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_c = {'filename'},
        lualine_x = {'location'},
      }
    }
  },
  {
    'norcalli/nvim-colorizer.lua',     -- RGB and hex background colorizer
    config = function()
      require('colorizer').setup()
    end,
  },

  -- Language & Syntax Plugins
  {
    'nvim-treesitter/nvim-treesitter', -- Tree-sitter manager
    opts = {
      highlight = {enable = true},
      indent    = {enable = true},
    }
  },
  {'neovim/nvim-lspconfig'},           -- LSP Config
  {
    'williamboman/mason.nvim',         -- package installer
    config = function()
      require("mason").setup()
    end,
  },
  {
    'williamboman/mason-lspconfig',    -- LSP installer
    dependencies = {
      'williamboman/mason.nvim'
    },
    config = function()
      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup()
      mason_lspconfig.setup_handlers({
        function (server_name)
          require('lspconfig')[server_name].setup {}
        end,
        ['lua_ls'] = function ()
          require("lspconfig").lua_ls.setup {
            settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
          }
        end,
      })
    end,
  },

  -- Completion Plugins
  {
    'hrsh7th/nvim-cmp',                -- Completion Core
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',          -- Completion LSP Source
      'hrsh7th/cmp-buffer',            -- Completion Buffer Sourc
      'hrsh7th/cmp-path',              -- Completion Path Source
      'saadparwaiz1/cmp_luasnip',      -- Completion Snip Source
      'L3MON4D3/LuaSnip',              -- Completion Snip Source
    },
    config = function ()
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
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'buffer', keyword_length = 4 },
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
      ft   = "📂", lazy = "💤", event  = "📅", config  = "🛠",
      cmd  = "⌘",  keys = "🗝", start  = "🚀", plugin  = "🔌",
      init = "⚙",  task = "📌", source = "📄", runtime = "💻",
    }
  }
})

-------------------------------- Mappings ------------------------------------------
-- General
map('n', 'n', 'nzzzv', silent)                  -- Next item in search is centered, folds are opened
map('n', 'N', 'Nzzzv', silent)                  -- Previous item in search is centered, folds are opened
-- map('v', '<D-x>', '"+x', {silent = false})      -- Cut
-- map('v', '<D-c>', '"+y', {silent = false})      -- Copy
-- map('n', '<D-v>', '"+P', {silent = false})      -- Paste

-- Buftabline
map('n', '<TAB>', ':bnext<CR>', silent)         -- Next Tab
map('n', '<S-TAB>', ':bprev<CR>', silent)       -- Previous Tab

-- cmp
map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', silent_noremap)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', silent_noremap)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', silent_noremap)
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', silent_noremap)
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', silent_noremap)

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
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
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-------------------------------- Snippet ------------------------------------

local luasnip = require('luasnip')

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("all", {
  s("warn", {
    t("warn \"----------"),
    i(1, "var"),
    t("----------\" . OHPA::Shared::Dumper::Dumper var;"),
  }, {
    key = "all",
  })
})

