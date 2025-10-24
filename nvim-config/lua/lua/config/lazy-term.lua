require("config.lazy-load")

require("lazy").setup({
  spec = {
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "flash",
        },
        {
          "<c-s>",
          mode = { "t" },
          function()
            print("Flash in terminal mode")
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-\\><c-n>", true, false, true), "t", true)
            vim.defer_fn(function()
              require("flash").jump()
            end, 0)
          end,
          desc = "flash",
        },
      },
    },
  },
})
vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
vim.keymap.set("n", "<Esc><Esc>", function()
  vim.cmd("nohlsearch")
end, { desc = "Clear search highlight" })
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.laststatus = 0
    vim.showmode = false
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
    vim.cmd("stopinsert")
    vim.cmd("q")
  end,
})

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
vim.keymap.set({ "n", "v" }, "<S-U>", "^")
vim.keymap.set({ "n", "v" }, "<S-I>", "$")
vim.cmd("term")
