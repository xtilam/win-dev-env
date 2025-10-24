return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  lazy = false,
  opts = {
    mappings = {
      ["<leader><space>"] = false,
      ["<C-n>"] = false,
    },
    dashboard = {
      enabled = false,
    },
    explorer = {
      enabled = false,
    },
    picker = {
      hidden = false,
      ignored = true,
      win = {
        input = {
          keys = {
            ["<c-l>"] = { "jump_preview", mode = { "n", "i" } },
          },
        },
      },
      actions = {
        jump_preview = function(picker)
          picker.preview.win:focus()
          vim.cmd("stopinsert")
        end,
      },
    },
    styles = {
      terminal = {
        position = "float",
        width = 0,
        height = 0,
      },
    },
  },
  keys = {},
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
        local km = vim.keymap

        km.set("", "<leader><space>", function()
          Snacks.picker.files()
        end, { desc = "Find files" })
        km.set("", "<leader>e", function()
          Snacks.explorer()
        end, { desc = "File Explorer" })
      end,
    })
  end,
}
