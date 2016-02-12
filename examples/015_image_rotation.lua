-- Example: Rotating images

angle = 0

function love.load()
    image = love.graphics.newImage("assets/love-ball.png")
end

function love.update(dt)
    angle = (angle + dt) % (2 * math.pi)
    x, y = 400 + math.cos(angle)*100, 300 + math.sin(angle)*100
end

function love.draw()
    love.graphics.draw(image, x, y,angle)
end
