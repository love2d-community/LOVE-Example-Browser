mega = mega or {}
mega.movements={}

--Defines a new move, you can then store it in a variable
function mega.movements.newMove(acceleration,deacceleration,maximumspeed,x1,y1,x2,y2)
	local t = {
	
		acc = acceleration,
		deacc = deacceleration,
		topspeed = maximumspeed,
		x=x1,
		y=y1,
		finished=false
		}
		if x2 ~=nil and y2~=nil then
			t.targetx=x2
			t.targety=y2
	
			local angle=math.atan2((y2 - y1), (x2 - x1))
			t.cosangle=math.cos(angle)
			t.sinangle=math.sin(angle)
		end
		
		if t.acc > 0 then t.vel = 0 else t.vel = t.topspeed end
		
		function t:jump()
			self.x=self.targetx
			self.y=self.targety
			self.vel=0
			self.finished=true
		end
		
		function t:advance(dt)
			if self.targetx == nil or self.targety == nil then
				return
			end
			local distance = math.sqrt((self.targetx-self.x)^2 + (self.targety-self.y)^2)
			if distance < self.vel * dt or self.finished then					--we almost reached it, skip the rest
				self:jump()
				return
			end
			local deaccDistance								--the distance we need to fully stop
			if self.deacc > 0 then
				deaccDistance = self.vel^2 / (2 * self.deacc)
			else
				deaccDistance = 0
			end
			
			if distance>deaccDistance then
				self.vel=math.min(self.vel + self.acc * dt, self.topspeed)		--we are still far, accelerate (if possible)
			else
				self.vel=math.max(self.vel - self.deacc * dt,0)					--we should be stopping
			end
			if self.vel == 0 then
				self:jump()
				return
			end
			self.x=self.x + self.vel * self.cosangle * dt
			self.y=self.y + self.vel * self.sinangle * dt
			
			self.finished=false
		end
		
		function t:resetVelocity()
			if self.acc > 0 then self.vel=0 else self.vel=self.topspeed end
		end
		
		function t:setTarget(x,y)
			self.finished=false
			self.targetx=x
			self.targety=y
			if x == nil or y == nil then self.finished=true self.vel=0 return end
			local angle = math.atan2((y - self.y), (x - self.x))
			self.cosangle=math.cos(angle)
			self.sinangle=math.sin(angle)
		end
		
		function t:getPosition()
			return self.x, self.y
		end
		
		function t:setPosition(x, y)
			self.x = x
			self.y = y
		end
		
		function t:isFinished()
			return self.finished
		end
	
	return t
end