local module = {}

function module.simulateKeys(keys, mode)
  mode = mode or "n"
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode, false)
end

function module.getScriptDir(debug_getInfo_2_S)
  local source = debug_getInfo_2_S.source
  if source:sub(1, 1) == "@" then
    local script_path = source:sub(2)
    return vim.fn.fnamemodify(script_path, ":p:h")
  end
  return nil -- nếu là string eval hoặc [C], etc.
end

return module
