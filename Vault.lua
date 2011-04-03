Vault = {}
Vault.fileData = {}

-- Set this to change the default file
Vault.file = 'data'

local function _getBasicString(value)
  if t == 'number' or t == 'boolean' then
    return tostring(value)
  elseif t == 'string' then
    return '"' .. value .. '"'
  end
end

local function _getString(name, value, str, saved)
  local t = type(value)
  saved = saved or {}
  str = (str or '') .. name .. ' = '
  
  if t == 'number' or t == 'boolean' or t == 'string' then
    str = str .. _getBasicString(value)
  elseif t == 'table' then
    if saved[value] then -- have we already been through this?
      str = str .. saved[value]
    else
      saved[value] = name
      str = str .. '{}'
      
      for k, v in pairs(value) do
        local field = string.format('%s[%s]', name, _getBasicString(k))
        str = _getString(field, v, str, saved)
      end
    end
  else
    -- nil is more friendly than a scary error message :P
    str = str .. 'nil'
  end
  
  return str
end

-- Loads the data from the data file
-- returns the data, or nil on failure
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

-- Gets the data from the data file, however it caches it,
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

-- Gets a key from the data file. It will load the data if
-- this hasn't already been done.
-- returns the value of the key
function Vault.get(key, file)
  file = file or Vault.file
  
  if not Vault.fileData[file] then
    Vault.load(file)
  end
  
  return Vault.fileData[file][key]
end

-- Sets a key to the value specified. It will load the data
-- if this hasn't already been done.
function Vault.set(key, value, file)
  file = file or Vault.file
  
  if not Vault.fileData[file] then
    Vault.load(file)
  end
  
  Vault.fileData[file][key] = value
end

-- Writes the data out to the file. You can also pass in a
-- table as the complete set of data, instead of using
-- Vault.set.
-- returns a boolean indicating success
function Vault.save(data, file)
  file = file or Vault.file
  if type(data) == 'string' then file = data end
  
  if type(data) == 'table' then
    Vault.fileData[file] = data
  end
  
  return love.filesystem.write(file, _getString(Vault.fileData[file]))
end

-- this allows for Vault['key']
function __index(_, key)
  return Vault.get(key)
end

-- this allows for Vault['key'] = value
function __newindex(_, key, value)
  return Vault.set(key, value)
end

setmetatable(Vault, Vault)
