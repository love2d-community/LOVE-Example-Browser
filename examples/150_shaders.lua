-- Example: Shaders
-- Author: janwerder

--[[Description:
Author: janwerder
Draw a desaturation shader with an image on a canvas
Move your mouse up and down to set the strength of the shader
]]
function love.load()
	--load a sample image
    image = love.graphics.newImage("assets/love-ball.png")

	-- Create a new canvas to draw the shader and the content on with the size of our window 
	local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
    canvas = love.graphics.newCanvas(sw, sh)

	--Declare our shader
	shader = love.graphics.newShader([[
		extern vec4 tint;
		extern number strength;
		vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _)
		{
			color = Texel(texture, tc);
			number luma = dot(vec3(0.299f, 0.587f, 0.114f), color.rgb);
			return mix(color, tint * luma, strength);
		}
	]])

	--Send an initial value for tint to the shader in the form of a table
    shader:send('tint', {1.0,1.0,1.0,1.0})    
end

function love.update()
	--Update the strength of the shader with the height of the mouse y position
	local x,y = love.mouse.getPosition()
	--"strength" is a variable in the shader itself, that's why we can update it here
	shader:send('strength', y/love.graphics.getHeight())
end

function love.draw()
	--Draw the image to canvas
	love.graphics.setCanvas(canvas)
		love.graphics.draw(image, 400, 300)
	love.graphics.setCanvas()

	--Now set the shader of the canvas to our shader and draw the canvas afterwars
	love.graphics.setShader(shader)
		love.graphics.draw(canvas,0,0)
	love.graphics.setShader()
end

