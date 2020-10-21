local util = require 'vim.lsp.util'
local api = vim.api
local vim = vim
local M = {}

-- the default callback as of NVIM v0.5.0-763-geaee3d929 for:
-- - textDocument/declaration
-- - textDocument/definition
-- - textDocument/typeDefinition
-- - textDocument/implementation

-- tweaked to open the qf list as the bottom most window every time

local function location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(method, 'No location found')
    return nil
  end

  -- textDocument/definition can return Location or Location[]
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

  if vim.tbl_islist(result) then
    util.jump_to_location(result[1])

    if #result > 1 then
      util.set_qflist(util.locations_to_items(result))
      api.nvim_command("botright copen")
      api.nvim_command("wincmd p")
    end
  else
    util.jump_to_location(result)
  end
end


-- the default callback as of NVIM v0.5.0-763-geaee3d929 for:
-- - textDocument/documentSymbol
-- - workspace/symbol

-- tweaked to open the qf list as the bottom most window every time
local symbol_callback = function(_, _, result, _, bufnr)
  if not result or vim.tbl_isempty(result) then return end

  util.set_qflist(util.symbols_to_items(result, bufnr))
  api.nvim_command("botright copen")
  api.nvim_command("wincmd p")
end

M.on_attach = function(_, _)
  vim.lsp.callbacks["textDocument/declaration"] = location_callback
  vim.lsp.callbacks["textDocument/definition"] = location_callback
  vim.lsp.callbacks["textDocument/typeDefinition"] = location_callback
  vim.lsp.callbacks["textDocument/implementation"] = location_callback

  vim.lsp.callbacks["textDocument/documentSymbol"] = symbol_callback
  vim.lsp.callbacks["workspace/symbol"] = symbol_callback
end

return M
