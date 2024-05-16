-- TODO

local init = require("settings").camera

---@alias unit number
---@alias px number

---@class BoundBox
---@field left integer
---@field right integer
---@field top integer
---@field bottom integer

---@class Camera
---@field boundBox BoundBox
---@field auto boolean
local camera = {
	boundBox = { left = init.left, right = init.right, top = init.top, bottom = init.bottom },
	auto = init.auto,
}

---@class CameraTranslation
---@field translateX unit
---@field translateY unit
---@field scale number

---@param screenWidth px
---@param screenHeight px
---@return CameraTranslation
function camera:getTrans(screenWidth, screenHeight)
	-- unit / px
	local scale = math.max(
		(self.boundBox.right - self.boundBox.left) / screenWidth,
		(self.boundBox.top - self.boundBox.bottom) / screenHeight
	)

	-- u stands for uint here
	local uCameraCenterX = (self.boundBox.left + self.boundBox.right) / 2
	local uCameraCenterY = (self.boundBox.top + self.boundBox.bottom) / 2
	local uCameraWidth = self.boundBox.right - self.boundBox.left
	local uScreenWidth = screenWidth * scale
	local uCameraHeight = self.boundBox.top - self.boundBox.bottom
	local uScreenHeight = screenHeight * scale

	local translateX = -(self.boundBox.left - (uScreenWidth - uCameraWidth) / 2)
	local translateY = -(self.boundBox.bottom - (uScreenHeight - uCameraHeight) / 2)

	---@type CameraTranslation
	return { scale = scale, translateX = translateX, translateY = translateY }
end

---@return string
function camera:repr()
	return string.format(
		"\
\t\t\ttop=%d\n\
Camera: left=%d\t\t\tright=%d\n\
\t\t\tbottom=%d\n\
",
		self.boundBox.top,
		self.boundBox.left,
		self.boundBox.right,
		self.boundBox.bottom
	)
end

---@param value number
--- 0.1 - zoom out expanding scpoe
--- -0.1 - zoom in reduce scpoe
function camera:zoom(value)
	local xDiff = (self.boundBox.right - self.boundBox.left) * value / 2
	self.boundBox.left = self.boundBox.left - xDiff
	self.boundBox.right = self.boundBox.right + xDiff

	local yDiff = (self.boundBox.top - self.boundBox.bottom) * value / 2
	self.boundBox.bottom = self.boundBox.bottom - yDiff
	self.boundBox.top = self.boundBox.top + yDiff

	self.auto = false
end

---@param xMove number
---@param yMove number
function camera:move(xMove, yMove)
	---@type unit
	local dx = (self.boundBox.right - self.boundBox.left) * xMove
	---@type unit
	local dy = (self.boundBox.top - self.boundBox.bottom) * yMove

	self.boundBox.top = self.boundBox.top + dy
	self.boundBox.bottom = self.boundBox.bottom + dy
	self.boundBox.left = self.boundBox.left + dx
	self.boundBox.right = self.boundBox.right + dx

	self.auto = false
end

---@param points table
---@return BoundBox
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
	self.boundBox = getBorders(points)
end

return camera
