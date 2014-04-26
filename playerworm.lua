require("worm")

playerworm = worm()

function playerworm:init()
	self.__baseclass:init()
end

function playerworm:tick(step)
	local rot = 0
	if (love.keyboard.isDown("left")) then
		rot = rot - 1
	end
	if (love.keyboard.isDown("right")) then
		rot = rot + 1
	end

	self.__baseclass.dir = self.dir:rotateDegrees(rot * self.rotationSpeed * step):normalized();

	self.__baseclass:tick(step)
end

function playerworm:draw()
	self.__baseclass:draw()
end