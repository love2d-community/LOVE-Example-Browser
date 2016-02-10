local lexer = require("lexer")
local filename = (...)

function love.load()
	love.graphics.setFont(love.graphics.newFont(11))
	parsed = {}
	fontheight = love.graphics.getFont():getHeight()

	local colors = {keyword = {250,175,200}, string = {255,255,100}, comment = {175,175,175},
		number = {50,50,255} , iden = {255,255,255}, default = {250,175,200}}

	local contents = love.filesystem.read(filename, 4096)
	if not contents then
		contents = "error loading file" .. filename
		return
	end

	contents = contents:gsub("\r", "")
	for t,v in lexer.lua(contents, {}, {}) do
		if colors[t] ~= nil then table.insert(parsed, colors[t]) table.insert(parsed, v)
		else table.insert(parsed, colors["default"]) table.insert(parsed, v)
		--table.insert(parsed, t..":"..v..", ")
		end
	end

end

function love.draw()
	love.graphics.setBackgroundColor({72, 131, 168})
	love.graphics.print(parsed, 10, 20)
end
