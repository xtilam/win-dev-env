_G.dd = function(...)
  local args = { ... }
  for i, v in pairs(args) do
    vim.notify(vim.inspect(v), vim.log.levels.INFO, { title = "Debug Output" })
  end
end

require("dinz-globals.string-metadata")
require("dinz-globals.table-metadata")
