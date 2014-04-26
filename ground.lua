require("gameobj")
require("vec2")

ground = gameobj();

function ground:init(size)
	self.topLeft = vec2(-size.x / 2, 0)
	self.botRight = vec2(size.x / 2, size.y)
	self.emptySpots = { }
	self.canvas = love.graphics.newCanvas(size.x, size.y)
	self.maxEmptyLength = 3000
end

function ground:getSize()
	return vec2(self.botRight.x - self.topLeft.x,
		self.botRight.y - self.topLeft.y)
end

function ground:addPoint(point, radius)
	table.insert(self.emptySpots, 1, { point, radius })
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

	self.canvas:clear(135, 72, 33, 255)
	--love.graphics.setBlendMode('alpha')

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
		love.graphics.line(cur.x + size.x / 2, cur.y, nex[1].x + size.x / 2, nex[1].y)
		love.graphics.circle("fill", v[1].x + size.x / 2, v[1].y, v[2], v[2] / 2)
	end

	love.graphics.pop()

	love.graphics.setCanvas()

	love.graphics.draw(self.canvas, self.topLeft.x, self.topLeft.y)
end