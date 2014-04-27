require("gameobj")
require("vec2")

ground = gameobj();

function ground:init(size)
	self.topLeft = vec2(-size.x / 2, 0)
	self.botRight = vec2(size.x / 2, size.y)
	self.beachWidth = size.x / 4
	self.topLeftAll = vec2(-size.x / 2 - self.beachWidth, 0)
	self.botRightAll = vec2(size.x / 2 + self.beachWidth, size.y)
	self.emptySpots = { }
	self.canvas = love.graphics.newCanvas(size.x + self.beachWidth * 2, size.y)
	self.maxEmptyLength = 8000
end

function ground:getSize()
	return vec2(self.botRight.x - self.topLeft.x,
		self.botRight.y - self.topLeft.y)
end

function ground:addPoint(point, radius)
	local last = self.emptySpots[1]
	local secondLast = self.emptySpots[2]

	local dot
	if (last ~= nil and secondLast ~= nil) then
		dot = last[1]:sub(secondLast[1]):normalized():dot(point:sub(last[1]):normalized())
	end

	if (dot ~= nil and dot >= 0.999) then
		self.emptySpots[1] = { point, radius }
	else
		table.insert(self.emptySpots, 1, { point, radius })
	end

	self:trimPoints(self:getEmptyLength() - self.maxEmptyLength)
end

function ground:getEmptyLength()
	local len = 0
	for i,v in ipairs(self.emptySpots) do
		local cur = v
		local nex = self.emptySpots[i + 1]
		if (nex == nil) then
			break
		end

		len = len + nex[1]:sub(cur[1]):length()
	end

	return len
end

function ground:isPointInWater(point)
	local len = math.abs(topLeftAll.x) - math.abs(topLeft.x)

	if (point.x < topLeft.x) then	
		local perc = math.abs(topLeftAll.x - topLeft.x) / math.abs(topLeftAll.x - topLeft.x)
	end
end

function ground:trimPoints(length)
	if (length > 0) then
		local lastIndex = tableLength(self.emptySpots)
		local secondlastIndex = tableLength(self.emptySpots) - 1
		local last = self.emptySpots[lastIndex][1]
		local secondLast = self.emptySpots[secondlastIndex][1]

		if (last == nil or secondLast == nil) then
			return
		end

		local lastLen = last:sub(secondLast):length()

		if (lastLen == length) then
			table.remove(self.emptySpots, lastIndex)
		elseif (lastLen > length) then
			local toSecond = secondLast:sub(last):normalized()
			self.emptySpots[lastIndex][1] = last:add(toSecond:mul(length))
		elseif (lastLen < length) then
			table.remove(self.emptySpots, lastIndex)
			length = length - lastLen
			self:trimPoints(length)
		end
	end
end

function ground:draw()
	love.graphics.setCanvas(self.canvas)

	love.graphics.push()
	love.graphics.origin()

	local size = self:getSize()

	love.graphics.setBlendMode('alpha')
	local clearMult = 1
	self.canvas:clear(104 * clearMult, 58 * clearMult, 32 * clearMult, 255)

	local darkMul = 0.9
	love.graphics.setColor(104 * darkMul, 58 * darkMul, 32 * darkMul, 255)
	love.graphics.setLineStyle("smooth")

	for i,v in ipairs(self.emptySpots) do
		local cur = v[1]
		local nex = self.emptySpots[i + 1]
		if (nex == nil) then
			break
		end

		love.graphics.setLineWidth(v[2] * 2)
		love.graphics.line(cur.x + size.x / 2 + self.beachWidth, cur.y, nex[1].x + size.x / 2 + self.beachWidth, nex[1].y)
	end

	for i,v in ipairs(self.emptySpots) do
		local cur = v[1]
		love.graphics.circle("fill", v[1].x + size.x / 2 + self.beachWidth, v[1].y, v[2], v[2] / 1.2)
	end

	love.graphics.pop()

	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas, self.topLeftAll.x, self.topLeftAll.y)

	local waterMul = 0.5
	love.graphics.setColor(52 * waterMul, 152 * waterMul, 219 * waterMul)

	-- left water
	love.graphics.polygon("fill",
		self.topLeft.x - self.beachWidth,
		self.topLeft.y,
		self.topLeft.x,
		self.topLeft.y,
		self.topLeft.x - self.beachWidth,
		self.botRight.y)

	-- right water
	love.graphics.polygon("fill",
		self.botRight.x,
		self.topLeft.y,
		self.botRight.x + self.beachWidth,
		self.topLeft.y,
		self.botRight.x + self.beachWidth,
		self.botRight.y)

	-- bedrock
	love.graphics.setColor(50, 50, 50, 255)
	love.graphics.rectangle("fill",
		self.topLeftAll.x,
		self.botRightAll.y - 30,
		self.botRightAll.x - self.topLeftAll.x,
		30)
end