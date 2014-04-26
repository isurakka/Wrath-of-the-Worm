require("gameobj")
require("vec2")

worm = gameobj();

function worm:init(pos)
	self.pieces = { }
	self.dir = vec2(1, 0)
	self.maxLength = 100
	self.speed = 160
	self.radius = 6;
	self.rotationSpeed = 300
	self.onPointAdd = nil

	self:addPoint(pos)
end

function worm:addPoint(point)
	local last = self.pieces[1]
	local secondLast = self.pieces[2]

	local dot
	if (last ~= nil and secondLast ~= nil) then
		dot = last:sub(secondLast):normalized():dot(point:sub(last):normalized())
	end

	if (dot ~= nil and dot >= 0.999) then
		self.pieces[1] = point
	else
		table.insert(self.pieces, 1, point)
	end

	local over = self:getLength() - self.maxLength

	self:trimPoints(over)

	if (self.onPointAdd ~= nil) then
		self.onPointAdd(point)
	end
end

function worm:trimPoints(length)
	if (length > 0) then
		local lastIndex = tableLength(self.pieces)
		local secondlastIndex = tableLength(self.pieces) - 1
		local last = self.pieces[lastIndex]
		local secondLast = self.pieces[secondlastIndex]

		if (last == nil or secondLast == nil) then
			return
		end

		local lastLen = last:sub(secondLast):length()

		if (lastLen == length) then
			table.remove(self.pieces, lastIndex)
		elseif (lastLen > length) then
			local toSecond = secondLast:sub(last):normalized()
			self.pieces[lastIndex] = last:add(toSecond:mul(length))
		elseif (lastLen < length) then
			table.remove(self.pieces, lastIndex)
			length = length - lastLen
			self:trimPoints(length)
		end
	end
end

function worm:getLength()
	local len = 0
	for i,v in ipairs(self.pieces) do
		local cur = v
		local nex = self.pieces[i + 1]
		if (nex == nil) then
			break
		end

		len = len + nex:sub(cur):length()
	end

	return len
end

function worm:isOverGround()
	return self.pieces[1].y < 0
end

function worm:getHead()
	return self.pieces[1]
end

function worm:update(dt)
	
end

function worm:tick(step)
	if self:isOverGround() then
		local rot = self.dir:getRotation() + 90

		local overTurn = 50

		if (rot <= 180 and rot >= 0) then
			self.dir = self.dir:rotateDegrees(1 * overTurn * step)
		elseif (rot < 0 or rot > 180) then
			self.dir = self.dir:rotateDegrees(-1 * overTurn * step)
		end

		--print(((self.dir:dot(vec2(0, 1) + 1))))
		--self.dir = self.dir:rotateDegrees(200 * ((self.dir:dot(vec2(0, 1) + 1) / 2)) * step)
	end

	local last = self.pieces[1]
	local new = last:add(vec2(
		self.dir.x * self.speed * step, 
		self.dir.y * self.speed * step))

	self:addPoint(new)
end

function worm:draw()
	love.graphics.setColor(22, 160, 133, 255)
	love.graphics.setLineWidth(self.radius * 2)
	love.graphics.setLineStyle("smooth")

	for i,v in ipairs(self.pieces) do
		local nex = self.pieces[i + 1]
		if (nex == nil) then
			break
		end

		love.graphics.line(v.x, v.y, nex.x, nex.y)
	end

	for k, v in pairs(self.pieces) do
		love.graphics.circle("fill", v.x, v.y, self.radius, self.radius * 2)
	end
end