return function(o)
  o.servers.nim_langserver = {
    cmd = { "nimlangserver" },
    filetypes = { "nim" },
    root_dir = function(bufnr, on_dir)
      local util = require("lspconfig.util")
      local fname = vim.api.nvim_buf_get_name(bufnr)
      on_dir(
        util.root_pattern("*.nimble")(fname) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
      )
    end,
  }
end
