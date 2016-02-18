--do not read. It will make your brain hurt. go read one of our beautiful examples instead.
local magic = {}

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

function magic.load_callbacks()
  local callbacks = {"draw","update"}
  for callback,v in pairs(love.handlers) do
    table.insert(callbacks,callback)
  end

  for i, callback in ipairs(callbacks) do
    love[callback] = function(...)
      magic.run(magic.current.env.love[callback], ...)
    end
  end
end

return magic