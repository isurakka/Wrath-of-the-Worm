require("gameobj")
require("vec2")

local bodyColors = {
	{ 46, 204, 113 },
	{ 52, 152, 219 },
	{ 241, 196, 15 },
	{ 231, 76, 60 }
}

human = gameobj();

function human:init(pos, patrolRadius)
	self.pos = pos
	self.speed = math.random(40, 100)

	local rand = math.random(0, 1)
	if (rand == 0) then
		self.dir = -1
	else
		self.dir = 1
	end
	self.patrolRadius = patrolRadius

	self.headColor = bodyColors[math.random(1, tableLength(bodyColors))]
	self.headColorMult = math.random(20, 100) / 100
end

function human:tick(step)
	self.pos.x = self.pos.x + self.dir * self.speed * step

	if (self.pos.x > self.patrolRadius and self.dir == 1) then
		self.dir = self.dir * -1
	end

	if (self.pos.x < -self.patrolRadius and self.dir == -1) then
		self.dir = self.dir * -1
	end
end

function human:draw()
	local size = vec2(24, 36)

	love.graphics.setColor(self.headColor);
	love.graphics.rectangle("fill", self.pos.x - size.x / 2, self.pos.y - size.y, size.x, size.y)

	local headSize = vec2(24, 18)
	love.graphics.setColor(
		255 * self.headColorMult, 
		236 * self.headColorMult, 
		181 * self.headColorMult, 255);
	love.graphics.rectangle("fill", self.pos.x - headSize.x / 2, self.pos.y - size.y - headSize.y, headSize.x, headSize.y)
end