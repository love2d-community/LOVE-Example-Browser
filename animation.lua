--[[
Copyright (c) 2009 Bart Bes

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]

local anim_mt = {}
anim_mt.__index = anim_mt

function newAnimation(image, fw, fh, delay, frames)
	local a = {}
	a.img = image
	a.frames = {}
	a.delays = {}
	a.timer = 0
	a.position = 1
	a.fw = fw
	a.fh = fh
	a.playing = true
	a.speed = 1
	a.mode = 1
	a.direction = 1
	local imgw = image:getWidth()
	local imgh = image:getHeight()
	if frames == 0 then
		frames = imgw / fw * imgh / fh
	end
	local rowsize = imgw/fw
	for i = 1, frames do
		local row = math.floor(i/rowsize)
		local column = i%rowsize
		local frame = love.graphics.newQuad(column*fw, row*fh, fw, fh, imgw, imgh)
		table.insert(a.frames, frame)
		table.insert(a.delays, delay)
	end
	return setmetatable(a, anim_mt)
end

function anim_mt:update(dt)
	if not self.playing then return end
	self.timer = self.timer + dt * self.speed
	if self.timer > self.delays[self.position] then
		self.timer = self.timer - self.delays[self.position]
		self.position = self.position + 1 * self.direction
		if self.position > #self.frames then
			if self.mode == 1 then
				self.position = 1
			elseif self.mode == 2 then
				self.position = self.position - 1
				self:stop()
			elseif self.mode == 3 then
				self.direction = -1
				self.position = self.position - 1
			end
		elseif self.position < 1 and self.mode == 3 then
			self.direction = 1
			self.position = self.position + 1
		end
	end
end

function anim_mt:draw(x, y, angle, sx, sy)
	love.graphics.draw(self.img, self.frames[self.position], x, y, angle, sx, sy)
end

function anim_mt:addFrame(x, y, w, h, delay)
	local frame = love.graphics.newQuad(x, y, w, h, a.img:getWidth(), a.img:getHeight())
	table.insert(self.frames, frame)
	table.insert(self.delays, delay)
end

function anim_mt:play()
	self.playing = true
end

function anim_mt:stop()
	self.playing = false
end

function anim_mt:reset()
	self:seek(0)
end

function anim_mt:seek(frame)
	self.position = frame
	self.timer = 0
end

function anim_mt:getCurrentFrame()
	return self.position
end

function anim_mt:getSize()
	return #self.frames
end

function anim_mt:setDelay(frame, delay)
	self.delays[frame] = delay
end

function anim_mt:setSpeed(speed)
	self.speed = speed
end

function anim_mt:getWidth()
	return self.frames[self.position]:getWidth()
end

function anim_mt:getHeight()
	return self.frames[self.position]:getHeight()
end

function anim_mt:setMode(mode)
	if mode == "loop" then
		self.mode = 1
	elseif mode == "once" then
		self.mode = 2
	elseif mode == "bounce" then
		self.mode = 3
	end
end

if Animations_legacy_support then
	love.graphics.newAnimation = newAnimation
	local oldLGDraw = love.graphics.draw
	function love.graphics.draw(item, ...)
		if type(item) == "table" and item.draw then
			item:draw(...)
		else
			oldLGDraw(item, ...)
		end
	end
end
