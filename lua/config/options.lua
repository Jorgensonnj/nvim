local opt = vim.opt                            -- o->options_global
local indent = 2

-- Global Options
opt.mouse = 'nic'                             -- mouse is able to move cursor
opt.hidden = true                             -- Enable modified buffers in background
opt.syntax = 'on'                             -- Syntax highlighting
opt.scrolloff = 4                             -- Lines of context
opt.smartcase = true                          -- Don't ignore case with capitals
opt.lazyredraw = true                         -- Lazy redraw of buffer
opt.ignorecase = true                         -- Ignore case
opt.sidescrolloff = 8                         -- Columns of context
opt.shiftround = true                         -- Round indent
opt.splitbelow = true                         -- Put new windows below current
opt.splitright = true                         -- Put new windows right of current
opt.undolevels = 1000                         -- Number of undo levels
opt.encoding = 'utf-8'                        -- Encode utf-8
opt.foldlevelstart = 99                       -- Code will not be hidden on entry
opt.termguicolors = true                      -- True color support
opt.backspace = 'indent,start,eol'            -- Backspace behaviour
opt.wildmode = 'longest,list,full'            -- Command-line completion mode
opt.clipboard = 'unnamedplus'                 -- Clipboard
opt.completeopt = 'menuone,noinsert,noselect' -- Completion options (for deoplete)
opt.inccommand = 'nosplit'                    -- Shows the effects of the cmd incrementally

-- Buffer-local Options
opt.expandtab = true                          -- Tabs expanded to spaces
opt.tabstop = indent                          -- Number of columns tab crosses
opt.autoindent = true                         -- New lines auto indent
opt.smartindent = true                        -- Insert indents automatically
opt.shiftwidth = indent                       -- Size of an indent
opt.softtabstop = indent                      -- Number of columns tab crosses

-- Window-local Options
opt.list = true                               -- Show some invisible characters (tabs...)
opt.wrap = false                              -- Disable line wrapping
opt.number = true                             -- Print line number
opt.foldmethod = 'expr'                       -- Hide code method
opt.foldexpr = 'nvim_treesitter#foldexpr()'   -- Hide code using treesitter

