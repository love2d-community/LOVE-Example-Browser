-- Example: Keyboard callbacks

function love.load()
    love.graphics.setFont(love.graphics.newFont(11))
end

-- Keypressed: Called whenever a key was pressed.
function love.keypressed(key)
	-- I don't want to register spaces.
	if key ~= "space" then
		lastkey = key .. " pressed"
	end
end

-- Keyreleased: Called whenever a key was released.
function love.keyreleased(key)
	-- I don't want to register spaces.
	if key ~= "space" then
		lastkey = key .. " released"
	end
end


-- Load a font and set the text variable.
function love.load()
	lastkey = "nothing"
end

-- Output the last mouse button which was pressed/released.
function love.draw()
	love.graphics.print("Last key: " .. lastkey, 100, 100)
end
