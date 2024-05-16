return {
	pointsGeneration = {
		turnedOn = true,
		amount = 30,
		x = { min = -100, max = 100 },
		y = { min = -100, max = 100 },
		mass = { min = 20, max = 20 },
		speed = { min = 0, max = 0 },
	},
	pointsFixed = {},
	simulation = {
		speedUp = 1,
		g = 10,
	},
	camera = {
		left = -500,
		right = -500,
		top = -500,
		bottom = -500,
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
