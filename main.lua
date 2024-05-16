local point = require("point")
local camera = require("camera")
local settings = require("settings")

function love.keypressed(key)
	local actions = {
		["="] = function()
			camera:zoom(0.1)
		end,
		["-"] = function()
			camera:zoom(-0.1)
		end,
		["right"] = function()
			camera:move(0.1, 0)
		end,
		["left"] = function()
			camera:move(-0.1, 0)
		end,
		["down"] = function()
			camera:move(0, 0.1)
		end,
		["up"] = function()
			camera:move(0, -0.1)
		end,
		["a"] = function()
			camera.auto = true
		end,
	}
	actions[key]()
end

function love.load()
	local gen = settings.pointsGeneration
	if gen.turnedOn then
		point.generatePointsSimple()
	end
	love.window.setMode(settings.screen.width, settings.screen.height)
end

function love.update(dt)
	-- print(dt)
	for _, p in pairs(point.all) do
		p:update(dt)
	end
	if camera.auto then
		camera:adjust(point.all, dt)
	end
end

function love.draw()
	local t = camera:getTrans(love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.scale(1 / t.scale)
	love.graphics.translate(t.translateX, t.translateY)
	love.graphics.setColor(255, 0, 0)
	for _, p in pairs(point.all) do
		love.graphics.circle("fill", p.x, p.y, p:getRadius())
	end
end
