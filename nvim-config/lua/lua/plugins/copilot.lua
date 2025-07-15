return {
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local copilotMapStatus = {
        pending = {
          { fg = Snacks.util.color("Debug") },
          function()
            return Snacks.util.spinner()
          end,
        },
        ok = {
          { fg = Snacks.util.color("Normal") },
          function()
            return ""
          end,
        },
        err = {
          { fg = Snacks.util.color("Error") },
          function()
            return ""
          end,
        },
      }
      local copilotStatus = nil
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local status = require("copilot.api").status.data.status
          copilotStatus = (status == "InProgress" and "pending") or (status == "Warning" and "err") or "ok"
          return "[" .. copilotMapStatus[copilotStatus][2]() .. "()]"
        end,
        cond = function()
          local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
          return #clients > 0
        end,
        color = function()
          return copilotMapStatus[copilotStatus or "ok"][1]
        end,
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      enabled = true,
      suggestion = {
        enabled = true,
        auto_trigger = true,
        trigger_on_accept = true,
        debounce = 25,
        keymap = {
          accept = "<C-t>",
          next = "<C-Left>",
          prev = "<C-Right>",
          dismiss = "<C-\\>",
        },
      },
      panel = { enabled = true },
    },
  },
}
