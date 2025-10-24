local macro = require("utils.macro")

vim.defer_fn(function()
  macro.testStringMacro(" e:edit ./config/config.nu<cr><tab>")
end, 500)
