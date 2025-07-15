local dinz = require("dinz.dinz")

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
    prompt = "Actions",
    unselected = true,
  }, function(choice, choiceIdx)
    if not choiceIdx then
      return
    end
    local action = dinz.actions[choiceIdx]
    action()
  end)
end
