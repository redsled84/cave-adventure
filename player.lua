local maxRadius = 60
local player = {
	x = 0,
	y = 0,
	width = 32,
	height = 48,
	speed = 260,
	sword = {
		right = {
			maxTheta = math.pi / 3,
			minTheta = -math.pi / 4,
		},
		left = {
			maxTheta = 2 * math.pi / 3,
			minTheta = 5 * math.pi / 4,
		},
		up = {
			maxTheta = 5 * math.pi / 6,
			minTheta = math.pi / 4
		},
		down = {
			maxTheta = 11 * math.pi / 6,
			minTheta = 5 * math.pi / 4
		},
		theta = 0,
		thetaStep = 10,
		active = false,
		radius = maxRadius,
		radiusStep = 8,
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0,
		direction = "right",
		minTheta = 0
	}
}

function player:update(dt)
	self:move(dt)
	self:moveSword(dt)
end

function player:move(dt)
	if love.keyboard.isDown("d") then
		self.x = self.x + self.speed * dt
	elseif love.keyboard.isDown("a") then
		self.x = self.x - self.speed * dt
	end
	if love.keyboard.isDown("s") then
		self.y = self.y + self.speed * dt
	elseif love.keyboard.isDown("w") then
		self.y = self.y - self.speed * dt
	end
end

function player:moveSword(dt)
	if not self.sword.active then
		self.sword.x1, self.sword.x2 = self.x, self.x
		self.sword.y1, self.sword.y2 = self.y, self.y
	else
		self.sword.x1 = self.x
		self.sword.y1 = self.y

		if self.sword.theta > self.sword.minTheta then
			self.sword.theta = self.sword.theta - self.sword.thetaStep * dt
			self.sword.radius = self.sword.radius - self.sword.radiusStep * dt
		else
			self.sword.theta = 0
			self.sword.active = false
		end

		self.sword.x2 = self.sword.radius * math.cos(self.sword.theta) + self.sword.x1
		self.sword.y2 = self.sword.radius * math.sin(self.sword.theta) + self.sword.y1
	end
end

function player:draw()
	love.graphics.setColor(150, 150, 200)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

	love.graphics.setColor(0, 255, 0)
	love.graphics.line(self.sword.x1, self.sword.y1, self.sword.x2, self.sword.y2)
end

function player:attack(key)
	if not self.sword.active
	and (key == "right"
	or key == "left"
	or key == "up"
	or key == "down") then
		self.sword.active = true
		self.sword.radius = maxRadius
		self.sword.direction = key
	end

	if key == "right" then
		self.sword.theta = self.sword.right.maxTheta
		self.sword.minTheta = self.sword.right.minTheta
	elseif key == "left" then
		self.sword.theta = self.sword.left.maxTheta
		self.sword.minTheta = self.sword.left.minTheta
	elseif key == "up" then
		self.sword.theta = self.sword.up.maxTheta
		self.sword.minTheta = self.sword.up.minTheta
	elseif key == "down" then
		self.sword.theta = self.sword.down.maxTheta
		self.sword.minTheta = self.sword.down.minTheta
	end
end

return player