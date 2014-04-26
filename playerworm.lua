require("worm")

base = worm()
playerworm = gameobj()

local oldInit = playerworm.init
function playerworm:init()
	base:init()
end

function playerworm:tick(step)
	local rot = 0
	if (love.keyboard.isDown("left")) then
		rot = rot - 1
	end
	if (love.keyboard.isDown("right")) then
		rot = rot + 1
	end

	base.dir = base.dir:rotateDegrees(rot * base.rotationSpeed * step):normalized();

	base:tick(step)
end

function playerworm:draw()
	base:draw()
end