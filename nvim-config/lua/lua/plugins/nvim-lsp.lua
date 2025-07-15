local opts = { servers = {}, setup = {} }

require("plugins.lsp-config.clangd")(opts)
require("plugins.lsp-config.cs")(opts)
require("plugins.lsp-config.json")(opts)
require("plugins.lsp-config.lua")(opts)
require("plugins.lsp-config.nushell")(opts)
require("plugins.lsp-config.rust")(opts)
require("plugins.lsp-config.tailwindcss")(opts)
require("plugins.lsp-config.ts")(opts)
require("plugins.lsp-config.slint")(opts)
return {
  "neovim/nvim-lspconfig",
  opts = opts,
}
