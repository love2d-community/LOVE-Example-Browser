local examples
local function run(func, ...)
  if not func then
    return false, "no func"
  end
  if not current then
    return false, "no example loaded"
  end
  return pcall( setfenv(func, current.env), ... )
end

local function make_env(example_name)
  local nocopy = {
    load = love, update = love, draw = love,
    keypessed = love, keyreleased = love, mousepressed = love, mousereleased = love, mousemoved = love, mousefocus = love,
    wheelmoved = love, touchmoved = love, touchpressed = love, touchreleased = love, textinput = love, textedited = love,
    filedropped = love, directorydropped = love,
    visible = love, resize = love
  }

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

local function load_example(id)
  current = nil
  local example = { name=examples[id], id=id }
  example.env = make_env(example.name)
  example.chunk = love.filesystem.load("examples/" .. example.name .. "/main.lua")
  current = example

  local status, err = run(example.chunk)
  if status then
    run(example.env.love.load)
  else
    print("unable to load " .. example.name, err)
  end
end

function love.load()
  examples = love.filesystem.getDirectoryItems("examples")
  load_example(next(examples))
end

for i, cb in ipairs{
  "update", "draw",
  "keyreleased", "mousepressed", "mousereleased", "mousemoved", "mousefocus",
  "wheelmoved","touchmoved", "touchpressed", "touchreleased", "textinput", "textedited",
  "filedropped", "directorydropped",
  "visible", "resize"
} do
  love[cb] = function(...)
    run(current.env.love[cb], ...)
  end
end

function love.keypressed(key, ...)
  if key == "space" then
    if examples[current.id + 1] then
      load_example(current.id + 1)
    else
      load_example(1)
    end
  else
    run(current.env.love.keypressed, key, ...)
  end
end

return make_env
