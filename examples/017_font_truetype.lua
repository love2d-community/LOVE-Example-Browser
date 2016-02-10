-- Example: Using a truetype font

function love.load()
	-- Create a new font with 32pt size and set it as default.
	local f = love.graphics.newFont("assets/Grundschrift-Normal.otf", 24)
	love.graphics.setFont(f)
end

text = [[
   Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna
aliqua. Ut enim ad minim veniam, quis nostrud exercitation
ullamco laboris nisi  ut aliquip ex ea commodo  consequat.
Duis aute irure dolor in  reprehenderit  in voluptate velit
esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
occaecat cupidatat non proident, sunt  in culpa qui officia
deserunt mollit anim id est laborum.
   Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna
aliqua. Ut enim ad minim veniam, quis nostrud exercitation
ullamco laboris nisi  ut aliquip ex ea commodo  consequat.
Duis aute irure dolor in  reprehenderit  in voluptate velit
esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
occaecat cupidatat non proident, sunt  in culpa qui officia
deserunt mollit anim id est laborum.
]]

function love.draw()
	-- Print the text
	love.graphics.print(text, 50, 50)
end

