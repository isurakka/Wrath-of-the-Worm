require("gameobj")
require("vec2")

food = gameobj();
foodImg = love.graphics.newImage("bug.png")

function food:init(pos, size)
	self.pos = pos

	self.defaultSize = 12

	if size == nil then
		self.size = self.defaultSize
	else
		self.size = size
	end

	self.rot = math.random(0, 314 * 2) / 100
end

function food:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(foodImg, self.pos.x, self.pos.y, self.rot, self.size / 32, nil, self.size / 2, self.size / 2)
end