require"gitlinker".setup({
  mappings = nil
})

vim.api.nvim_set_keymap('n', '<leader>gh', '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>', {silent = true})
vim.api.nvim_set_keymap('v', '<leader>gh', '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>', {})
