-- Example: Filler

angle = 0

function love.load()
    image = love.graphics.newImage("assets/love-ball.png")
end

function love.update(dt)
    angle = angle + dt
    x, y = 400 + math.cos(angle)*100, 300 + math.sin(angle)*100
end

function love.draw()
    local rot = angle*180/math.pi
    local sx = math.cos(angle)*3
    local sy = math.sin(angle)*2
    love.graphics.draw(image, x, y, rot, sx, sy, 32, 32)
end
