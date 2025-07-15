local tokyoNight = {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "night",
    on_highlights = function(hl, c)
      local listBgColorValue = table.apply({
        c.bg,
        c.bg_dark,
      })
      local mapIdxBgColorValue = listBgColorValue:toMapIndex()

      if true then
        for _, v in pairs(hl) do
          local colorConvert = mapIdxBgColorValue[v.bg]
          if colorConvert ~= nil then
            if type(colorConvert) == "number" then
              colorConvert = "NONE"
            end
            v.bg = colorConvert
          end
        end
      end

      hl.WinSeparator = {
        fg = c.border_highlight,
        bg = "NONE",
      }
    end,
  },
}

return tokyoNight
