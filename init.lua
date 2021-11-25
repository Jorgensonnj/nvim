-- init.lua

----------------------------------- Helpers ------------------------------------
local cmd = vim.cmd                                   -- to execute Vim commands
local fn = vim.fn                                     -- to call Vim functions e.g. fn.bufnr()
local g = vim.g                                       -- a table to access global variables

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}    -- o->global, b->buffer-local, w->window-local

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------------------- Color Scheme ----------------------------------------

if pcall( function() cmd('colorscheme ayu') end ) then
  -- do nothing
else
  cmd('colorscheme desert')
end

-------------------------------- Plugins ---------------------------------------------
local base_path = os.getenv('XDG_DATA_HOME')
if not base_path then base_path = os.getenv('HOME') .. '/.local/share' end

local install_path = base_path .. "/site/pack/paqs/start/paq-nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

cmd('packadd paq-nvim')                                    -- Load plugin manager

-- Plugins
local paq = require('paq-nvim')
paq {
  {'savq/paq-nvim', opt = true};                           -- Plugin manager
  {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};  -- Tree-sitter manager
  {'neovim/nvim-lspconfig'};                               -- LSP Config
  -- {'nvim-lua/lsp-status.nvim'};                            -- LSP status
  {'williamboman/nvim-lsp-installer'};                     -- LSP installer
  {'ap/vim-buftabline'};                                   -- Tab manager

  {'hrsh7th/nvim-cmp'};                                    -- Completion Core
  {'hrsh7th/cmp-nvim-lsp'};                                -- Completion LSP Source
  {'hrsh7th/cmp-buffer'};                                  -- Completion Buffer Source
  {'hrsh7th/cmp-vsnip'};                                   -- Completion Snip Source
  {'hrsh7th/vim-vsnip'};                                   -- Completion Snip Source

  {'ayu-theme/ayu-vim'};                                   -- Color Scheme
  {'NLKNguyen/papercolor-theme'};                          -- Color Scheme
}

-------------------------------- Options ------------------------------------
local indent = 2

opt('o', 'mouse', 'nic')                              -- mouse is able to move cursor
opt('o', 'hidden', true)                              -- Enable modified buffers in backgroundl
opt('o', 'syntax', 'on')                              -- Syntax highlighting
opt('o', 'scrolloff', 4)                              -- Lines of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
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
map('n', 'n', 'nzzzv', {silent = true})                  -- Next item in search is centered, folds are opened
map('n', 'N', 'Nzzzv', {silent = true})                  -- Previous item in search is centered, folds are opened
--map('v', '<D-x>', '"+x', {silent = false})             -- Cut
--map('v', '<D-c>', '"+y', {silent = false})             -- Copy
--map('n', '<D-v>', '"+P', {silent = false})             -- Paste

-- Buftabline
map('n', '<TAB>', ':bnext<CR>', {silent = true})      -- Next Tab
map('n', '<S-TAB>', ':bprev<CR>', {silent = true})    -- Previous Tab

-------------------------------- Completion Configuration -------------------------

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = function (fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
    ['<S-Tab>'] = function (fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end,
    ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
    ['<S-CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer', keyword_length = 5 },
  },
  experimental = {
    native_menu = true,
    -- ghost_text = true,
  }
})

-------------------------------- Tree-sitter Config ------------------------------------

local ts = require('nvim-treesitter.configs')
ts.setup {
  highlight = {enable = true},
  indent = {enable = true},
}

-------------------------------- LSP Status --------------------------------------------

-- local lsp_status = require('lsp-status')
-- lsp_status.register_progress()

-------------------------------- LSP Config and Install --------------------------------

local common_on_attach = function(client, bufnr)
  -- Mappings.
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

--   lsp_status.on_attach(client)

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
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

-------------------------------- Post LSP Initalization --------------------------------

-- local function lsp_status_start()
--   if #vim.lsp.buf_get_clients() > 0 then
--     return lsp_status.status()
--   end
--   return ''
-- end

-- lsp_status.status()
