local km = vim.keymap
local macro = require("utils.macro")
local oldMacroTest = ""

local function testMacro()
  vim.ui.input({
    prompt = "Enter macro register: ",
    default = oldMacroTest,
    title = "Input your macro",
  }, function(input)
    local isValidMacro = macro.testStringMacro(stringMacro)
    if isValidMacro then
      oldMacroTest = input
      return
    end
    vim.notify("Invalid macro", vim.log.levels.ERROR)
  end)
end

local function registerTestMacro()
  vim.fn.setreg("h", macro.fromString(oldMacroTest))
end

km.set("n", "<leader>mt", testMacro, { desc = "Test macro" })
km.set("n", "<leader>mr", registerTestMacro, { desc = 'Register test macro to "H"' })
km.set("n", "<leader>md", macro.getMacro, { desc = 'Display macro "H"' })
