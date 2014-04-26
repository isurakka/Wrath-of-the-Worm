require("worm")
require("playerworm")
require("utils")

gameobjs = { }
player = nil

function love.load()
	player = playerworm()
	table.insert(gameobjs, player)
end

function love.draw()
	love.graphics.translate(
		love.graphics.getWidth() / 2, 
		love.graphics.getHeight() / 2)

    love.graphics.print("test", 0, 0)

    for k, v in pairs(gameobjs) do
		v:draw()
	end
end

step = 1 / 120
acc = 0
function love.update(dt)
	-- tick
	acc = acc + dt
	while acc >= step do
		acc = acc - step
		for k, v in pairs(gameobjs) do
			v:tick(step)
		end
	end

	-- update
	for k, v in pairs(gameobjs) do
		v:update(dt)
	end

	--print(table.tostring(playerworm.pieces))
end