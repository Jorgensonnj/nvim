-- init.lua

----------------------------------- Helpers ------------------------------------
local cmd = vim.cmd                                   -- to execute Vim commands
local fn = vim.fn                                     -- to call Vim functions e.g. fn.bufnr()
local g = vim.g                                       -- a table to access global variables

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}    -- o->global, b->buffer-local, w->window-local

local silent = {silent = true}
local noremap = {noremap = true}
local silent_noremap = {silent = true, noremap = true}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = noremap
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--local function dump(var)
--   if type(var) == 'table' then
--      local str = '{ '
--      for key,val in pairs(var) do
--         if type(key) ~= 'number' then key = '"'..key..'"' end
--         str = str .. '['..key..'] = ' .. dump(val) .. ','
--      end
--      return str .. '} '
--   else
--      return tostring(var)
--   end
--end

-------------------------------- Color Scheme ----------------------------------------

if pcall( function() cmd('colorscheme ayu') end ) then
  -- do nothing
else
  cmd('colorscheme desert')
end

-------------------------------- Plugins ---------------------------------------------
local data_base_path = os.getenv('XDG_DATA_HOME')
if not data_base_path then data_base_path = os.getenv('HOME') .. '/.local/share' end

local install_path = data_base_path .. "/nvim/site/pack/paqs/start/paq-nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

-- Plugins
local paq = require('paq')
paq {
  {'savq/paq-nvim', opt = true};                           -- Plugin manager

  -- Language & Syntax Plugins
  {'nvim-treesitter/nvim-treesitter'};                     -- Tree-sitter manager
  {'neovim/nvim-lspconfig'};                               -- LSP Config
  {'williamboman/nvim-lsp-installer'};                     -- LSP installer

  -- UI Plugins
  {'ap/vim-buftabline'};                                   -- Tab manager
  {'nvim-lualine/lualine.nvim'};                           -- Status line
  {'norcalli/nvim-colorizer.lua'};                         -- RGB and hex background colorizer

  -- Completion Plugins
  {'hrsh7th/nvim-cmp'};                                    -- Completion Core
  -- Completion Sources
  {'hrsh7th/cmp-nvim-lsp'};                                -- Completion LSP Source
  {'hrsh7th/cmp-buffer'};                                  -- Completion Buffer Source
  {'hrsh7th/cmp-path'};                                    -- Completion Path Source
  {'saadparwaiz1/cmp_luasnip'};                            -- Completion Snip Source

  -- Snippet Engine
  {'L3MON4D3/LuaSnip'};                                    -- Completion Snip Source

  -- Color Schemes
  {'ayu-theme/ayu-vim'};                                   -- Color Scheme
  {'NLKNguyen/papercolor-theme'};                          -- Color Scheme
}

-------------------------------- Options ------------------------------------
local indent = 2

-- Global Options
opt('o', 'mouse', 'nic')                              -- mouse is able to move cursor
opt('o', 'hidden', true)                              -- Enable modified buffers in background
opt('o', 'syntax', 'on')                              -- Syntax highlighting
opt('o', 'scrolloff', 4)                              -- Lines of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
opt('o', 'lazyredraw', true)                          -- Lazy redraw of buffer
opt('o', 'ignorecase', true)                          -- Ignore case
opt('o', 'sidescrolloff', 8)                          -- Columns of context
opt('o', 'shiftround', true)                          -- Round indent
opt('o', 'splitbelow', true)                          -- Put new windows below current
opt('o', 'splitright', true)                          -- Put new windows right of current
opt('o', 'undolevels', 1000)                          -- Number of undo levels
opt('o', 'encoding', 'utf-8')                         -- Encode utf-8
opt('o', 'foldlevelstart', 99)                        -- Code will not be hidden on entry
opt('o', 'termguicolors', true)                       -- True color support
opt('o', 'backspace','indent,start,eol')              -- Backspace behaviour
opt('o', 'wildmode', 'longest,list,full')             -- Command-line completion mode
opt('o', 'clipboard','unnamedplus')                   -- Clipboard
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options (for deoplete)
opt('o', 'inccommand', 'nosplit')                     -- Shows the effects of the cmd incrementally

-- Buffer-local Options
opt('b', 'expandtab', true)                           -- Tabs expanded to spaces
opt('b', 'tabstop', indent)                           -- Number of columns tab crosses
opt('b', 'autoindent', true)                          -- New lines auto indent
opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('b', 'shiftwidth', indent)                        -- Size of an indent
opt('b', 'softtabstop', indent)                       -- Number of columns tab crosses

-- Window-local Options
opt('w', 'list', true)                                -- Show some invisible characters (tabs...)
opt('w', 'wrap', false)                               -- Disable line wrapping
opt('w', 'number', true)                              -- Print line number
opt('w', 'foldmethod', 'expr')                        -- Hide code method
opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')    -- Hide code using treesitter

-------------------------------- Plugin Options ------------------------------------
-- Buftabline
g.buftabline_show = 1                                 -- Tabs are shown
g.buftabline_numbers = 2                              -- Tabs now numbers

-------------------------------- Mappings ------------------------------------------
-- General
map('n', 'n', 'nzzzv', silent)                  -- Next item in search is centered, folds are opened
map('n', 'N', 'Nzzzv', silent)                  -- Previous item in search is centered, folds are opened
--map('v', '<D-x>', '"+x', {silent = false})             -- Cut
--map('v', '<D-c>', '"+y', {silent = false})             -- Copy
--map('n', '<D-v>', '"+P', {silent = false})             -- Paste

-- Buftabline
map('n', '<TAB>', ':bnext<CR>', silent)         -- Next Tab
map('n', '<S-TAB>', ':bprev<CR>', silent)       -- Previous Tab

-- cmp
map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', silent_noremap)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', silent_noremap)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', silent_noremap)
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', silent_noremap)
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', silent_noremap)

-------------------------------- Completion Configuration -------------------------

local cmp = require("cmp")
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

--local config_base_path = os.getenv('XDG_CONFIG_HOME')
--if not config_base_path then config_base_path = os.getenv('HOME') .. '/.config' end

--local snippet_path = config_base_path .. "/nvim/snippets"

--require('luasnip.loaders.from_vscode').lazy_load({ paths = { snippet_path } })

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

-------------------------------- Snippet ------------------------------------

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("all", {
  s("warn", {
    t("warn \"----------"),
    i(1, "var"),
    t("----------\" OHPA::Shared::Dumper::Dumper "),
    i(2, "var"),
    i(0),
    t(";"),
  }, {
    key = "all",
  })
})

-------------------------------- Tree-sitter Config ------------------------------------

local ts = require('nvim-treesitter.configs')
ts.setup {
  highlight = {enable = true},
  indent = {enable = true},
}

-------------------------------- Status Line -------------------------------------------

require('lualine').setup {
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

-------------------------------- Colorizer Setup ---------------------------------------

require('colorizer').setup()

-------------------------------- LSP Config and Install --------------------------------

local common_on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- lsp mappings
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', silent_noremap)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', silent_noremap)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Installed servers will have defined configurations attached to them
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = common_on_attach,
    capabilities = capabilities
  }

  if server.name == "sumneko_lua" then
    opts.settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

