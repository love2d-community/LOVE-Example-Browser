-- Example: Setting the mouse position

function love.load()
   love.graphics.setFont(love.graphics.newFont(11))
end

function love.draw()
    love.graphics.print("Press a key to move the mouse to a random point", 50, 50)
end

-- Press a key to move the mouse to
-- some random point.
function love.keypressed(k)
    local x, y = math.random(0,800), math.random(0,600)
    love.mouse.setPosition(x, y)
end
