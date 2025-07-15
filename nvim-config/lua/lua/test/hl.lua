local hlUtils = require("utils.find-hl")
local io = require("io")
local testUtils = require("utils.test-utils")

hlUtils.proxyHighlight()
vim.defer_fn(function()
  -- hlUtils.cacheListHL(vim.fn.stdpath("config") .. "/lua/test/hlResult.lua")
  -- local ignoreList = {
  --   -- SnacksDashboardNormal = true,
  -- }
  -- local hlList = table.apply(require("test.hlResult"))
  -- hlList = hlList:filter(function(hlName)
  --   return ignoreList[hlName] ~= true
  -- end)
  -- local hl = hlUtils.useSearchHL(hlList)
  -- local vimBG = hl.new()
  -- vimBG.binaryFilter("")
  -- vimBG.setHL({
  --   bg = "NONE",
  --   fg = "NONE",
  --   blend = 100,
  -- })
  vim.cmd("enew")
  -- testUtils.simulateKeys("ihello world<ESC>oconsole.log123<ESC>")
  testUtils.simulateKeys("g", "m")
  -- testUtils.simulateKeys("o", "n")
end, 200)
