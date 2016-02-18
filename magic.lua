--do not read. It will make your brain hurt. go read one of our beautiful examples instead.
local magic = {}

magic.examples = love.filesystem.getDirectoryItems("examples")

for id, name in ipairs(magic.examples) do
  local ok, data = pcall(love.filesystem.load("examples/" .. name .. "/data.lua"))
  if not ok then
    print("error loading data.lua for " .. name .. ": " .. data)
    data = nil
  end
  data = data or {}
  data.id, data.name = id, name
  magic.examples[id] = data
end

function magic.load_example(id)
  local example = magic.examples[id]

  if not example.chunk then
    example.chunk = love.filesystem.load("examples/" .. example.name .. "/main.lua")
  end

  example.env = magic.make_env(example.name)
  magic.current = example

  local status, err = magic.run(example.chunk)
  if status then
    magic.run(example.env.love.load)
  else
    magic.current = nil
    print("unable to load " .. example.name, err)
    return false
  end
  return true
end

function magic.unload_example()
  magic.current = nil
end

function magic.run(func, ...)
  if not func then
    return false, "no func"
  end
  if not magic.current then
    return false, "no example loaded"
  end
  return pcall( setfenv(func, magic.current.env), ... )
end

function magic.make_env(example_name) --creates an environment that has all the globals of the main environment except for love callbacks.
  local nocopy = {
    load = love, update = love, draw = love
  }

  for k,v in pairs(love.handlers) do --loops through all the current love event callbacks. 
    nocopy[k] = love
  end

  local function autodeepcopy(orig)
    return {__index = function(tbl, key)
      local val = orig[key]

      if nocopy[key] == orig then
        val = nil
      end

      if type(val) == "table" then
        val = setmetatable({}, autodeepcopy(orig[key]))
      end

      tbl[key] = val
      return val
    end}
  end

  local ENV = setmetatable({}, autodeepcopy(_G))

  ENV.require = function(mod)
    return require("examples." .. example_name .. "." .. mod)
  end

  return ENV
end

function magic.hook_callbacks()
  local callbacks = {"update"}
  for callback,_ in pairs(love.handlers) do
    if callback ~= "keypressed" then
      table.insert(callbacks, callback)
    end
  end

  for i, callback in ipairs(callbacks) do
    local orig = love[callback] or function () end
    love[callback] = function(...)
      if magic.current then
        magic.run(magic.current.env.love[callback], ...)
      else
        orig(...)
      end
    end
  end

  for i, callback in ipairs{"draw", "keypressed"} do -- these need to run always
    local orig = love[callback] or function () end
    love[callback] = function(...)
      if magic.current then
        magic.run(magic.current.env.love[callback], ...)
      end
      orig(...)
    end
  end
end

return magic
