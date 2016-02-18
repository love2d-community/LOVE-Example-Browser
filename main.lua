local examples, list
local magic = require "magic"
local List  = require "list"

local smallfont, bigfont, bigball

local function load_example(id)
  magic.current = nil
  local example = { name=examples[id], id=id }
  example.env = magic.make_env(example.name)
  example.chunk = love.filesystem.load("examples/" .. example.name .. "/main.lua")
  magic.current = example

  local status, err = magic.run(example.chunk)
  if status then
    magic.run(example.env.love.load)
  else
    print("unable to load " .. example.name, err)
  end
end

function love.load()
  smallfont = love.graphics.newFont(11)
  bigfont   = love.graphics.newFont(16)
  bigball   = love.graphics.newImage("assets/love-big-ball.png")

  list = List:new(20, 40, 300, 450)
  examples = love.filesystem.getDirectoryItems("examples")

  for id,name in ipairs(examples) do
    local data = love.filesystem.load("examples/" .. name .. "/data.lua")()
    list:add(data.title, id, data.description)
  end

  list.onclick = function(index, b)
    if b==1 then
     load_example(index)
     magic.load_callbacks()
    end
  end

  list:done()

end

function love.update(dt)
  list:update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(54, 172, 248)

  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(bigfont)
  love.graphics.print("Example Browser", 20, 20)
  love.graphics.print("Usage:", 20, 500)

  love.graphics.setFont(smallfont)
  love.graphics.print("Browse and click on the example you want to run.\n"
  .. "Right click if you want to view its code\n"
  .. "Press escape to return back to the main screen.", 20, 520)


  local hitem = list.items[list.hoveritem]
  if hitem then
    love.graphics.setFont(bigfont)
    love.graphics.print("File: " .. hitem.id, 350, 40)
    love.graphics.setFont(smallfont)
    love.graphics.print(hitem.tooltip, 380, 60)
  end

  love.graphics.draw(bigball, 800 - 128, 600 - 128)

  love.graphics.setFont(smallfont)
  list:draw()
end


function love.keypressed(key, ...)
  if key == "space" then
      load_example(1)
      magic.load_callbacks()
  else
    magic.run(magic.current.env.love.keypressed, key, ...)
  end
end

function love.keyreleased(k)
end

function love.mousepressed(x, y, b, it)
  list:mousepressed(x, y, b, it)
end

function love.mousereleased(x, y, b, it)
  list:mousereleased(x, y, b, it)
end

function love.mousemoved(x, y)
  list:mousemoved(x, y)
end

function love.wheelmoved(x, y)
  list:wheelmoved(x, y)
end