local cmp = require'cmp'
local cmp_buffer = require('cmp_buffer')

cmp.setup({
  completion = {
    autocomplete = false,
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  mapping = {
    ['<C-n>'] = function (fallback)
      if cmp.visible() == true then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        cmp.complete()
      end
    end,
  },
  sorting = {
    comparators = {
      function(...) return cmp_buffer:compare_locality(...) end,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  }
})
