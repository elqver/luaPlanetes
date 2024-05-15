-- TODO
-- Automaticly return to auto adjusting on timeout
-- Add rotation
-- Add position saving
-- Add point of interest systems
-- Add second auto mode based on masses

local init = require("settings").camera

local camera = {
	-- center in units
	center = { x = init.center.x, y = init.center.y },
	-- amount of units per axis on the screen
	spread = { x = init.spread.x, y = init.spread.y },
	auto = init.auto,
}

function camera:getTrans(screenWidth, screenHeight)
	local res = { scale = math.min(screenWidth / self.spread.x, screenHeight / self.spread.y) }
	--
	--		  |This is self.spread.x|
	--	|---------|---------------------|---------|
	--	|------This is real amount of units-------|
	-- scale = px / units
	-- real amount of uinits = screenWidth / scale

	res.translateX = self.center.x - (self.spread.x - screenWidth / res.scale) / 2
	res.translateY = self.center.y - (self.spread.y - screenHeight / res.scale) / 2
	print("spread = ", self.spread.x, ", ", self.spread.y)
	print("screen = ", screenWidth, ", ", screenHeight)
	print("Scale = ", res.scale)
	print("translate = ", res.translateX, ", ", res.translateY)
	return res
end

function camera:zoom(value)
	init.auto = false
	self.spread = {
		x = self.spread.x * value,
		y = self.spread.y * value,
	}
	self.auto = false
end

function camera:move(x, y)
	init.auto = false
	self.center.x = self.center.x + self.spread.x * x
	self.center.y = self.center.y + self.spread.y * y
	self.auto = false
end

local function getBorders(points)
	local res = {
		left = math.huge,
		right = -math.huge,
		bottom = math.huge,
		top = -math.huge,
	}
	for _, p in pairs(points) do
		res.left = math.min(res.left, p.x)
		res.right = math.max(res.right, p.x)
		res.bottom = math.min(res.bottom, p.y)
		res.top = math.max(res.top, p.y)
	end
	return res
end

function camera:adjust(points, dt)
	local desiredBorders = getBorders(points)
	self.spread = {
		x = desiredBorders.right - desiredBorders.left,
		y = desiredBorders.top - desiredBorders.bottom,
	}
	self.center = {
		x = (desiredBorders.right - desiredBorders.left) / 2,
		y = (desiredBorders.top - desiredBorders.bottom) / 2,
	}
end

return camera
