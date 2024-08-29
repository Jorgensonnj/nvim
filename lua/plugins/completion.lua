return {
  {
    'hrsh7th/nvim-cmp',           -- Completion Core
    dependencies = {
      'hrsh7th/cmp-buffer',       -- Completion Buffer Sourc
      'hrsh7th/cmp-path',         -- Completion Path Source
      'saadparwaiz1/cmp_luasnip', -- Completion Snip Source
      'L3MON4D3/LuaSnip',         -- Completion Snip Source
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      require("luasnip.loaders.from_vscode").lazy_load()

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return
          col ~= 0 and
          vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
          :sub(col, col)
          :match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
        }),
        sources = {
          {name = 'nvim_lsp'},
          {name = 'path'},
          {name = 'luasnip'},
          {name = 'buffer', keyword_length = 4},
        },
        view = {
          entries = 'native',
        },
      })
    end,
  },
}
