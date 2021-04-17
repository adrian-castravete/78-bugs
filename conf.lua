function love.conf(t)
  t.identity = 'fkge-78-bugs'
  t.version = '11.1'
  t.accelerometerjoystick = false
  t.externalstorage = true
  t.gammacorrect = true

  local w = t.window
  w.title = "Bugs - MiniJam 78"
  w.icon = nil
  w.width = 720
  w.height = 480
  w.minwidth = 240
  w.minheight = 160
  w.resizable = true
  w.fullscreentype = 'desktop'
  w.fullscreen = false
  w.usedpiscale = false
  w.hidpi = true
end
