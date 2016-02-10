-- Example: Checking for pressed mouse buttons

function love.load()
   love.graphics.setFont(love.graphics.newFont(11))
end

function love.draw()
    -- Left mouse button.
    if love.mouse.isDown(1) then
        love.graphics.print("Left mouse button is down", 50, 50)
    end

    -- Right mouse button.
    if love.mouse.isDown(2) then
        love.graphics.print("Right mouse button is down", 50, 100)
    end

    -- Middle mouse button.
    if love.mouse.isDown(3) then
        love.graphics.print("Middle mouse button is down", 50, 75)
    end 
end
