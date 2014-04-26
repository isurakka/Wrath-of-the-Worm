require("gameobj")
require("vec2")

food = gameobj();
foodImg = love.graphics.newImage("bug.png")

function food:init(pos)
	self.pos = pos
	self.scale = 1
end

function food:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(foodImg, self.pos.x, self.pos.y, 0, self.scale * 0.4, nil, 32 * 0.4 / 2, 32 * 0.4 / 2)
end