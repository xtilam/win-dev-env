local macro = require("utils.macro")
local yazi = require("utils.yazi")
require("custom.macro-keymaps")

local km = vim.keymap
local conform = require("conform")

_G.km = km

km.set("", "<C-q>", function()
  Snacks.bufdelete()
end)

km.set("n", "<leader>co", "40i-<Esc>gc", { desc = "break line and comment" })

km.set("i", "<C-\\>", function()
  copilot.accept()
end, { desc = "Code completion" })

km.set({ "n", "i" }, "<A-S-F>", macro.initFn(" cf"), { desc = "Format code" })

km.set({ "n", "i" }, "<A-h>", function()
  Snacks.utils.term_nav("h")
end, { desc = "Switch to left window" })

km.set("n", "<C-a>", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select all" })

km.set("n", "<leader>bc", function()
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
  vim.fn.setreg("+", dir)
end, { desc = "Copy dir" })

km.set("", "<C-v>", '"0p')
km.set({ "i" }, "<C-h>", "<Left>")
km.set({ "i" }, "<C-l>", "<Right>")
km.set({ "i" }, "<C-w>", "<C-o>w")
km.set({ "i" }, "<C-e>", "<C-o>e")
km.set({ "i" }, "<C-b>", "<C-o>b")
km.set({ "n", "v" }, "<S-U>", "^")
km.set({ "n", "v" }, "<S-I>", "$")
km.set({ "n", "v" }, "<c-i>", yazi.toggle, { desc = "Toggle yazi" })

km.set({ "n", "i" }, "<F12>", function()
  vim.lsp.buf.hover()
end)

km.set({ "n", "v" }, "<m-s-J>", macro.initFn("<m-j>"), { desc = "Move down" })
km.set({ "n", "v" }, "<m-s-K>", macro.initFn("<m-k>"), { desc = "Move up" })
km.set("n", "<leader>c/", macro.initFn("o-<c-o>39i-<esc>gcc"), { desc = "Comment line and break" })

-- km.set("n", "gi", function()
--   vim.lsp.buf.code_action({
--     context = {
--       only = { "source" },
--       diagnostics = {},
--     },
--   })
-- end, { desc = "Source Actions" })
--
-- km.set("n", "ga", function()
--   vim.lsp.buf.code_action()
-- end, { desc = "Code Actions" })

-- km.set("n", "<C-m>", function()
--   dinz.showActions()
-- end, { desc = "Dinz Actions" })

-- vim.api.nvim_create_autocmd("TermEnter", {
--   callback = function()
--     local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left><Right>", true, false, true), "n", true)
--   end,
-- })

-- km.set("", "<C-d>", function()
--   vim.notify("No action bound to <c-d>", vim.log.levels.WARN)
-- end)
