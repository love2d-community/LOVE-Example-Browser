-- Example: Create and use an Animation
require("animation")

function newImagePO2(filename)
	local source = love.image.newImageData(filename)
	local w, h = source:getWidth(), source:getHeight()

	-- Find closest power-of-two.
	local wp = math.pow(2, math.ceil(math.log(w)/math.log(2)))
	local hp = math.pow(2, math.ceil(math.log(h)/math.log(2)))

	-- Only pad if needed:
	if wp ~= w or hp ~= h then
	local padded = love.image.newImageData(wp, hp)
	padded:paste(source, 0, 0)
	return love.graphics.newImage(padded)
	end

	return love.graphics.newImage(source)
end

function love.load()
	-- Set a lovely pink background color.
	love.graphics.setBackgroundColor(0.96, 0.77, 0.87)
	
	-- Load the source of the animation.
	img = newImagePO2("assets/anim-boogie.png")
	
	-- Create an animation with a frame size of 32x32 and
	-- 0.1s delay betwen each frame.
	animation1 = newAnimation(img, 32, 32, 0.1, 6)
end

function love.update(dt)
	-- The animation must be updated so it 
	-- knows when to change frames.
	animation1:update(dt)
end

function love.draw()
	-- Draw the animation the center of the screen.
	animation1:draw(400, 300, 0, 1, 1)
end
