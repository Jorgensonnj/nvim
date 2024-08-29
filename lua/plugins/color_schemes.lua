return {
  {
    'ayu-theme/ayu-vim',           -- Color Scheme
    lazy = false,
    priority = 100,
    config = function()
      vim.cmd([[colorscheme ayu]]) -- Select color scheme
    end,
  }
}
