-- Example: Physics
-- Grabbity by Xcmd
-- Updated by Dresenpai
-- Updated 0.8.0 by Bartoleo
math.randomseed( os.time() )

function love.load()
   
   love.graphics.setFont(love.graphics.newFont(11))

   love.physics.setMeter( 32 )
   myWorld = love.physics.newWorld(0, 9.81*32, true)  -- updated Arguments for new variant of newWorld in 0.8.0
   gravity="down"
   myWorld:setCallbacks( beginContact, endContact, preSolve, postSolve )

   myBallBody = love.physics.newBody( myWorld, 300, 400 ,"dynamic" )
   myBallShape = love.physics.newCircleShape( 0, 0, 16 )
   myBallFixture = love.physics.newFixture(myBallBody, myBallShape)
   myBallBody:setMassData(0,0,1,0)
   myBallFixture:setUserData("ball")

   myWinBody = love.physics.newBody( myWorld, math.floor(math.random(100, 700)), math.floor(math.random(100, 500)) ,"dynamic" )
   myWinShape = love.physics.newRectangleShape(  0, 0, 16, 16, 0 )
   myWinFixture = love.physics.newFixture(myWinBody, myWinShape)
   myWinFixture:setUserData("win")

   myEdgeBody1 = love.physics.newBody( myWorld, 0,0 ,"static")
   myEdgeShape1 = love.physics.newEdgeShape( 10,10, 790,10  )
   myEdgeFixture1 = love.physics.newFixture(myEdgeBody1, myEdgeShape1)
   myEdgeFixture1:setUserData("edge1")

   myEdgeBody2 = love.physics.newBody( myWorld, 0,0 ,"static")
   myEdgeShape2 = love.physics.newEdgeShape( 790,10, 790,590  )
   myEdgeFixture2 = love.physics.newFixture(myEdgeBody2, myEdgeShape2)
   myEdgeFixture2:setUserData("edge2")
   
   myEdgeBody3 = love.physics.newBody( myWorld, 0,0 ,"static")
   myEdgeShape3 = love.physics.newEdgeShape( 10,590, 790,590  )
   myEdgeFixture3 = love.physics.newFixture(myEdgeBody3, myEdgeShape3)
   myEdgeFixture3:setUserData("edge3")

   myEdgeBody4 = love.physics.newBody( myWorld, 0,0 ,"static")
   myEdgeShape4 = love.physics.newEdgeShape( 10,10, 10,590  )
   myEdgeFixture4 = love.physics.newFixture(myEdgeBody4, myEdgeShape4)
   myEdgeFixture4:setUserData("edge4")

   texts = {}

   prepostsolve = false

end

function love.update( dt )
   myWorld:update( dt )
end

function love.draw()
   love.graphics.line(myEdgeBody1:getWorldPoints(myEdgeShape1:getPoints()))
   love.graphics.line(myEdgeBody2:getWorldPoints(myEdgeShape2:getPoints()))
   love.graphics.line(myEdgeBody3:getWorldPoints(myEdgeShape3:getPoints()))
   love.graphics.line(myEdgeBody4:getWorldPoints(myEdgeShape4:getPoints()))
   love.graphics.circle("line", myBallBody:getX(), myBallBody:getY(), myBallShape:getRadius())
   love.graphics.polygon("fill", myWinBody:getWorldPoints(myWinShape:getPoints()))
   love.graphics.print( "gravity:"..gravity, 25, 25 )
   if prepostsolve then
      love.graphics.print( "space : disable preSolve/postSolve Logging", 400, 25 )
   else
      love.graphics.print( "space : enable preSolve/postSolve Logging", 400, 25 )
   end
   love.graphics.print( "arrows : change gravity direction", 400, 36 )
   if #texts > 48 then
      table.remove(texts,1)
   end
   if #texts > 96 then
      table.remove(texts,1)
   end
   for i,v in ipairs(texts) do
     love.graphics.print( v, 25, 37+11*i )
   end
end

function love.keypressed( key )
   if key == "up" then
      myWorld:setGravity(0, -9.81*32)
      gravity="up"
      for i,v in ipairs(myWorld:getBodies( )) do
        v:setAwake( true )
      end
   elseif key == "down" then
      myWorld:setGravity(0, 9.81*32)
      gravity="down"
      for i,v in ipairs(myWorld:getBodies( )) do
        v:setAwake( true )
      end
   elseif key == "left" then
      myWorld:setGravity(-9.81*32, 0)
      gravity="left"
      for i,v in ipairs(myWorld:getBodies( )) do
        v:setAwake( true )
      end
  elseif key == "right" then
      myWorld:setGravity(9.81*32, 0)
      gravity="right"
      for i,v in ipairs(myWorld:getBodies( )) do
        v:setAwake( true )
      end
   end

   if key == "space" then
      prepostsolve = not prepostsolve
   end

   if key == "r" then
      love.load()
   end
end

function beginContact( a, b, c )
   coll( a, b, c, "beginContact",true )
end

function endContact( a, b, c )
   coll( a, b, c, "endContact",true )
end

function preSolve( a, b, c )
   if prepostsolve then
     coll( a, b, c, "preSolve",false )
   end
end

function postSolve( a, b, c )
   if prepostsolve then
     coll( a, b, c, "postSolve",false )
   end
end

local function ifnil(ptest,preturn)
   if p==nil then
      return preturn
   end
   return ptest
end

function coll( a, b, c, ctype,detail )

   local f, r = c:getFriction(), c:getRestitution()
   --local s = c:getSeparation()   
   local px1, py1, px2, py2 = c:getPositions()
   --local vx, vy = c:getVelocity()
   local nx, ny = c:getNormal()
   local aa = a:getUserData()
   local bb = b:getUserData()

   table.insert(texts, ctype .. " Collision : " .. aa .. " and " .. bb)
   if detail then 
     table.insert(texts, "Position: " .. ifnil(px1,"nil") .. "," .. ifnil(py1,"nil") .. "," .. ifnil(px2,"nil") .. "," .. ifnil(py2,"nil") )
     --table.insert(texts, "Velocity: " .. vx .. "," .. vy )
     table.insert(texts, "Normal: " .. nx .. "," .. ny )
     table.insert(texts, "Friction: " .. f )
     table.insert(texts, "Restitution: " .. r )
     --table.insert(texts, "Separation: " .. s )
   end
   table.insert(texts, "")
end

