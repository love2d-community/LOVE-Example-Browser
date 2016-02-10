-- Example: Move an image along cursor

function love.load()
	-- Load the "cursor"
	image = love.graphics.newImage("assets/love-ball.png")

    -- Hide the default mouse.
    love.mouse.setVisible(false)
end

function love.draw()
    -- Draw the "cursor" at the mouse position.
    love.graphics.draw(image, love.mouse.getX(), love.mouse.getY())
end

