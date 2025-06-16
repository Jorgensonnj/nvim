return {
  {
    'romgrk/barbar.nvim',
    lazy = false,
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {icons = {filetype = {enabled = false}}},
    keys = {
      {'<TAB>', '<CMD>BufferNext<CR>'},                     -- move buffer focus to the right
      {'<S-TAB>', '<CMD>BufferPrevious<CR>'},               -- move buffer focus to the left
      {'<Leader><TAB>', '<CMD>BufferMoveNext<CR>'},         -- move buffer tab to the right
      {'<Leader><S-TAB>', '<CMD>BufferMovePrevious<CR>'},   -- move buffer tab to the left
      {'<Leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>'}, -- sort buffers by number
      {'<Leader>bn', '<Cmd>BufferOrderByName<CR>'},         -- sort buffers by name
      {'<Leader>bd', '<Cmd>BufferOrderByDirectory<CR>'},    -- sort buffers by directory
      {'<Leader>bl', '<Cmd>BufferOrderByLanguage<CR>'},     -- sort buffers by language
      {'<Leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>'}  -- sort buffers by window number
    }
  },
  {
    'nvim-lualine/lualine.nvim', -- Status line
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'filename', path = 1 }, 'diagnostics' },
        lualine_c = { "require('nvim-treesitter').statusline(200)" },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
      }
    }
  },
  {
    'norcalli/nvim-colorizer.lua', -- RGB and hex background colorizer
    config = function()
      require('colorizer').setup()
    end,
  },
}

