local package_manager_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(package_manager_path) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    package_manager_path,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { vim.out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(package_manager_path)

require("lazy").setup({
    spec = {{ import = "plugins" }},
    install = { colorscheme = { "slate" } },
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
  }
)
