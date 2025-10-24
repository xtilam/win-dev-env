local o = {}

local mapKeys = { tab = "\t", esc = "\27", bs = "\128kb", del = "\27kD", cr = "\r", ll = " " }
local maxMapKeyLength = 0

local function init()
  for i = 1, 26 do
    local char = string.char(96 + i)
    mapKeys["m-" .. char] = "\128\252\b" .. char    
    mapKeys["c-" .. char] = string.char(i)
  end

  -- mapKeys["tab"] = mapKeys["c-i"]

  for k, _ in pairs(mapKeys) do
    if #k > maxMapKeyLength then
      maxMapKeyLength = #k
    end
  end
end

o.testMacro = function(macro)
  local oldMacro = vim.fn.getreg("o")
  vim.fn.setreg("o", macro)
  vim.cmd("normal! @o")
  vim.fn.setreg("o", oldMacro)
end
o.testStringMacro = function(stringMacro)
    local _, err = pcall(function()
      o.testMacro(o.fromString(stringMacro))
    end)
    return err and false or true
end
o.fromString = function(input)
  local listChar = {}
  local inputLength = #input
  local i = 0
  local autoReg = true

  if input:sub(1, 2) == '!!' then 
    i = 1
  end

  while i <= inputLength do
    i = i + 1
    local char = input:sub(i, i)
    if char == "<" then
      local charKey = ""
      for j = i + 1, math.min(inputLength, i + maxMapKeyLength + 1) do
        local subChar = input:sub(j, j):lower()
        if subChar == ">" then
          break
        end
        charKey = charKey .. subChar
      end

      if mapKeys[charKey] then
        char = mapKeys[charKey]
        i = i + #charKey + 1
      else
        goto continue
      end
    end

    listChar[#listChar + 1] = char
    ::continue::

  end
  local macro = table.concat(listChar, "")
  if autoReg then vim.fn.setreg("h", macro) end
  -- dd(macro)
  return macro
end

o.initFn = function(hk)
  local macro = o.fromString(hk)
  return function()
    -- dd(macro, hk)
    o.testMacro(macro)
  end
end

o.getMacro = function(macroKey)
  if macroKey == nil then
    macroKey = "h"
  end
  local macro = vim.fn.getreg(macroKey)
  -- dd(macro)
  return macro
end

init()

return o
