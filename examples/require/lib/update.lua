local width, height = love.graphics.getDimensions()
local vx, vy = math.random(90) + 110, math.random(90) + 90

return function(dt)
  x = x + vx * dt
  y = y + vy * dt

  if x > width - 60 or x < 60 then vx = -vx end
  if y > height - 60 or y < 60 then vy = -vy end
end
