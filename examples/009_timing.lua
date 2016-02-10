-- Example: Timing code

function love.load()
    -- Get time before the code to be timed.
    t_start = love.timer.getTime()
    
    -- Load 10 fonts.
    for i=13,22 do
        local f = love.graphics.newFont(i)
        love.graphics.setFont(f)
    end
    
    -- Get time after.
    t_end = love.timer.getTime()
    
end

function love.draw()
    love.graphics.print("Spent " .. (t_end-t_start) .. " seconds loading 10 fonts.", 50, 50)
end
