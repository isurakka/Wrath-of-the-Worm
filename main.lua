require("utils")

require("playerworm")
require("ground")
require("food")

gameobjs = { }
foods = { }
playerObj = nil
groundObj = nil

function love.load()
	math.randomseed(os.time())

	groundObj = ground(vec2(2000, 400))
	table.insert(gameobjs, groundObj)

	playerObj = playerworm()
	table.insert(gameobjs, playerObj)

	playerObj.base.onPointAdd = function(point)
		groundObj:addPoint(point, playerObj.base.radius)
	end
end

function love.draw()
	love.graphics.translate(
		love.graphics.getWidth() / 2, 
		love.graphics.getHeight() / 2)

	love.graphics.translate(-playerObj.base:getHead().x, -playerObj.base:getHead().y)

	local topLeft = vec2(
		playerObj.base:getHead().x - love.graphics.getWidth() / 2,
		playerObj.base:getHead().y - love.graphics.getHeight() / 2)
	local botRight = vec2(
		topLeft.x + love.graphics.getWidth(),
		topLeft.y + love.graphics.getHeight())

	if (topLeft.x < groundObj.topLeft.x) then
		love.graphics.translate(topLeft.x - groundObj.topLeft.x, 0)
	end

	if (botRight.x > groundObj.botRight.x) then
		love.graphics.translate(botRight.x - groundObj.botRight.x, 0)
	end

	if (botRight.y > groundObj.botRight.y) then
		love.graphics.translate(0, botRight.y - groundObj.botRight.y)
	end

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
		love.tick(step)
	end

	-- update
	for k, v in pairs(gameobjs) do
		v:update(dt)
	end
end

function love.tick(step)
	for k, v in pairs(gameobjs) do
		v:tick(step)
	end

	-- update ground empty spots
	for k, v in pairs(playerObj.base.pieces) do
		local contains = false
		for k2, v2 in pairs(groundObj.emptySpots) do
			if (v.x == v2.x and v.y == v2.y) then
				contains = true
				break
			end
		end

		if (not contains) then
			--table.insert(groundObj.emptySpots, { v, playerObj.base.radius })
		end
	end

	-- add more food if necessary
	while table.getn(foods) < 4 do
		local size = groundObj:getSize()
		local newFood = food(vec2(math.random(0, size.x), math.random(0, size.y)):add(groundObj.topLeft))
		table.insert(foods, newFood)
		table.insert(gameobjs, newFood)
	end

	--print(table.getn(groundObj.emptySpots))
end