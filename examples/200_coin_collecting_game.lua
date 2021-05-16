-- Example: Coin Collecting Game
-- Author: R. Bassett Jr. (Tatwi)
--[[Descripton:
I made this as a performance test to see if I wanted to convert RocketTux 
from JavaScript (Phaser CE) to Love. It's an example of a simple game that 
can be built in a day.

Game Play:
- Collect all the coins before you run out of fuel for your rocket pack!
- Move with the arrow keys.
- Ascending and moving forward use more fuel than steady flight, while
  descending and moving backward (slowing down) use less fuel.

Changing the Difficulty:
Play with the levelLength, coinsMin, coinsMax, fuelStart, fuelBonus and
the fuelModMin values (higher = more fuel use for fuelModMin).

Credits:
- This game started as a copy of the 014_keyboard_move.lua example.
- coin.ogg, fuel.ogg, semi_arctic.png are from the SuperTux progject
  (github.com/SuperTux/supertux). fuel.ogg is lifeup.wav in SuperTux.
- rocketpack-running.ogg, coin.png, fuel-can.png, tux-fly.png, 
  tux-stand.png are from RocketTux (github.com/Tatwi/RocketTux).
]]
require("animation")

x, y = 100, 536
bgX = 0
playerSpeed = 400
levelSpeed = 222
levelLength = 5000
totalCoins = 0
coinsMin = 25
coinsMax = 50
coinStartX = 600
collectedCoins = 0
fuelStart = 3000
fuel = 0
fuelModMin = 2
fuelCanLive = false
fuelCanX = 832
fuelBonus = 200
fuelChance = 10
gameOver = true
winner = false
gamesPlayed = 0
gamesWon = 0

function placeCoins()
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
    
    totalCoins = math.random(coinsMin, coinsMax)
    
    for i = 1, totalCoins do
    	coins[i] = { }
    	coins[i].x = math.random(coinStartX,levelLength)
    	coins[i].y = math.random(24,558)
    	coins[i].alive = 1
    end
end

function love.load()
	love.mouse.setVisible(false)
	
	imgBackground = love.graphics.newImage("assets/semi_arctic.jpg")
	
	coinSound = love.audio.newSource("assets/coin.ogg", "static")
	fuelSound = love.audio.newSource("assets/fuel.ogg", "static")
	rocketpackRun = love.audio.newSource("assets/rocketpack-running.ogg", "static")
	rocketpackRun:setLooping(true)
	
    imgTuxFly = love.graphics.newImage("assets/tux-fly.png")
    tuxFly = newAnimation(imgTuxFly, 64, 64, 0.1, 3)
    tuxStand = love.graphics.newImage("assets/tux-stand.png")
    
    imgFuelCan = love.graphics.newImage("assets/fuel-can.png")
    
    imgCoin = love.graphics.newImage("assets/coin.png")
    coinAnim = newAnimation(imgCoin, 32, 32, 0.1, 4)
    coins = { }
    
    placeCoins()
end

