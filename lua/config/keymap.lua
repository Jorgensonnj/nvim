local vk = vim.keymap
local opts = { noremap = true, silent = true }

-- General
vk.set('n', 'n', 'nzzzv', opts)          -- Next item in search is centered, folds are opened
vk.set('n', 'N', 'Nzzzv', opts)          -- Previous item in search is centered, folds are opened
vk.set('n', 'U', '<C-r>', opts)          -- Undo
vk.set('n', 'j', 'gj', opts)             -- move cursor down on a wrapped line in normal mode
vk.set('n', 'k', 'gk', opts)             -- move cursor up on a wrapped line in normal mode
vk.set('v', 'j', 'gj', opts)             -- move cursor down on a wrapped line in visual mode
vk.set('v', 'k', 'gk', opts)             -- move cursor up on a wrapped line in visual mode

-- vk.set('v', '<D-x>', '"+x', opts) -- Cut
-- vk.set('v', '<D-c>', '"+y', opts) -- Copy
-- vk.set('n', '<D-v>', '"+P', opts) -- Paste
