mega = mega or {}
mega.movements={}

--Defines a new move, you can then store it in a variable
function mega.movements.newMove(acceleration,deceleration,maximumspeed,x1,y1,x2,y2)

		--Movements constansts
	local t = {
		acc = acceleration or 0,
		decc = deceleration or 0,
		topspeed = maximumspeed
		}
		
		--This resets the angle, you don't need to call this yourself
		--simply calling setPosition or setTarget will take care of this.
		function t:setAngle()
			if self.targetx == nil or self.targety == nil then return end
			local angle = math.atan2((self.targety - self.y), (self.targetx - self.x))
			self.cosangle = math.cos(angle)
			self.sinangle = math.sin(angle)
		end
		
		--This makes the object jump and snap to the target, skipping the distance.
		function t:snapToTarget()
			self.x=self.targetx
			self.y=self.targety
			self.vel=0
			self.finished=true
		end
		
		--Call this every frame from your update function.
		function t:advance(dt)
			if self.targetx == nil or self.targety == nil then
				return
			end
			local distance = math.sqrt((self.targetx-self.x)^2 + (self.targety-self.y)^2)
			if distance < self.vel * dt or self.finished then					--we almost reached it, skip the rest
				self:snapToTarget()
				return
			end
			local deccDistance								--the distance we need to fully stop
			if self.decc > 0 then
				deccDistance = self.vel^2 / (2 * self.decc)
			else
				deccDistance = 0
			end
			
			if distance>deccDistance then
				self.vel=math.min(self.vel + self.acc * dt, self.topspeed)		--we are still far, accelerate (if possible)
			else
				self.vel=math.max(self.vel - self.decc * dt,0)					--we should be stopping
			end
			if self.vel == 0 then
				self:snapToTarget()
				return
			end
			self.x=self.x + self.vel * self.cosangle * dt
			self.y=self.y + self.vel * self.sinangle * dt
			
			self.finished=false
		end
		
		--Resets the velocity to the begining value, usually 0.
		function t:resetVelocity()
			if self.acc > 0 then self.vel=0 else self.vel=self.topspeed end
		end
		
		--Change the target.
		function t:setTarget(x,y)
			self.finished=false
			self.targetx = x
			self.targety = y
			if x == nil or y == nil then
				self.finished=true
				self.vel=0
				return
			end
			self:setAngle()
		end
		
		--A fancy way to get the current position
		function t:getPosition()
			return self.x, self.y
		end
		
		--If your object changes its position unexpectedly, call this function.
		function t:setPosition(x, y)
			self.x = x
			self.y = y
			self:setAngle()
		end
		
		--A fancy way to get if the move is done or not.
		function t:isFinished()
			return self.finished
		end
		
		
		t:setPosition(x1,y1)
		t:setTarget(x2,y2)
		t:resetVelocity()
		
	return t
end
