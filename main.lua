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

fkge.c('input', {})

fkge.s('input', function (e, evt)
	if evt.keyreleased then
		if evt.keyreleased[1] == 'escape' then
			love.event.quit()
		end
	end
end)

fkge.scene('game', function ()
	fkge.e('input')
end)

fkge.scene'game'

