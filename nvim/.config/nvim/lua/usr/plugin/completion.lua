local cmp = require'cmp'

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
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        cmp.complete()
      end
    end,
  },
})
