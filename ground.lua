require("gameobj")
require("vec2")

ground = gameobj();

function ground:init(size)
	self.topLeft = vec2(-size.x / 2, 0)
	self.botRight = vec2(size.x / 2, size.y / 2)
end

function ground:draw()
	--local darkAdd = -60
	love.graphics.setColor(76, 30, 0, 255)

	love.graphics.rectangle(
		"fill", 
		self.topLeft.x, 
		self.topLeft.y, 
		self.botRight.x - self.topLeft.x,
		self.botRight.y - self.topLeft.y)
end