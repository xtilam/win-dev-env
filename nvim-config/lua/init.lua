vim.o.guifont = "Cascadia_Code_NF:h12" -- Đặt font và kích thước
vim.g.neovide_window_blurred = true
vim.g.neovide_opacity = 0.7

require("dinz-globals.globals")
require("dinz.apply-actions")
require("config.autocmds")

require(_G.__MODULE_INIT__ or "config.lazy")
