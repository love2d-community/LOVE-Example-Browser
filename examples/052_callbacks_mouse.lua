-- Example: Mouse callbacks

function love.load()
	love.graphics.setFont(love.graphics.newFont(11))
end

-- Mousepressed: Called whenever a mouse button was pressed,
-- passing the button and the x and y coordiante it was pressed at.
function love.mousepressed(x, y, button, istouch)
	-- Checks which button was pressed.
	local buttonname = ""
	if button == 1 then
		buttonname = "left"
	elseif button == 2 then
		buttonname = "right"
	elseif button == 3 then
		buttonname = "middle"
	else
		-- Some mice can have more buttons
		buttonname = "button" .. button
	end
	
	last = buttonname .. " pressed @ (" .. x .. "x" .. y .. ")"
end

-- Mousereleased: Called whenever a mouse button was released,
-- passing the button and the x and y coordiante it was released at.
function love.mousereleased(x, y, button, istouch)
	-- Checks which button was pressed.
	local buttonname = ""
	if button == 1 then
		buttonname = "left"
	elseif button == 2 then
		buttonname = "right"
	elseif button == 3 then
		buttonname = "middle"
	else
		-- Some mice can have more buttons
		buttonname = "button" .. button
	end
	
	last = buttonname .. " released @ (" .. x .. "x" .. y .. ")"
end


-- Wheelmoved: Called whenever the mouse wheel moved,
-- passing the x(horizontal) and y(vertical) wheel movement.
function love.wheelmoved( x, y )
	if y > 0 then
		lastw = "wheel moved up"
	elseif y < 0 then
		lastw = "wheel moved down"
	elseif x > 0 then
		lastw = "wheel moved right"
	elseif x < 0 then
		lastw = "wheel moved left"
	end
end

-- Load a font 
function love.load()
	last = "none"
	lastw = "none"
end

-- Output the last mouse button which was pressed/released.
function love.draw()
	love.graphics.print("Last mouse click: " .. last, 100, 75)
	love.graphics.print("Last wheel move: " .. lastw, 100, 100)
end
