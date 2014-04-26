require("worm")

playerworm = gameobj()

local oldInit = playerworm.init
function playerworm:init(pos)
	self.base = worm(pos)
end

function playerworm:tick(step)

	if (not self.base:isOverGround()) then
		local rot = 0
		if (love.keyboard.isDown("left")) then
			rot = rot - 1
		end
		if (love.keyboard.isDown("right")) then
			rot = rot + 1
		end

		self.base.dir = self.base.dir:rotateDegrees(rot * self.base.rotationSpeed * step):normalized();
	end
	self.base:tick(step)
end

function playerworm:draw()
	self.base:draw()
end