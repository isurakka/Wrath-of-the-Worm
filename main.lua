require("utils")

require("playerworm")
require("ground")
require("food")
require("human")
require("car")
require("house")

startImg = love.graphics.newImage("start.png")
endImg = love.graphics.newImage("end.png")

function love.load()
	math.randomseed(os.time())

	love.graphics.setBackgroundColor( 84, 145, 183 )

	love.init()

	gameState = "start"
end

function love.init()

	-- init global variables
	gameobjs = { }
	foods = { }
	humans = { }
	cars = { }
	houses = { }
	playerObj = nil
	groundObj = nil

	-- create ground
	groundObj = ground(vec2(2000, 590))
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
	for i=1, 30 do
		local humanObj = human(vec2(math.random(-500, 500)), 1000)
		table.insert(humans, humanObj)
		table.insert(gameobjs, humanObj)
	end

	-- generate cars
	for i=1, 10 do
		local carObj = car(vec2(math.random(-500, 500)), 1000)
		table.insert(cars, carObj)
		table.insert(gameobjs, carObj)
	end

	-- create player
	playerObj = playerworm(vec2(0, 200))
	table.insert(gameobjs, playerObj)

	-- set food creation hook
	playerObj.base.onPointAdd = function(point)
		groundObj:addPoint(point, playerObj.base.radius + 4)
	end
end

function love.draw()
	love.graphics.push()

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

	love.graphics.pop()

	if (gameState == "end" or (gameState == "start")) then
		local topLeft = vec2(
			0,
			0)

		love.graphics.setColor(0, 0, 0, 128)

		love.graphics.rectangle("fill", 
			topLeft.x,
			topLeft.y, 
			love.graphics.getWidth(),
			love.graphics.getHeight())

		love.graphics.setColor(255, 255, 255, 255)
		if (gameState == "end") then
			love.graphics.draw(
				endImg, 
				topLeft.x, 
				topLeft.y)
		elseif (gameState == "start") then
			love.graphics.draw(
				startImg, 
				topLeft.x, 
				topLeft.y)
		end
	end
end

step = 1 / 120
acc = 0
function love.update(dt)
	if (gameState == "game") then
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
	elseif (gameState == "end") then
		if (love.keyboard.isDown("escape")) then
			love.event.quit()
		end

		if (love.keyboard.isDown("return")) then
			gameState = "start"
			love.init()
		end
	elseif (gameState == "start") then
		if (love.keyboard.isDown("left") or love.keyboard.isDown("right")) then
			gameState = "game"
		end
	end
end

function love.tick(step)
	for k, v in pairs(gameobjs) do
		v:tick(step)
	end

	local head = playerObj.base:getHead()

	-- check if we can eat food
	for i = tableLength(foods), 1, -1 do
		local v = foods[i]
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
			playerObj.base.speed = playerObj.base.speed + 1.5
		end
	end

	-- check if we can eat humans
	if (playerObj.base.radius >= 12) then
		for i = tableLength(humans), 1, -1 do
			local v = humans[i]
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
				playerObj.base.speed = playerObj.base.speed + 2
			end
		end
	end

	-- check if we can eat cars
	if (playerObj.base.radius >= 20) then
		for i = tableLength(cars), 1, -1 do
			local v = cars[i]
			if (head:sub(v.pos:sub(vec2(0, 20))):length() < playerObj.base.radius + 20) then
				table.remove(cars, i)
				for i2,v2 in ipairs(gameobjs) do
					if (v2.pos ~= nil and v2.pos.x == v.pos.x and v2.pos.y == v.pos.y) then
						table.remove(gameobjs, i2)
						break
					end
				end

				playerObj.base.maxLength = playerObj.base.maxLength + 60
				playerObj.base.radius = playerObj.base.radius + 0.4
				playerObj.base.speed = playerObj.base.speed + 4
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

	-- check if we hit ourself
	local lenTested = 0
	for i = 1, tableLength(playerObj.base.pieces) do
		local cur = playerObj.base.pieces[i]
		local nex = playerObj.base.pieces[i + 1]
		if (nex == nil) then
			break
		end

		local toNexDir = nex:sub(cur):normalized()
		local len = nex:sub(cur):length()

		for j=0, math.floor(len), 1 do
			if (math.floor(len) < 1) then
				break
			end

			lenTested = lenTested + 1
			if (lenTested < playerObj.base.radius * 3) then
				goto innerContinue
			end

			local test = cur:add(toNexDir:mul(j / len * len))
			local toHead = head:sub(test)
			local toHeadDist = toHead:length()

			if (toHeadDist < playerObj.base.radius * 2) then
				love.endGame()
				print("player", head.x, head.y, "test", test.x, test.y)
				print("lenTested", lenTested, "i", i)
				goto breakAll
			end
			::innerContinue::
		end

		::continue::
	end
	::breakAll::

	print("WormRadius", playerObj.base.radius)
end

function love.endGame()
	gameState = "end"
end