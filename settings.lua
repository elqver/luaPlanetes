return {
	pointsGeneration = {
		turnedOn = false,
		amount = 30,
		x = { min = -100, max = 100 },
		y = { min = -100, max = 100 },
		mass = { min = 20, max = 20 },
		speed = { min = 0, max = 0 },
	},
	pointsFixed = {},
	simulation = {
		speedUp = 0.001,
		g = 10,
	},
	camera = {
		-- center of camera in metic units
		center = { x = 0, y = 0 },
		-- minimal metric units to be fit by axis
		spread = { x = 2000, y = 2000 },
		-- required portion of free space on every board
		adjPadding = 0.1,
		-- how fast can auto camera move and scale
		-- (according to current spread per second)
		maxAdjPerSec = 0.2,
		-- turn on / off auto camera
		auto = true,
	},
	screen = {
		width = 1920,
		height = 1080,
	},
}
