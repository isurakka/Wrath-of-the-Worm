require("gameobj")
require("vec2")

worm = gameobj();

function worm:init()
	self.pieces = { vec2() }
	self.dir = vec2(1, 0)
	self.length = 100
	self.speed = 200
	self.radius = 16;
end

function worm:update(dt)
	
end

function worm:tick(step)
	self.dir = self.dir:rotateDegrees(100 * step):normalized();

	local last = self.pieces[1]
	local new = last:add(vec2(
		self.dir.x * self.speed * step, 
		self.dir.y * self.speed * step))

	table.insert(self.pieces, 1, new)
end

function worm:draw()
	local i = 0
	for k, v in pairs(self.pieces) do
		love.graphics.circle("fill", v.x, v.y, self.radius, self.radius)
		i = i + 1
	end
end