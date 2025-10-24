-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.syntax = "on"
vim.opt.mouse = "a" -- bật chuột cho tất cả mode

-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim.g.clipboard = {
--   name = "win-clipboard",
--   copy = {
--     ["+"] = "clip.exe",
--     ["*"] = "clip.exe",
--   },
--   paste = {
--     ["+"] = "powershell.exe -c Get-Clipboard",
--     ["*"] = "powershell.exe -c Get-Clipboard",
--   },
--   cache_enabled = 0,
-- }
