
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    local builtin = require('telescope.builtin')
    local telescope = require('telescope')
    local opts = { noremap = true, silent = true }

    vim.keymap.set('n', '<Leader>ff', builtin.find_files, opts)
    vim.keymap.set('n', '<Leader>fg', builtin.live_grep, opts)
    vim.keymap.set('n', '<Leader>fb', builtin.buffers, opts)
    vim.keymap.set('n', '<Leader>fh', builtin.help_tags, opts)

    telescope.setup()
  end
}
