local vim = vim
local uv = vim.uv
local M = {}


local function open_pr()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local file = vim.api.nvim_buf_get_name(0)
  local blame = vim.system({'git', 'blame', '-L', row .. ',' .. row, '--porcelain', file }):wait().stdout
  -- vim.print(blame)
  local getSummary = vim.system({ "gawk", "/^summary/ { print $0 }" }, { text = true, stdin = true })
  local getPRNum = vim.system({ "ggrep", "-oP", [[(?<=\(#)\d+(?=\))]] }, { text = false, stdin = true }, function(obj)
    if obj.code == 0 then
      local prNum = obj.stdout:gsub("%c", "")
      if vim.fn.executable("gh") == 1 then
        vim.system({ "gh", "pr", "view", prNum, "-w" }, { stdin = true }, function(gh)
          print(gh.stdout)
        end)
      else
        -- @todo get repo from remote and construct PR url manually
      end
    else
      print("Could not parse PR # from blame")
    end
  end)

  getSummary:write(blame)
  getSummary:write(nil)

  local summary = getSummary:wait().stdout
  getPRNum:write(summary)
  getPRNum:write(nil)
end

M.open_pr = open_pr

return M
