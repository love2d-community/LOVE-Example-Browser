-- Example: Moving objects to a specific point
--[[Description:
Move an object to a target point, with acceleration, deacceleration (traction)
and a set top speed.
]]
require ("movements")
x, y = 400, 300
function love.load()	
	SPEED = 500
	ACCELERATION = 250
	DEACCELERATION = 0
	image = love.graphics.newImage("assets/love-ball.png")
	move=mega.movements.newMove(ACCELERATION,DEACCELERATION,SPEED,x,y)
end

function love.draw()
	love.graphics.draw(image, x, y)
	
	love.graphics.print("Left click to change the target.", 50, 50)
	love.graphics.print("Right click to stop the image from moving.", 50, 65)
	love.graphics.print("Middle click to make the image magically jump to your cursor.", 50, 80)
	
	if move:isFinished() == true then love.graphics.print("Have some LÖVE, will ya?", 50, 110) end
end

function love.update(dt)
	
	if love.mouse.isDown(1) then
		move:setTarget(love.mouse.getPosition())
	elseif love.mouse.isDown(3) then
		move:setPosition(love.mouse.getPosition())
	elseif love.mouse.isDown(2) then
		move:setTarget(nil)
	end
	
	move:advance(dt)
	x,y=move:getPosition()
end