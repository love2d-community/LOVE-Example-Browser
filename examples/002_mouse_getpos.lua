-- Example: Getting the mouse position
--[[Description:
Get the mouse position with love.mouse.getPosition()
Display it with love.graphics.print
]]

function love.load()
    love.graphics.setFont(love.graphics.newFont(11))
end

function love.draw()
    -- Gets the x- and y-position of the mouse.
    local x, y = love.mouse.getPosition()
    -- Draws the position on screen.
    love.graphics.print("The mouse is at (" .. x .. "," .. y .. ")", 50, 50)
end
