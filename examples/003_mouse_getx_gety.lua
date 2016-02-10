-- Example: Getting the x or y position of the mouse
--[[Description:
Get the mouse position x with love.mouse.getX()
Get the mouse position y with love.mouse.getY()
Display it with love.graphics.print

P.S. I don't see how this is any different from 0002
P.S. I don't see how this is any different from 0002
P.S. I don't see how this is any diffe
Description character limit is löw
]]

function love.load()
    love.graphics.setFont(love.graphics.newFont(11))
end

function love.draw()
    -- Gets the x- and y-position of the mouse.
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    -- Draws the position on screen.
    love.graphics.print("The mouse is at (" .. x .. "," .. y .. ")", 50, 50)
end
