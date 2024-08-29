local vk = vim.keymap
local silent = { silent = true }

-- General
vk.set('n', 'n', 'nzzzv', silent)          -- Next item in search is centered, folds are opened
vk.set('n', 'N', 'Nzzzv', silent)          -- Previous item in search is centered, folds are opened
vk.set('n', 'U', '<C-r>', silent)          -- Previous item in search is centered, folds are opened
vk.set('n', ' ', '<Leader>', silent)       -- Previous item in search is centered, folds are opened
vk.set('n', '\\', '<LocalLeader>', silent) -- Previous item in search is centered, folds are opened
-- vk.set('v', '<D-x>', '"+x',   silent) -- Cut
-- vk.set('v', '<D-c>', '"+y',   silent) -- Copy
-- vk.set('n', '<D-v>', '"+P',   silent) -- Paste
