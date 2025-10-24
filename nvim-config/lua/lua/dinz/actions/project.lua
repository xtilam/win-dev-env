local dinz = require("dinz.dinz")

local cacheDir = vim.fn.stdpath("data") .. "/cache"
local projectPath = cacheDir .. "/project.lua"

local function writeProject(listProject)
  if vim.fn.isdirectory(cacheDir) == 0 then
    vim.notify("Creating cache directory: " .. cacheDir)
    vim.fn.mkdir(cacheDir, "p")
  end
  local file = io.open(projectPath, "w")
  if not file then
    print("Error: Could not open project file for writing.")
    return
  end

  file:write("return {\n")
  for _, projectDir in ipairs(listProject) do
    projectDir = vim.fn.fnamemodify(projectDir, ":p:h")
    file:write(vim.inspect(projectDir) .. ",\n")
  end
  file:write("}\n")
  file:close()
end

dinz.addAction({
  name = "project",
  desc = "Open Project",
  callback = function()
    local project = dofile(projectPath)
    table.apply(project)
    vim.ui.select(
      project:map(function(dir)
        local name = vim.fn.fnamemodify(dir, ":t")
        local parentDir = vim.fn.fnamemodify(dir, ":h")
        return name .. " (" .. parentDir .. ")"
      end),
      {
        prompt = "Select a project:",
        unselected = true,
      },
      function(_, choiceIdx)
        if choiceIdx == nil then
          return
        end
        local projectDir = project[choiceIdx]
        vim.cmd("cd " .. projectDir)
      end
    )
  end,
})
dinz.addAction({
  name = "removeProject",
  desc = "Remove Project",
  callback = function()
    local listProject = table.apply(dofile(projectPath))
    vim.ui.select(
      listProject:map(function(dir)
        local name = vim.fn.fnamemodify(dir, ":t")
        local parentDir = vim.fn.fnamemodify(dir, ":h")
        return name .. " (" .. parentDir .. ")"
      end),
      {
        prompt = "Select a project to remove:",
        unselected = true,
      },
      function(_, choiceIdx)
        if choiceIdx == nil then
          return
        end
        local projectDir = listProject[choiceIdx]
        table.remove(listProject, choiceIdx)
        writeProject(listProject)
        vim.notify("Project removed: " .. projectDir)
      end
    )
  end,
})
dinz.addAction({
  name = "addProject",
  desc = "Add Project",
  callback = function()
    local projectDir = vim.fn.input("Enter project directory: ")
    if vim.fn.isdirectory(projectDir) == 0 then
      vim.notify("Invalid directory: " .. projectDir, vim.log.levels.ERROR)
      return
    end
    local listProject = table.apply(dofile(projectPath))
    listProject:insert(projectDir)
    writeProject(listProject)
    vim.notify("Project added: " .. projectDir)
  end,
})
