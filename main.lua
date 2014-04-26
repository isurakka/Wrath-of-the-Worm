require("worm")

gameobjs = { }

function love.load()
	table.insert(gameobjs, worm())
end

function love.draw()
    love.graphics.print("test", 400, 300)

    for k, v in pairs(gameobjs) do
		v:draw()
	end
end

step = 1 / 120
acc = 0
function love.update(dt)
	-- tick
	acc = acc + dt
	if acc >= step then
		acc = acc - step
		for k, v in pairs(gameobjs) do
			v:tick(step)
		end
	end

	-- update
	for k, v in pairs(gameobjs) do
		v:update(dt)
	end
end