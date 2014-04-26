require("gameobj")
require("vec2")

worm = gameobj();

function worm:init()
	self.pieces = { vec2() }
	self.dir = vec2(1, 0)
	self.maxLength = 100
	self.speed = 160
	self.radius = 8;
	self.rotationSpeed = 300
end

function worm:addPoint(point)
	table.insert(self.pieces, 1, point)

	local over = self:getLength() - self.maxLength

	self:trimPoints(over)
end

function worm:trimPoints(length)
	if (length > 0) then
		local lastIndex = table.getn(self.pieces)
		local secondlastIndex = table.getn(self.pieces) - 1
		local last = self.pieces[lastIndex]
		local secondLast = self.pieces[secondlastIndex]

		if (last == nil or secondLast == nil) then
			return
		end

		local lastLen = last:sub(secondLast):length()

		if (lastLen == length) then
			table.remove(self.pieces, lastIndex)
		elseif (lastLen > length) then
			local toLast = last:sub(secondLast)
			self.pieces[lastIndex] = secondLast:add(toLast:mul(length))
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

function worm:update(dt)
	
end

function worm:tick(step)
	if self:isOverGround() then
		local rot = self.dir:getRotation() + 90
		print(rot)

		local overTurn = 50

		if (rot < 180 and rot > 0) then
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
	love.graphics.setColor(211, 84, 0, 255)

	for k, v in pairs(self.pieces) do
		love.graphics.circle("fill", v.x, v.y, self.radius, self.radius)
	end
end