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

fkge.c('draw', '2d', {})

fkge.c('hitbox', '2d', {
  c = {0, 0, 0},
})

fkge.c('bug', 'draw')

fkge.c('input', {
	mousePressed = 0,
	gx = 120,
	gy = 80,
	gpx = 0,
	gpy = 0,
})

fkge.s('hitbox', function (e)
	lg.push()
	lg.translate(e.x, e.y)
	lg.setColor(e.c)
	lg.rectangle('line', -e.w/2+0.5, -e.h/2+0.5, e.w, e.h)
	lg.pop()
end)

fkge.c('bug', 'draw', {
	life = 1,
	death = 0,
})

local function spawnBug(x, y)
	
end

fkge.s('input', function (e, evt, dt)
	for _, kr in ipairs(evt.keyreleased or {}) do
		if kr == 'escape' then
			love.event.quit()
		end
	end
	if evt.mousepressed then
		e.mousePressed = evt.mousepressed[1][3]
	end
	if evt.mousereleased then
		e.mousePressed = 0
	end
	if e.mousePressed > 0 then
		for _, mr in ipairs(evt.mousemoved or {}) do
			local b = e.mousePressed
			local x, y, dx, dy = unpack(mr)
			spawnBug(x, y, b)
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
			e.gx = (e.gx + e.gpx * dt * 32) % 240
		end
		if e.gpy ~= 0 then
			e.gy = (e.gy + e.gpy * dt * 32) % 160
		end
		spawnBug(e.gx, e.gy, 4)
	end
end)

fkge.scene('game', function ()
	fkge.e('input')
end)

fkge.scene'game'