Vault = {}
Vault.file = 'data'
Vault.fileData = {}

-- loads the data from the data file
-- returns the data
function Vault.load(file)
  file = file or Vault.file
  
  if love.filesystem.exists(file) then
    local data = love.filesystem.read(file)
    Vault.fileData[file] = loadstring('return ' .. data)()
    return Vault.fileData[file]
  else
    Vault.fileData[file] = {}
    return nil -- failure signal
  end
end

-- gets the data from the data, however it caches it,
-- and doesn't reload it every time
-- returns the data
function Vault.data(file)
  file = file or Vault.file
  
  if not Vault.fileData[file] then
    return Vault.load(file)
  else
    return Vault.fileData[file]
  end
end

function Vault.get(key, file)
  file = file or Vault.file
  
  if not Vault.fileData[file] then
    Vault.load(file)
  end
  
  return Vault.fileData[file][key]
end

function Vault.set(key, value, file)
  file = file or Vault.file
  
  if not Vault.fileData[file] then
    Vault.load(file)
  end
  
  Vault.fileData[file][key] = value
end

function Vault.save(data, file)
  file = file or Vault.file
  if type(data) == 'string' then file = data end
  
  if type(data) == 'table' then
    Vault.fileData[file] = data
  end
  
  return love.filesystem.write(file, Vault._getString(Vault.fileData[file]))
end

-- this allows for Vault['key']
function Vault.__index(_, key)
  return Vault.get(key)
end

-- this allows for Vault['key'] = value
function Vault.__newindex(_, key, value)
  return Vault.set(key, value)
end

function Vault._getTableString(t)
  local ret = '{'
  
  for k, v in pairs(t) do
    ret = string.format('%s[%s] = %s,', ret, Vault._getString(k), Vault._getString(v))
  end
  
  return ret .. '}'
end

function Vault._getString(value)
  local t = type(value)
  
  if t == 'nil' then
    return 'nil'
  elseif t == 'number' then
    return tostring(value)
  elseif t == 'string' then
    return '"' .. value .. '"'
  elseif t == 'boolean' then
    return value == true and 'true' or 'false'
  elseif t == 'table' then
    return Vault._getTableString(value)
  else
    -- is there a way to do userdata?
    error('Unable to save type: ' + t)
  end
end

setmetatable(Vault, Vault)
