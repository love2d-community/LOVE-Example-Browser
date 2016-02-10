-- Example: Sleeping

function love.update(dt)
    -- Sleeps 10ms after each udpate. By doing this,
    -- CPU time is made available for other processes,
    -- and your OS will love you for it.
    love.timer.sleep(0.01)
end
