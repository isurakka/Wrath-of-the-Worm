require("utils")

require("playerworm")
require("ground")
require("food")
require("human")
require("house")

gameobjs = { }
foods = { }
humans = { }
houses = { }
playerObj = nil
groundObj = nil

function love.load()
	math.randomseed(os.time())

	-- create ground
	groundObj = ground(vec2(2000, 400))
	table.insert(gameobjs, groundObj)

	-- generate houses
	local houseGen = vec2(-900, 0)
	while true do
		local houseSize = vec2(
			math.random(80, 200),
			math.random(80, 400))
		local margin = math.random(0, 3)
		local houseObj = house(
			vec2(houseGen.x + houseSize.x / 2, 0), 
			vec2(houseSize.x, houseSize.y))

		table.insert(houses, houseObj)
		table.insert(gameobjs, houseObj)

		houseGen.x = houseGen.x + houseSize.x + margin * 20

		if (houseGen.x > 750) then
			break
		end
	end

	-- generate humans
	for i=1, 50 do
		local humanObj = human(vec2(math.random(-500, 500)), 1000)
		table.insert(humans, humanObj)
		table.insert(gameobjs, humanObj)
	end

	-- create player
	playerObj = playerworm(vec2(0, 200))
	table.insert(gameobjs, playerObj)

	-- set food creation hook
	playerObj.base.onPointAdd = function(point)
		groundObj:addPoint(point, playerObj.base.radius + 2)
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

	-- check if we can eat food
	for i = tableLength(foods), 1, -1 do
		local v = foods[i]
		local head = playerObj.base:getHead()
		if (head:sub(v.pos):length() < playerObj.base.radius + 8) then
			table.remove(foods, i)
			for i2,v2 in ipairs(gameobjs) do
				if (v2.pos ~= nil and v2.pos.x == v.pos.x and v2.pos.y == v.pos.y) then
					table.remove(gameobjs, i2)
					break
				end
			end

			playerObj.base.maxLength = playerObj.base.maxLength + 15
			playerObj.base.radius = playerObj.base.radius + 0.15
		end
	end

	-- check if we can eat humans
	if (playerObj.base.radius >= 12) then
		for i = tableLength(humans), 1, -1 do
			local v = humans[i]
			local head = playerObj.base:getHead()
			if (head:sub(v.pos):length() < playerObj.base.radius + 12) then
				table.remove(humans, i)
				for i2,v2 in ipairs(gameobjs) do
					if (v2.pos ~= nil and v2.pos.x == v.pos.x and v2.pos.y == v.pos.y) then
						table.remove(gameobjs, i2)
						break
					end
				end

				playerObj.base.maxLength = playerObj.base.maxLength + 30
				playerObj.base.radius = playerObj.base.radius + 0.2
			end
		end
	end

	-- add more food if necessary
	while tableLength(foods) < 6 do
		local size = groundObj:getSize()
		local newFood = food(vec2(math.random(0, size.x), math.random(0, size.y)):add(groundObj.topLeft))
		table.insert(foods, newFood)
		table.insert(gameobjs, newFood)
	end
end