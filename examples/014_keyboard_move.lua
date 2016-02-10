-- Example: Moving stuff with the keyboard

x, y = 400, 300

function love.load()
    image = love.graphics.newImage("assets/love-ball.png")
end

function love.update(dt)
    if love.keyboard.isDown("left") then
	x = x - 100 * dt
    end
    if love.keyboard.isDown("right") then
	x = x + 100 * dt
    end
    if love.keyboard.isDown("up") then
	y = y - 100 * dt
    end
    if love.keyboard.isDown("down") then
	y = y + 100 * dt
    end
end

function love.draw()
    love.graphics.draw(image, x, y)
end


