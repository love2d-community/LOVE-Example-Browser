-- Example: Mini Physics
-- Updated 0.8.0 by Bartoleo

function love.load()

    love.graphics.setFont(love.graphics.newFont(11))

    -- One meter is 32px in physics engine
	love.physics.setMeter( 32 )

	-- Create a world with standard gravity
	world = love.physics.newWorld(0, 9.81*32, true)

	-- Create the ground body at (0, 0) static
	ground = love.physics.newBody(world, 0, 0, "static")
	
	-- Create the ground shape at (400,500) with size (600,10).
	ground_shape = love.physics.newRectangleShape( 400, 500, 600, 10)

	-- Create fixture between body and shape
	ground_fixture = love.physics.newFixture( ground, ground_shape)

	-- Load the image of the ball.
	ball = love.graphics.newImage("assets/love-ball.png")

	-- Create a Body for the circle
	body = love.physics.newBody(world, 400, 200, "dynamic")
	
	-- Attatch a shape to the body.
	circle_shape = love.physics.newCircleShape( 0,0,32)
	
    -- Create fixture between body and shape
    fixture = love.physics.newFixture( body, circle_shape)

	-- Calculate the mass of the body based on attatched shapes.
	-- This gives realistic simulations.
	body:setMassData(circle_shape:computeMass( 1 ))

end

function love.update(dt)
	-- Update the world.
	world:update(dt)
end

function love.draw()
	-- Draws the ground.
	love.graphics.polygon("line", ground:getWorldPoints(ground_shape:getPoints()))

	-- Draw the circle.
	love.graphics.draw(ball,body:getX(), body:getY(), body:getAngle(),1,1,32,32)

	-- Instructions
	love.graphics.print("space: Apply a random impulse",5,5)
end

function love.keypressed(k)
	if k == "space" then
		-- Apply a random impulse
		body:applyLinearImpulse(150-math.random(0, 300),-math.random(0, 1500))
	end
end
