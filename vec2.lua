require("class")
require("utils")

vec2 = class()

function vec2:init(x, y)
	if x == nil then
		self.x = 0
	else
		self.x = x
	end

	if y == nil then
		self.y = 0
	else
		self.y = y
	end
end

function vec2:add(other)
	local newVec = vec2(self.x + other.x, self.y + other.y)
	return newVec
end

function vec2:rotateDegrees(angle)
	angle = degreeToRadian(angle);
	return self:rotateRadians(angle);
end

function vec2:rotateRadians(angle)
	local newVec = vec2(0, 0)
	newVec.x = self.x * math.cos(angle) - self.y * math.sin(angle);
	newVec.y = self.x * math.sin(angle) + self.y * math.cos(angle);
	return newVec;
end

function vec2:normalized()
	local len = self:length()
    return vec2(self.x / len, self.y / len);
end

function vec2:length()
	return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2))
end