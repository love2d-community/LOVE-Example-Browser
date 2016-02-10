-- Example: Firing objects towards mouse
--[[Description:
Uses basic physics formulas to determine each bullet position.
Auto removes off-screen bullets.
]]

function love.load()	
	SPEED = 250
	StartPos = {x=250, y=250, width=50, height=50}	--The starting point that the bullets are fired from, acts like the shooter.
	bullets={}										--The table that contains all bullets.
end

function love.draw()
	--Sets the color to red and draws the "bullets".
	love.graphics.setColor(255, 0, 0)
	
	--This loops the whole table to get every bullet. Consider v being the bullet.
	for i,v in pairs(bullets) do
		love.graphics.circle("fill", v.x, v.y, 4,4)
	end
	
	--Sets the color to white and draws the "player" and writes instructions.
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.print("Left click to fire towards the mouse.", 50, 50)
	love.graphics.rectangle("line", StartPos.x, StartPos.y, StartPos.width, StartPos.height)
end

function love.update(dt)
	
	if love.mouse.isDown(1) then
		--Sets the starting position of the bullet, this code makes the bullets start in the middle of the player.
		local startX = StartPos.x + StartPos.width / 2
		local startY = StartPos.y + StartPos.height / 2
		
		local targetX, targetY = love.mouse.getPosition()
	  
		--Basic maths and physics, calculates the angle so the code can calculate deltaX and deltaY later.
		local angle = math.atan2((targetY - startY), (targetX - startX))
		
		--Creates a new bullet and appends it to the table we created earlier.
		newbullet={x=startX,y=startY,angle=angle}
		table.insert(bullets,newbullet)
	end
	
	for i,v in pairs(bullets) do
		local Dx = SPEED * math.cos(v.angle)		--Physics: deltaX is the change in the x direction.
		local Dy = SPEED * math.sin(v.angle)
		v.x = v.x + (Dx * dt)
		v.y = v.y + (Dy * dt)
		
		--Cleanup code, removes bullets that exceeded the boundries:
		
		if v.x > love.graphics.getWidth() or
		   v.y > love.graphics.getHeight() or
		   v.x < 0 or
		   v.y < 0 then
			table.remove(bullets,i)
		end
	end
end