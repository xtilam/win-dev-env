local module = {}
local yaziTerm = nil
local macro = require("utils.macro")

function init()
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function(args)
      if not yaziTerm or yaziTerm.closed then
        return
      end
      module.setShow(false)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    callback = function(args)
      if not yaziTerm then
        return
      end
      module.setShow(false)
      vim.cmd("buffer " .. args.buf)
    end,
  })
end

function initYaziTerm()
  yaziTerm = Snacks.win({
    width = 0.8,
    height = 0.8,
    title = "Yazi",
    border = "rounded",
    on_win = function(self)
      if self.is_open_yazi then
        vim.cmd("startinsert!")
        return
      end
      self.is_open_yazi = true
      vim.api.nvim_create_autocmd("TermOpen", {
        buffer = self.buf,
        once = true,
        callback = function()
          isOpenTerm = true
          local hk = "<tab>"
          vim.keymap.set("t", hk, function()
            self:hide()
          end, { buffer = self.buf })
          vim.cmd("startinsert!")
        end,
      })
      vim.fn.termopen({ "yazi" }, {
        env = {
          EDITOR = "nvr",
        },
        on_exit = function()
          self:close()
          if self == yaziTerm then
            yaziTerm = nil
          end
        end,
      })
    end,
  })
end
function module.setShow(isShow)
  if isShow or isShow == nil then
    if yaziTerm then
      yaziTerm:show()
      return
    end
    initYaziTerm()
    return
  else
    if yaziTerm then
      yaziTerm:hide()
    end
  end
end

function module.toggle()
  if yaziTerm then
    yaziTerm:toggle()
    return
  end
  initYaziTerm()
end

init()
return module
