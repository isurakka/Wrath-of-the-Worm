require("gameobj")
require("vec2")

house = gameobj();

function house:init(pos, size)
	self.pos = pos
	self.size = size
end

function house:draw()
	love.graphics.setColor(127, 140, 141, 255);
	love.graphics.rectangle("fill", self.pos.x - self.size.x / 2, self.pos.y - self.size.y, size.x, size.y)
end