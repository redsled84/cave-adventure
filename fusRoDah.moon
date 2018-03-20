{graphics: graphics, timer: timer} = love

class FusRoDah
  new: (@world, @x, @y) =>
    @length = 100
    @active = false
    @maxTime = .25
    @time = @maxTime

    @activateCoolDown = false
    @maxCoolDown = 4
    @coolDown = @maxCoolDown
  setPosition: (x, y) =>
    @x, @y = x, y

  update: (dt) =>
    if @active
      @time -= dt
      if @time <= 0
        @time = @maxTime
        @active = false
        @activateCoolDown = true

    if @activateCoolDown
      @coolDown -= dt
      if @coolDown <= 0
        @coolDown = @maxCoolDown
        @activateCoolDown = false


  activate: (key) =>
    if key == "f" and not @active and not @activateCoolDown
      @active = true
      local items, item, len
      items, len = @world\queryRect @x-@length, @y-@length, 2*@length, 2*@length
      for i = 1, len
        item = items[i]
        if item.__class.__name ~= "Player"
          local dt, dx, dy, minVel, multiplier
          dt = timer.getDelta!
          minVel = 200
          multiplier = 100

          dx = (item.x + item.width / 2 - @x)
          dy = (item.y + item.height / 2 - @y)

          dx = dx > 0 and dx + minVel or dx - minVel
          dy = dy > 0 and dy + minVel or dy - minVel
          item.vx = item.vx + dx * multiplier * dt
          item.vy = item.vy + dy * multiplier * dt
          item.hit = true

  draw: =>
    if @active
      graphics.setColor 0, 255, 255, 100
      graphics.rectangle 'fill', @x-@length, @y-@length, 2*@length, 2*@length