function love.update(dt)
	local fuelMod = fuelModMin
	
	if gameOver then
		if rocketpackRun:isPlaying() then
			rocketpackRun:stop()
		end
		
		if love.keyboard.isDown("space") then
			gameOver = false
			winner = false
			fuel = fuelStart
			fuelCanX = 832
			collectedCoins = 0
			totalCoins = math.random(25,50)
			placeCoins()
			fuelSound:play()
			rocketpackRun:play()
		end
	else 
		if fuel == 0 then 
			gameOver = true
		end
		
		if collectedCoins == totalCoins then
			gameOver = true
			winner = true
			gamesWon = gamesWon + 1
		end
		
		if gameOver then
			gamesPlayed = gamesPlayed + 1
		end
	end
	
	if fuel > 0 and not gameOver then
		if love.keyboard.isDown("left") then
			x = x - playerSpeed/1.75 * dt
			fuelMod = fuelMod - 2
		end
		if love.keyboard.isDown("right") then
			x = x + playerSpeed * dt
			fuelMod = fuelMod + 2
		end
		if love.keyboard.isDown("up") then
			y = y - playerSpeed/1.5 * dt
			fuelMod = fuelMod + 3
		end
		if love.keyboard.isDown("down") then
			y = y + playerSpeed*1.25 * dt
			fuelMod = fuelMod - 5
		end
		
		bgX = bgX - 4
		if bgX == -800 then 
			bgX = 0
			
			if not fuelCanActive and math.random(1,100) < fuelChance then
				fuelCanActive = true
			end
		end
		
		if fuelCanActive then
			fuelCanX = fuelCanX - 4
			
			if fuelCanX < 0 then
				fuelCanActive = false
				fuelCanX = 832
			end
			
			if math.abs(fuelCanX - x) < 40 and math.abs(534 - y) < 40 then
		   		fuelCanActive = false
				fuelCanX = 832
				fuel = math.min(fuel + fuelBonus, fuelStart)
				
				if fuelSound:isPlaying() then
					fuelSound:stop()
				end
				
				fuelSound:play()
		   	end
		end
    elseif y < 736 then
    	y = y + 70 * dt
    end
    
    -- keep in bounds
    if x < 0 then x = 0 end
    if x > 736 then x = 736 end
    if y < 18 then y = 18 end
    if y > 536 then y = 536 end
	
	if fuel > 0 and not gameOver then
		for i = 1, totalCoins do
			if coins[i].alive == 1 then
				coins[i].x = coins[i].x - levelSpeed * dt
			
				if coins[i].x < 0 then 
					coins[i].x = levelLength - coinStartX
				end
				
				-- simple collision
				if math.abs(coins[i].x - x-16) < 40 and math.abs(coins[i].y - y-16) < 40 then 
					coins[i].alive = 0
					collectedCoins = collectedCoins + 1
					
					if coinSound:isPlaying() then
						coinSound:stop()
					end
					coinSound:play()
		   		end
			end
	 	end
 	
 	 	fuel = math.floor(fuel - dt * math.max(fuelMod, 1))
 	
 	tuxFly:update(dt)
 	end
 	
	coinAnim:update(dt)
end

function love.draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(imgBackground, bgX, 0)
	love.graphics.draw(imgBackground, bgX + 800, 0)
	love.graphics.rectangle("fill", 0, 0, 800, 24)
		
	if not gameOver then
		tuxFly:draw(x, y, 0, 1, 1)
		
		if fuelCanActive then
			love.graphics.print("GRAB THE FUEL CAN!", 320, 400)
			love.graphics.draw(imgFuelCan, fuelCanX, 534)
		end
	else
		love.graphics.draw(tuxStand, x, y)
		love.graphics.setColor(0,0,0,255)
		
		if winner then
		  	love.graphics.print("YOU WIN!!", 380, 300)
		else
			love.graphics.print("Out of fuel...", 380, 320)
		end
			
		love.graphics.print("Hit SPACE to play!", 362, 360)
		love.graphics.setColor(255,255,255,255)
	end
	
	for i = 1, totalCoins do
    	if coins[i].alive == 1 then
    		coinAnim:draw(coins[i].x, coins[i].y, 0, 1, 1)
    	end
 	end 
 	
 	love.graphics.setColor(0,0,0,255)
    love.graphics.print("Coins: " .. tostring(collectedCoins) .. "/" .. tostring(totalCoins), 5, 5)
    love.graphics.print("Games Won: " .. tostring(gamesWon) .. "/" .. tostring(gamesPlayed), 170, 5)
    
    love.graphics.print("Fuel:", 370, 5)
    love.graphics.setColor(0.2,0.5,0.6,1)
	love.graphics.rectangle("fill", 400, 2, 390, 20)
	love.graphics.setColor(0,1,0,1)
	love.graphics.rectangle("fill", 404, 6, 382 * (fuel/fuelStart) + 1, 12)
end