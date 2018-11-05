local lexer = require("lexer")
local filename = (...)
function love.load()
	love.graphics.setFont(love.graphics.newFont(11))
	parsed = {}
	fontheight = love.graphics.getFont():getHeight()

	local colors = {keyword = {0,0,1}, string = {0.5,0.5,0.5}, comment = {0,0.5,0},
		number = {1,0.5,0} , iden = {0,0,0}, default = {0,0,0.5}, line={1,0,0}}

	local contents = love.filesystem.read(filename, 4096)
	if not contents then
		contents = "error loading file" .. filename
		return
	end
	
	maxheight=0							--this should help us in the scrolling thingy
	for t in contents:gfind("\n") do
		maxheight=maxheight+fontheight		
	end
	
	contents = contents:gsub("\r", "")
	for t,v in lexer.lua(contents, {}, {}) do
		table.insert(parsed, colors[t] or colors["default"])
		table.insert(parsed, v)
	end

end
offy=0
function love.draw()
	love.graphics.translate(0,offy)
	love.graphics.setBackgroundColor({1, 1, 1})
	love.graphics.print(parsed, 10, 20)
end

function love.wheelmoved(_,y)
	y=y*15
	height=love.graphics.getHeight()
	if maxheight > height then									--scrolling up
		if y>0 and offy<0 then
			offy=offy+y
		elseif y<0 and height - offy - 40< maxheight then		--scrolling down
			offy=offy+y
		end
		if -offy > maxheight then offy=-maxheight end
		if offy > 0 then offy=0 end
	end
end
