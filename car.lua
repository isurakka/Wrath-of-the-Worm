require("gameobj")
require("vec2")

local bodyColors = {
	{ 155, 89, 182 },
	{ 230, 126, 34 },
	{ 236, 240, 241 },
	{ 52, 73, 94 }
}

car = gameobj();

function car:init(pos, patrolRadius)
	self.pos = pos
	self.speed = math.random(80, 300)

	local rand = math.random(0, 1)
	if (rand == 0) then
		self.dir = -1
	else
		self.dir = 1
	end
	self.patrolRadius = patrolRadius

	self.color = bodyColors[math.random(1, tableLength(bodyColors))]
end

function car:tick(step)
	self.pos.x = self.pos.x + self.dir * self.speed * step

	if (self.pos.x > self.patrolRadius and self.dir == 1) then
		self.dir = self.dir * -1
	end

	if (self.pos.x < -self.patrolRadius and self.dir == -1) then
		self.dir = self.dir * -1
	end
end

function car:draw()
	local wheelRadius = 12
	local size = vec2(92, 40)

	love.graphics.setColor(self.color);

	-- body
	love.graphics.rectangle("fill", 
		self.pos.x - size.x / 3 / 2, 
		self.pos.y - wheelRadius - size.y, 
		size.x / 3, 
		size.y)

	-- left side
	love.graphics.rectangle("fill", 
		self.pos.x - size.x / 2, 
		self.pos.y - wheelRadius - size.y / 2, 
		size.x / 3, 
		size.y / 2)
	love.graphics.polygon("fill", 
		self.pos.x - size.x / 3 / 2,
		self.pos.y - wheelRadius - size.y,
		self.pos.x - size.x / 2 + size.x / 3,
		self.pos.y - wheelRadius - size.y / 2,
		self.pos.x - size.x / 2 + size.x / 3 / 2,
		self.pos.y - wheelRadius - size.y / 2
		)
	-- right side
	love.graphics.rectangle("fill", 
		self.pos.x + size.x / 2 - size.x / 3, 
		self.pos.y - wheelRadius - size.y / 2, 
		size.x / 3, 
		size.y / 2)
	love.graphics.polygon("fill", 
		self.pos.x + size.x / 2 - size.x / 3,
		self.pos.y - wheelRadius - size.y,
		self.pos.x + size.x / 2 - size.x / 3 + size.x / 3 / 2,
		self.pos.y - wheelRadius - size.y / 2,
		self.pos.x + size.x / 2 - size.x / 3,
		self.pos.y - wheelRadius - size.y / 2)

	local flatMult = 0.5
	love.graphics.setColor(127 * flatMult, 140 * flatMult, 141 * flatMult);
	love.graphics.circle("fill", self.pos.x - size.x / 3, self.pos.y - wheelRadius + 2, wheelRadius, wheelRadius * 2)
	love.graphics.circle("fill", self.pos.x + size.x / 3, self.pos.y - wheelRadius + 2, wheelRadius, wheelRadius * 2)
end