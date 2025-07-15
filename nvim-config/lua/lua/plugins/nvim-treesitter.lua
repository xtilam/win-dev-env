return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  opts = {
    autotag = {
      enable = true,
      filetypes = {
        "html",
        "xml",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
      },
    },
  },
  config = function()
    require("nvim-treesitter.install").compilers = { "clang", "gcc" }
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "rust",
        "ron",
        "nu",
        "json5",
        "bash",
        "c",
        "diff",
        "html",
        "c_sharp",
        "ninja",
        "rst",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "cpp",
        "cmake",
      },
      -- sync_install = true,
      -- highlight = {
      --   enable = true, -- Kích hoạt highlighting
      --   additional_vim_regex_highlighting = false,
      -- },
      -- -- Cấu hình các compiler nếu cần thiết
      -- install = {
      --   -- Dùng curl thay vì git để tải parser
      --   prefer_git = false,
      -- },
      -- Đặt lựa chọn compiler cho nvim-treesitter
    })
  end,
}
