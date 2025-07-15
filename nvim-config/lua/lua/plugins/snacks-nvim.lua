return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  lazy = false,
  opts = {
    styles = {
      terminal = {
        position = "float",
        width = 0,
        height = 0,
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
      end,
    })
  end,
}
