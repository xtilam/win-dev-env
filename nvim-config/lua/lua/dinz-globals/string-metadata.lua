function string.split(str, sep)
  local result = {}
  if sep == nil or sep == "" then
    for part in string.gmatch(str, "([^%s])") do
      table.insert(result, part)
    end
  else
    for part in string.gmatch(str, "([^" .. sep .. "]+)") do
      table.insert(result, part)
    end
  end
  return result
end
