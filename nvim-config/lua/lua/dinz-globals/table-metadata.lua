function table.new()
  return table.apply({})
end

function table.map(list, map)
  local newList = table.new()
  for idx, value in ipairs(list) do
    newList:insert(map(value, idx))
  end
  return newList
end

function table.toMapIndex(list)
  local mapIdx = {}
  for idx, value in ipairs(list) do
    mapIdx[value] = idx
  end
  return mapIdx
end

function table.apply(list)
  setmetatable(list, { __index = table })
  return list
end

function table.filter(list, callbackFilter)
  local newList = table.new()
  for _, value in ipairs(list) do
    if callbackFilter(value) then
      newList:insert(value)
    end
  end
  return newList
end

function table.clone(list)
  local newList = table.new()
  for _, value in ipairs(list) do
    table.insert(newList, value)
  end
  return newList
end
