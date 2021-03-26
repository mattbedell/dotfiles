require'compe'.setup{
  enabled = true;
  autocomplete = false;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    treesitter = true;
    spell = true;
    tags = true;
    snippets_nvim = false;
  };
}

vim.api.nvim_set_keymap('i', '<c-n>', [[pumvisible() ? '<c-n>' : compe#complete()]], {noremap = true, silent = true, expr = true})

