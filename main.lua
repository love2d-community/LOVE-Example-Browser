local examples, list
local magic = require "magic"
local List  = require "list"

local smallfont, bigfont, bigball

function love.load()
  magic.hook_callbacks()

  smallfont = love.graphics.newFont(11)
  bigfont   = love.graphics.newFont(16)
  bigball   = love.graphics.newImage("assets/love-big-ball.png")

  list = List:new(20, 40, 300, 450)

  for id, example in ipairs(magic.examples) do
    list:add(example.title, id, example.description)
  end

  list.onclick = function(index, b)
    if b == 1 then
      magic.load_example(index)
    end
  end

  list:done()
end

function love.update(dt)
  list:update(dt)
end

function love.draw()
  if not magic.current then
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
  else
    love.graphics.setFont(smallfont)
    love.graphics.print("ESC to return to menu\n"
    .. "SPACE to cycle throught examples\n", 20, 560)
  end
end


function love.keypressed(key, ...)
  if key == "space" and magic.current then
    magic.load_example((magic.current.id % #magic.examples) + 1)
  elseif key == "escape" then
    magic.unload_example()
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
