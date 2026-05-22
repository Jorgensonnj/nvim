local opt = vim.opt  -- opt->options_global
local indent = 2

-- UI & Visuals
opt.termguicolors = true  -- Enable 24-bit colors
opt.syntax = 'on'         -- Syntax highlighting
opt.number = true         -- Line numbers
opt.cursorline = true     -- Highlight current line
opt.list = true           -- Show some invisible characters (tabs...)
opt.showmatch = true      -- Highlight matching brackets

-- Line Wrapping & Navigation
opt.wrap = false         -- Don't wrap lines
opt.linebreak = true     -- Wrap lines at convenient points
opt.scrolloff = 4        -- Keep 4 lines above/below cursor
opt.sidescrolloff = 8    -- Keep 8 columns left/right of cursor
opt.smoothscroll = true  -- Smooth scrolling for wrapped/folded lines

-- Windows & Splits
opt.splitbelow = true  -- Put new windows below current
opt.splitright = true  -- Put new windows right of current

-- Indentation & Tabs
opt.tabstop = indent      -- Tab width
opt.shiftwidth = indent   -- Indent width
opt.softtabstop = indent  -- Soft tab stop
opt.expandtab = true      -- Use spaces instead of tabs
opt.autoindent = true     -- Copy indent from current line
opt.smartindent = true    -- Smart auto-indenting

-- Search
opt.ignorecase = true  -- Case insensitive search
opt.smartcase = true   -- Case sensitive if uppercase in search
opt.incsearch = true   -- Show matches as you type
opt.path:append("**")  -- Include subdirectories in search

-- Command-Line & Completion
opt.wildmenu = true                                 -- Command-line completion menu
opt.wildmode = "longest:full,full"                  -- Command-line completion mode
opt.inccommand = 'nosplit'                          -- Show the effects of commands incrementally (e.g. substitute)
opt.completeopt = 'menu,menuone,noinsert,noselect'  -- Completion options for menus

-- Code Folding
opt.foldlevel = 99                          -- Start with all folds open
opt.foldexpr = 'nvim_treesitter#foldexpr()' -- Hide code using treesitter

-- File Handling & Backups
opt.backup = false       -- Don't create backup files
opt.writebackup = false  -- Don't create backup before writing
opt.swapfile = false     -- Don't create swap files
opt.undofile = true      -- Persistent undo
opt.undolevels = 1000    -- Maximum number of changes that can be undone
opt.autoread = true      -- Auto reload files changed outside vim
opt.autowrite = true     -- Auto save

-- Editor Behavior & Environment
opt.encoding = "UTF-8"
opt.hidden = true                                        -- Allow hidden buffers
opt.errorbells = false                                   -- No error bells
opt.autochdir = false                                    -- Don't auto change directory
opt.iskeyword:append("-")                                -- Treat dash as part of word
opt.selection = "inclusive"                              -- Selection behavior
opt.virtualedit = "block"                                -- Allow cursor to move where there is no text in visual block mode
opt.mouse = 'nic'                                        -- Mouse is able to move cursor
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"  -- Sync with system clipboard
opt.modifiable = true                                    -- Allow buffer modifications
