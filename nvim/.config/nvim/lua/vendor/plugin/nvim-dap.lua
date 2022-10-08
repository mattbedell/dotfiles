local dap = require('dap')
local api = vim.api
local node_config = {
  -- For this to work you need to make sure the node process is started with the `--inspect` flag.
  name = 'Attach to process',
  type = 'node2',
  request = 'attach',
  processId = require'dap.utils'.pick_process,
}

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/repos/vscode-node-debug2/out/src/nodeDebug.js'},
}

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/local/opt/llvm/bin/lldb-vscode', -- must be absolute path
  name = 'lldb'
}

dap.configurations.rust = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
  {
    -- If you get an "Operation not permitted" error using this, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Attach to process",
    type = 'lldb',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
    request = 'attach',
    pid = require('dap.utils').pick_process,
    args = {},
  },
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  node_config,
}

dap.configurations.typescript = {
  node_config,
}

api.nvim_set_keymap('n', '<leader>dc', [[<cmd>lua require'dap'.continue()<CR>]], { silent = false })

local dap_augroup = api.nvim_create_augroup('nvim-dap', { clear = true })
local win_leave_aucmd_id = null

vim.fn.sign_define('DapBreakpoint', { text = '**', texthl = 'DiagnosticError' })

-- Map K to hover while session is active.
local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
  for _, buf in pairs(api.nvim_list_bufs()) do
    local keymaps = api.nvim_buf_get_keymap(buf, 'n')
    for _, keymap in pairs(keymaps) do
      if keymap.lhs == "K" then
        table.insert(keymap_restore, keymap)
        api.nvim_buf_del_keymap(buf, 'n', 'K')
      end
    end
  end
  win_leave_aucmd_id = api.nvim_create_autocmd('WinLeave', {
    group = dap_augroup,
    pattern = '*',
    callback = function(args)
      if api.nvim_buf_get_option(args.buf, 'filetype') == 'dap-float' then
        api.nvim_buf_delete(args.buf, { force = true })
      end
    end
  })
  api.nvim_set_keymap('n', 'K', '<cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
  api.nvim_set_keymap('n', '<leader>dd', [[<cmd>lua require'dap'.close()<CR>]], { silent = false })
  api.nvim_set_keymap('n', '<leader>dt', [[<cmd>lua require'dap'.toggle_breakpoint()<CR>]], { silent = false })
  api.nvim_set_keymap('n', '<leader>do', [[<cmd>lua require'dap'.step_over()<CR>]], { silent = false })
  api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap'.step_into()<CR>]], { silent = false })
  api.nvim_set_keymap('n', '<leader>ds', [[<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>]], { silent = false })
end

dap.listeners.after['event_terminated']['me'] = function()
  api.nvim_del_autocmd(win_leave_aucmd_id)
  for _, keymap in pairs(keymap_restore) do
    api.nvim_buf_set_keymap(
      keymap.buffer,
      keymap.mode,
      keymap.lhs,
      keymap.rhs,
      { silent = keymap.silent == 1 }
    )
  end
  keymap_restore = {}
end
