-- Example: Line Iterators
-- Updated 0.8.0 by Bartoleo
function love.load()

	-- Set the font.
	love.graphics.setFont(love.graphics.newFont(11))

	-- Store the lines in this table.
	lines = {}
	
	--get height of the current font and reduce by 3
	fontheight = love.graphics.getFont():getHeight() - 3
	
	-- Open the file main.lua and loop through the first
	-- 50 lines.
	for line in love.filesystem.lines("main.lua") do
		table.insert(lines, line)
		if #lines >= 50 then break end
	end

end

function love.draw()
	-- Draw the loaded lines.
	for i = 1,#lines do
		--love.graphics.print(string.format("%03i: ", i) .. lines[i], 50, 50+(i*10))
		-- use new colored printing in 0.10.0 instead
		love.graphics.print({{175,3*i,200}, string.format("%03i: ", i) , {255,3*i,175}, lines[i]}, 50, 50+(i*fontheight))
	end
end

