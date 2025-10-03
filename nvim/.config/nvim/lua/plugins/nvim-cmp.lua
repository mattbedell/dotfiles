return {
  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
    },
    opts = function()
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
          -- { name = 'buffer' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        }),
        mapping = {
          ['<C-n>'] = function (fallback)
            if cmp.visible() == true then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
              cmp.complete()
            end
          end,
          ['<C-p>'] = function (fallback)
            if cmp.visible() == true then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
              fallback()
            end
          end,
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm({ select = false }),
        },
        window = {
          documentation = cmp.config.window.bordered(),
        },
        -- formatting = {
        --   fields = { "abbr" },
        --   format = function(entry, vim_item)
        --     vim_item.abbr = string.sub(vim_item.abbr, 1, 200)
        --     return vim_item
        --   end
        -- },
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
    end
  }
}
