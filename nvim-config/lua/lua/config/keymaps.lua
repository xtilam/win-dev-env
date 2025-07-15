local km = vim.keymap
local conform = require("conform")
local dinz = require("dinz.dinz")

_G.km = km

km.set("", "<C-q>", function()
  Snacks.bufdelete()
end)
km.set("", "<C-p>", "<C-o><leader>aa")
km.set("i", "<C-\\>", function()
  copilot.accept()
end, { desc = "Code completion" })

km.set({ "n", "i" }, "<A-S-F>", function()
  conform.format({ lsp_fallback = true })
end, { desc = "Format code" })

km.set({ "n", "i" }, "<A-h>", function()
  Snacks.utils.term_nav("h")
end, { desc = "Switch to left window" })

km.set("n", "<C-a>", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select all" })

km.set({ "i" }, "<C-h>", "<Left>")
km.set({ "i" }, "<C-l>", "<Right>")
km.set({ "i" }, "<C-w>", "<C-o>w")
km.set({ "i" }, "<C-e>", "<C-o>e")
km.set({ "i" }, "<C-b>", "<C-o>b")
km.set({ "n", "v" }, "<S-U>", "^")
km.set({ "n", "v" }, "<S-I>", "$")
km.set({ "n", "i" }, "<F12>", function()
  vim.lsp.buf.hover()
end)

km.set("n", "gi", function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source" },
      diagnostics = {},
    },
  })
end, { desc = "Source Actions" })

km.set("n", "<C-m>", function()
  dinz.actions.testMacro()
end, { desc = "Dinz Actions" })

km.set("n", "ga", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Actions" })

km.set("n", "<C-Space>", function()
  vim.notify("No action bound to <c-Space>", vim.log.levels.WARN)
end)
