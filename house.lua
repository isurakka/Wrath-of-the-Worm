require("gameobj")
require("vec2")

house = gameobj();

function house:init(pos, size)
	self.pos = pos
	self.size = size
	self.colorMult = math.random(70, 100) / 100
end

function house:draw()
	love.graphics.setColor(127 * self.colorMult, 140 * self.colorMult, 141 * self.colorMult, 255);
	love.graphics.rectangle("fill", self.pos.x - self.size.x / 2, self.pos.y - self.size.y, self.size.x, self.size.y)
end