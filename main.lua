lg = love.graphics
fkge = require'fkge'

fkge.game {
	width = 240,
	height = 160,
	background = {0, 0, 1/3},
}

fkge.c('2d', {
	x = 0,
	y = 0,
	w = 8,
	h = 8,
})

fkge.c('draw', '2d', {
	tick = 0,
	sprite = nil,
	quad = nil,
	quadName = nil,
	alpha = 1,
})

fkge.c('hitbox', '2d', {
  c = {0, 0, 0},
})

local function bugSprite()
	local qg = {}

	for i, n in ipairs {'w', 'nw', 'n', 'ne', 'e', 'se', 's', 'sw'} do
		qg[n] = {
			x = 16 * (i - 1),
			y = 0,
			w = 8,
			h = 8,
			c = 2,
			n = 2,
		}
	end

	return fkge.spr {
		fileName = "assets/bugs.png",
		quadGen = qg,
	}
end

fkge.c('bug', 'draw', {
	life = 1,
	sprite = bugSprite(),
})

fkge.c('player', 'input, draw', {
	x = 120,
	y = 80,
	w = 16,
	h = 16,
	gpx = 0,
	gpy = 0,
	deploy = false,
	gid = nil,
	gbtn = nil,
	sprite = fkge.spr {
		fileName = "assets/player.png",
		quadGen = {
			off = {
				x = 0,
				y = 0,
				w = 16,
				h = 16,
				c = 2,
				n = 2,
			},
			on = {
				x = 0,
				y = 16,
				w = 16,
				h = 16,
				c = 2,
				n = 2,
			},
		}
	},
	quadName = 'off',
	quadSpeed = 4,
})

fkge.s('draw', function (e)
	if not e.sprite then return end

	e.tick = e.tick + 1
	if not e.quadIndex then
		e.quadIndex = 0
	end
	if e.quadSpeed then
		if e.tick >= e.quadSpeed then
			e.quadIndex = e.quadIndex + 1
			e.tick = 0
		end
	end

	local w, h = e.w / 2, e.h / 2

	lg.push()
	lg.translate(math.floor(e.x), math.floor(e.y))
	local quads = nil
	if e.quadName and e.sprite.quads then
		quads = e.sprite.quads[e.quadName]
	elseif e.quad then
		quads = e.quad
		lg.draw(e.sprite.image, e.quad, -w, -h)
	end
	local quad = nil
	if quads then
		quad = quads[(e.quadIndex % #quads) + 1]
	end
	lg.setColor(1, 1, 1, e.alpha)
	if quad then
		lg.draw(e.sprite.image, quad, -w, -h)
	else
		lg.draw(e.sprite.image, -w, -h)
	end
	lg.pop()
end)

fkge.s('hitbox', function (e)
	lg.push()
	lg.translate(e.x, e.y)
	lg.setColor(e.c)
	lg.rectangle('line', -e.w/2+0.5, -e.h/2+0.5, e.w, e.h)
	lg.pop()
end)

local qs = {'se', 's', 'sw', 'w', 'nw', 'n', 'ne', 'e'}
local function spawnBug(x, y)
	local a = math.random() * math.pi * 2
	local q = math.floor(4 * a / math.pi + 0.5)
	if q < 1 then
		q = 8
	end
	local bug = fkge.e('bug').attr {
		x = x,
		y = y,
		quadName = qs[q],
	}
	fkge.anim(bug, 'life', 0, 5 * math.random(), function (ov)
		local v = (1 - ov)
		bug.x = bug.x + math.cos(a) * v * 0.5
		bug.y = bug.y + math.sin(a) * v * 0.5
		return ov
	end, function (e)
		fkge.anim(bug, 'alpha', 0, 1, nil, function (e)
			e.destroy = true
		end)
	end)
end

fkge.s('input', function (e, evt, dt)
	for _, kr in ipairs(evt.keyreleased or {}) do
		if kr == 'escape' then
			love.event.quit()
		end
	end

	for _, g in ipairs(evt.joystickpressed or {}) do
		local gid, b = unpack(g)
		if not e.gid then
			e.gid = gid
		end
		if gid == e.gid then
			if not e.gbtn then
				e.gbtn = b
			end
			if e.gbtn == b then
				e.deploy = true
			end
		end
	end

	for _, g in ipairs(evt.joystickreleased or {}) do
		local gid, b = unpack(g)
		if e.gid == gid and e.gbtn == b then
			e.deploy = false
		end
	end

	for _, g in ipairs(evt.joystickaxis or {}) do
		local gid, a, v = unpack(g)
		if a == 1 then
			e.gpx = v
		end
		if a == 2 then
			e.gpy = v
		end
	end

	if e.gpx ~= 0 or e.gpy ~= 0 then
		if e.gpx ~= 0 then
			e.x = (e.x + e.gpx * dt * 32) % 240
		end
		if e.gpy ~= 0 then
			e.y = (e.y + e.gpy * dt * 32) % 160
		end
	end
end)

fkge.s('player', function (e)
	if e.deploy then
		spawnBug(e.x, e.y, 4)
	end
end)

fkge.scene('game', function ()
	fkge.e('player')
end)

fkge.scene'game'
