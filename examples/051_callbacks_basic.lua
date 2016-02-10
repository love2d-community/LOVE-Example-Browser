-- Example: Basic callbacks

function love.load()
    love.graphics.setFont(love.graphics.newFont(11))
end

elapsed = 0

-- Update: Called each frame. Update the
-- state of your game here.
function love.update(dt)
    elapsed = elapsed + dt
end

-- Draw: Called each frame. The game
-- should be drawn in this functions.
function love.draw()
    love.graphics.print("Elapsed time: " .. elapsed, 100, 100)
end

