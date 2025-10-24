local cwd = vim.fn.getcwd()
local distro = "Debian"

local distroMount = {
  Debian = "T:",
}

local wslPathBegin = "\\\\wsl.localhost"

if cwd:sub(1, #wslPathBegin) ~= wslPathBegin then
  return true
end

local distro = cwd:sub(#wslPathBegin + 2):match("^[^\\]+")
local mountDrive = distroMount[distro]
if not mountDrive then
  vim.notify("No mount drive found for distro: " .. distro, vim.log.levels.ERR)
  return false
end

winPath = mountDrive .. cwd:sub(#wslPathBegin + 2 + #distro)
vim.cmd("cd " .. winPath)

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*",
  callback = function(ev)
    local path = ev.file
    dd(ev)
    -- ví dụ: redirect path ảo sang path thật
    -- if path:match("^/virtual/") then
    --   local real = path:gsub("^/virtual/", "/home/may/projects/")
    --   vim.cmd("silent edit " .. vim.fn.fnameescape(real))
    -- end
  end,
})

return false
