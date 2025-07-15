local lib = {}
local mapHL = {}
local setHL = vim.api.nvim_set_hl
local print = vim.notify

lib.listHL = {}

function lib.proxyHighlight()
  vim.api.nvim_set_hl = function(...)
    local args = { ... }
    local name = args[2]
    local trueName = type(name) == "string" and name or name.name

    if mapHL[trueName] == nil then
      mapHL[trueName] = true
      table.insert(lib.listHL, trueName)
    end
    return setHL(unpack(args))
  end
end

function initSearchHL(listHL)
  local self = {}
  self.listHL = table.clone(listHL)
  self.beginIdx = 1
  self.endIdx = #self.listHL

  function self.binaryFilter(oldResult)
    local rs = string.split(oldResult)

    for i = 1, #rs do
      local isMatchBegin = tonumber(rs[i]) ~= 0
      local space = self.endIdx - self.beginIdx + 1
      if isMatchBegin then
        self.endIdx = self.endIdx - math.ceil(space / 2)
      else
        self.beginIdx = self.beginIdx + math.floor(space / 2)
      end
    end

    if self.beginIdx == self.endIdx then
      print("HLResult: " .. self.listHL[self.beginIdx])
    else
      print("Search Result: " .. self.beginIdx .. " - " .. self.endIdx)
    end

    return self
  end

  function self.getResults()
    local rs = table.new()
    for i = self.beginIdx, self.endIdx do
      rs:insert(listHL[i])
    end
    return rs
  end

  function self.copy()
    if self.beginIdx ~= self.endIdx then
      print("Cannot copy multiple highlights at once. Please narrow down your search.")
    else
      vim.fn.setreg("+", self.listHL[self.beginIdx])
      print("Copied: " .. self.listHL[self.beginIdx])
    end
    return self
  end
  function self.update()
    self.beginIdx = 1
    self.endIdx = #listHL
    return self
  end

  function self.setHL(opts)
    for i = self.beginIdx, self.endIdx do
      local hlName = listHL[i]
      setHL(0, hlName, opts)
    end
  end

  return self
end

function lib.useSearchHL(listHL)
  local self = {}
  function self.new()
    return initSearchHL(listHL)
  end
  return self
end

function lib.cacheListHL(filePath)
  local file = io.open(filePath, "w")
  if not file then
    vim.notify("Failed to open file for writing: " .. filePath, vim.log.levels.ERROR)
    return
  end
  local content = "return " .. vim.inspect(lib.listHL)
  file:write(content)
  file:close()
end

return lib
