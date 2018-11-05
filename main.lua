--
-- EXF: Example Framework
--
-- This should make examples easier and more enjoyable to use.
-- All examples in one application! Yaay!
--
-- Updated by Dresenpai

exf = {}

local List = require("list")
function love.load()
	exf.list = List:new(20, 40, 300, 450)
	exf.smallfont = love.graphics.newFont(11)
	exf.bigfont = love.graphics.newFont(16)

	exf.bigball = love.graphics.newImage("assets/love-big-ball.png")

	-- Find available demos.
	local files =  love.filesystem.getDirectoryItems("examples")
	local file, contents, title, info, id
	local s, e
	for i, v in ipairs(files) do
		print(v)
		--s, e, id = string.find(v, "e(%d%d%d%d)%.lua")
		--if id then
			file = love.filesystem.newFile("examples/" .. v, love.file_read)
			file:open("r")
			contents = file:read(1000)
			file:close(file)
			
			s, e, title = string.find(contents, "Example: ([%a%p ]-)[\r\n]")
			if not title then title = "Untitled" end
			
			s, e, info = string.find(contents, "Description:\r?\n?(.-)]]")
			if not info then info = "" end
			info = info:gsub("\r", "")
			
			exf.list:add(title, v, info)
		--end
	end

	exf.list.onclick = function(index, b)
		if b==1 then exf.start(index)
		elseif b==2 then exf.view(index) end
	end
	exf.list:done()
	exf.resume()
end

--[[
function love.update(dt) end
function love.draw() end
function love.keypressed(k) end
function love.keyreleased(k) end
function love.mousepressed(x, y, b, it) end
function love.mousereleased(x, y, b, it) end
function love.mousemoved(x, y, dx, dy) end
function love.wheelmoved(x, y) end
]]

function exf.empty() end
exf.callbacks = {"load", "update", "draw", "keypressed", "keyreleased",
	"mousepressed", "mousereleased", "mousemoved", "wheelmoved"}

--for i, v in ipairs(exf.callbacks) do love[v] = exf.empty end

function exf.update(dt)
    exf.list:update(dt)
end

function exf.draw()
	love.graphics.setBackgroundColor(0.21, 0.67, 0.97)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(exf.bigfont)
	love.graphics.print("Example Browser", 20, 20)
	love.graphics.print("Usage:", 20, 500)

	love.graphics.setFont(exf.smallfont)
	love.graphics.print("Browse and click on the example you want to run.\n"
	.. "Right click if you want to view its code\n"
	.. "Press escape to return back to the main screen.", 20, 520)


	local hitem = exf.list.items[exf.list.hoveritem]
	if hitem then
		love.graphics.setFont(exf.bigfont)
		love.graphics.print("File: " .. hitem.id, 350, 40)
		--love.graphics.print("Info:", 350, 60)
		love.graphics.setFont(exf.smallfont)
		love.graphics.print(hitem.tooltip, 380, 60)
	end

	love.graphics.draw(exf.bigball, 800 - 128, 600 - 128)

	love.graphics.setFont(exf.smallfont)
	exf.list:draw()
end

function exf.keypressed(k)
end

function exf.keyreleased(k)
end

function exf.mousepressed(x, y, b, it)
    exf.list:mousepressed(x, y, b, it)
end

function exf.mousereleased(x, y, b, it)
    exf.list:mousereleased(x, y, b, it)
end

function exf.mousemoved(x, y)
    exf.list:mousemoved(x, y)
end

function exf.wheelmoved(x, y)
    exf.list:wheelmoved(x, y)
end

function exf.intable(t, e)
    for k,v in ipairs(t) do
        if v == e then return true end
    end
    return false
end

function exf.run(file, title, ...)
	-- if not love.filesystem.exists(file) then
	if not love.filesystem.getInfo(file) then
		print("Could not load file .. " .. file)
		return
	end

	-- Clear all callbacks.
	for i, v in ipairs(exf.callbacks) do love[v] = exf.empty end

	love.filesystem.load(file)(...)
	exf.clear()

	love.window.setTitle(title)

	-- Redirect keypress
	local o_keypressed = love.keypressed
	love.keypressed = function(k)
		if k == "escape" then exf.resume() end
		o_keypressed(k)
	end
	love.load()
end

function exf.start(i)
	local item = exf.list.items[i]
	if item then
		exf.run("examples/" .. item.id, item.id .. " - " .. item.title)
	else
		print("Example ".. i .. " does not exist.")
	end
end

function exf.view(i)
	local item = exf.list.items[i]
	if item then
		exf.run("viewcode.lua", "Contents of " .. item.id .. " - " .. item.title, "examples/" .. item.id)
	else
		print("Example ".. i .. " does not exist.")
	end
end


function exf.clear()
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle("smooth")
	love.graphics.setBlendMode("alpha")
	love.mouse.setVisible(true)
end

function exf.resume()
	load = nil
	-- Reattach callbacks
	for i, v in ipairs(exf.callbacks) do love[v] = exf[v] end

	love.mouse.setVisible(true)
	love.mouse.setCursor()
	love.window.setTitle("LOVE Example Browser")

end





