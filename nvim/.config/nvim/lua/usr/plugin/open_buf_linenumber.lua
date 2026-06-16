
local M = {}

M.open_buf_linenumber = function(opts)
  local file, line = string.match(opts.args, "^(.+)[#:](%d+)$")
  if not file then
    file = opts.args
  end
  if file and vim.fn.filereadable(file) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(file))
    if line then
      vim.cmd(line)
    end
  else
    print("File not found: " .. tostring(file))
  end
end

return M
