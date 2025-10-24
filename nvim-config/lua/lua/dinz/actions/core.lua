local dinz = require("dinz.dinz")
local oldChoice = nil

function dinz.addAction(opts)
  local name = opts.name
  local desc = opts.desc
  local callback = opts.callback

  if type(callback) ~= "function" then
    error("Callback must be a function")
  end
  if not desc then
    error("Description must be provided")
  end

  if name then
    dinz.actions[name] = callback
  end
  table.insert(dinz.actionsSelects, #dinz.actionsSelects + 1, desc)
  table.insert(dinz.actions, #dinz.actions + 1, callback)
end

function dinz.showActions()
  vim.ui.select(dinz.actionsSelects, {
    prompt = "Actions" .. (oldChoice == nil and ":" or " (" .. dinz.actionsSelects[oldChoice] .. "):"),
    unselected = true,
  }, function(choice, choiceIdx)
    if choiceIdx == nil then
      return
    elseif choiceIdx == 1 then
      if oldChoice == nil then
        return
      end
      choiceIdx = oldChoice
    end
    local action = dinz.actions[choiceIdx]
    oldChoice = choiceIdx
    action()
  end)
end

dinz.addAction({ name = "oldAction", desc = "(Default)", callback = function() end })
