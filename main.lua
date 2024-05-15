local point = require("point")
local camera = require("camera")
local settings = require("settings")

function love.keypressed(key)
	if key == "=" then
		print("PLUS PRESSED")
		camera:zoom(0.9)
	end
	if key == "-" then
		print("MINUS PRESSED")
		camera:zoom(1.1)
	end
	if key == "right" then
		camera:move(0.1, 0)
	end
	if key == "left" then
		camera:move(-0.1, 0)
	end
	if key == "down" then
		camera:move(0, 0.1)
	end
	if key == "up" then
		camera:move(0, -0.1)
	end
end

function love.load()
	local gen = settings.pointsGeneration
	if gen.turnedOn then
		point.createPoints()
	end
	point:new({ x = 0, y = 0 }, 1000, { x = 0, y = 0 })
	point:new({ x = -50, y = 0 }, 20000, { x = 0, y = -2 })
	point:new({ x = 500, y = 0 }, 50, { x = 0, y = 2 })
	point:new({ x = 0, y = -50 }, 50, { x = 2, y = 0 })
	point:new({ x = 0, y = 300 }, 50, { x = -2, y = 0 })

	love.window.setMode(settings.screen.width, settings.screen.height)
end

function love.update(dt)
	print(dt)
	for _, p in pairs(point.all) do
		p:update(dt)
	end
	if settings.camera.auto then
		camera:adjust(point.all, dt)
	end
end

function love.draw()
	local t = camera:getTrans(love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.scale(t.scale)
	love.graphics.translate(t.translateX, t.translateY)
	love.graphics.setColor(255, 0, 0)
	for _, p in pairs(point.all) do
		love.graphics.circle("fill", p.x, p.y, p:getRadius())
	end
end
