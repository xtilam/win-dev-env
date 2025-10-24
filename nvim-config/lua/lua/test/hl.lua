-- local hlUtils = require("utils.find-hl")
-- local io = require("io")
local testUtils = require("utils.test-utils")
--
-- hlUtils.proxyHighlight()
-- vim.defer_fn(function()
--   -- hlUtils.cacheListHL(vim.fn.stdpath("config") .. "/lua/test/hlResult.lua")
--   -- local ignoreList = {
--   --   -- SnacksDashboardNormal = true,
--   -- }
--   -- local hlList = table.apply(require("test.hlResult"))
--   -- hlList = hlList:filter(function(hlName)
--   --   return ignoreList[hlName] ~= true
--   -- end)
--   -- local hl = hlUtils.useSearchHL(hlList)
--   -- local vimBG = hl.new()
--   -- vimBG.binaryFilter("")
--   -- vimBG.setHL({
--   --   bg = "NONE",
--   --   fg = "NONE",
--   --   blend = 100,
--   -- })
--   vim.cmd("enew")
--   -- testUtils.simulateKeys("ihello world<ESC>oconsole.log123<ESC>")
--   testUtils.simulateKeys("g", "m")
--   -- testUtils.simulateKeys("o", "n")
-- end, 200)
function testMacro(macro)
  local oldOMacro = vim.fn.getreg("o")
  vim.fn.setreg("o", macro)
  vim.cmd("normal! @o")
  vim.fn.setreg("o", oldOMacro)
end

function _G.showMacro()
  local macro = vim.fn.getreg("h")
  if macro then
    dd(macro)
  end
end

function nextTab()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local cur = vim.api.nvim_get_current_win()
  dd({ wins, cur, vim.api.nvim_buf_get_name(cur) })
  for i, w in ipairs(wins) do
    if w == cur then
      local next_win = wins[(i % #wins) - 2]
      dd(next_win)
      vim.api.nvim_set_current_win(next_win)
      break
    end
  end
end

vim.defer_fn(function()
  -- testMacro(" as")

  -- local cc = require("CopilotChat")
  -- local picker = Snacks.picker.files({
  --   cwd = cc.config.history_path,
  --   win = {
  --     input = {
  --       keys = {
  --         ["<Del>"] = { "del", mode = { "n", "i" } },
  --       },
  --     },
  --   },
  --
  --   actions = {
  --     del = function(picker, item)
  --       dd("Delete item: " .. item.name)
  --       vim.cmd("q")
  --     end,
  --     confirm = function(picker, item)
  --       -- vim.cmd("q")
  --       vim.cmd("q")
  --     end,
  --   },
  -- })
  --
  -- picker:action("toggle_preview")
  -- dd(picker)
  -- vim.defer_fn(function()
  --   testMacro("i\27?")
  -- end, 600)
end, 500)
