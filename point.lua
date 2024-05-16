local settings = require("settings")

---@class (exect) Speed
---@field x number
---@field y number

---@class (exect) Point
---@field x number
---@field y number
---@field speed Speed
---@field mass number
local point = { all = {} }
point.__index = point

---@param pos table
---@param mass number
---@param speed table
function point:new(pos, mass, speed)
	local newObj = {
		x = pos.x,
		y = pos.y,
		mass = mass,
		speed = { x = speed.x, y = speed.y },
	}
	table.insert(self.all, newObj)
	setmetatable(newObj, self)
	return newObj
end

---@return number
function point:getRadius()
	return ((self.mass * 3) / (math.pi * 4)) ^ (1 / 3)
end

---@param p1 Point
---@param p2 Point
---@return boolean
local function shouldCollapse(p1, p2)
	local limitDist = p1:getRadius() + p2:getRadius()
	return ((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2) ^ 0.5 <= limitDist
end

---@param dt number
function point:update(dt)
	dt = dt * settings.simulation.speedUp
	for i, p in pairs(self.all) do
		if self ~= p then
			if shouldCollapse(self, p) then
				self.x = (self.mass * self.x + p.mass * p.x) / (self.mass + p.mass)
				self.y = (self.mass * self.y + p.mass * p.y) / (self.mass + p.mass)
				self.mass = self.mass + p.mass
				table.remove(self.all, i)
			else
				local r = { x = p.x - self.x, y = p.y - self.y }
				local d = math.max(math.sqrt(r.x ^ 2 + r.y ^ 2), 10)
				local f = p.mass * settings.simulation.g / (d ^ 3)
				self.speed.x = self.speed.x + f * r.x * dt / d
				self.speed.y = self.speed.y + f * r.y * dt / d
			end
		end
	end
	self.x = self.x + self.speed.x * dt
	self.y = self.y + self.speed.y * dt
end

function point.generatePointsSimple()
	local setup = settings.pointsGeneration
	for _ = 1, setup.amount do
		local pos = {
			x = math.random(setup.x.min, setup.x.max),
			y = math.random(setup.y.min, setup.y.max),
		}
		local mass = math.random(setup.mass.min, setup.mass.max)
		local speed = {
			x = math.random(setup.speed.min, setup.speed.max),
			y = math.random(setup.speed.min, setup.speed.max),
		}
		point:new(pos, mass, speed)
	end
end

return point
