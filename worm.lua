require("gameobj")
require("vec2")

worm = gameobj();

function worm:init()
	self.pieces = { vec2() }
	self.dir = vec2(1, 0)
	self.length = 100
	self.speed = 160
	self.radius = 12;
	self.rotationSpeed = 300
end

function worm:update(dt)
	
end

function worm:tick(step)
	local last = self.pieces[1]
	local new = last:add(vec2(
		self.dir.x * self.speed * step, 
		self.dir.y * self.speed * step))

	table.insert(self.pieces, 1, new)
end

function worm:draw()
	love.graphics.setColor(211, 84, 0, 255)

	for k, v in pairs(self.pieces) do
		love.graphics.circle("fill", v.x, v.y, self.radius, self.radius)
	end
end