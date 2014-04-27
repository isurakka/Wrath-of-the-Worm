require("gameobj")
require("vec2")

local bodyColors = {
	{ 192, 57, 43 },
	{ 243, 156, 18 },
	{ 39, 174, 96 },
	{ 41, 128, 185 }
}

smallHouse = gameobj();

function smallHouse:init(pos, size)
	self.pos = pos
	self.size = size
	self.color = bodyColors[math.random(1, tableLength(bodyColors))]
	self.colorMult = math.random(50, 80) / 100
end

function smallHouse:draw()
	love.graphics.setColor(self.color[1] * self.colorMult, self.color[2] * self.colorMult, self.color[3] * self.colorMult, 255);
	love.graphics.rectangle("fill", self.pos.x - self.size.x / 2, self.pos.y - self.size.y, self.size.x, self.size.y)

	local roofHeight = 30
	local roofMult = 0.65
	love.graphics.setColor(127 * roofMult, 140 * roofMult, 141 * roofMult)
	love.graphics.polygon("fill",
		self.pos.x - self.size.x / 2,
		self.pos.y - self.size.y,
		self.pos.x,
		self.pos.y - self.size.y - roofHeight,
		self.pos.x + self.size.x / 2,
		self.pos.y - self.size.y)
end