import sin, cos, atan2 from math

{mouse: mouse, graphics: graphics} = love

class Sword
  new: (@x1=0, @y1=0, @x2=0, @y2=0) =>
    -- Polar constants
    @deltaTheta = 0
    @minTheta = -4 * math.pi / 3
    @theta = 0
    @thetaStep = math.pi * 4
    @offsetTheta = 2 * math.pi / 3
    @maxRadius = 100
    @minRadius = 25
    @radius = @maxRadius
    @radiusStep = 4

    @active = false

  update: (dt, playerPos) =>
    @setPosition dt, playerPos
    if @active
      @controlPolar dt

    -- print @radius

  getMouseTheta: =>
    local mouseTheta, mouseX, mouseY
    mouseX = mouse.getX!
    mouseY = mouse.getY!
    local dx, dy
    dx = mouseX - @x1
    dy = mouseY - @y1
    -- print dx, dy
    return atan2(dy, dx)

  setPosition: (dt, playerPos) =>
    @x1 = playerPos[1]
    @y1 = playerPos[2]

    if not @active
      local mouseTheta
      -- print dx, dy
      mouseTheta = @getMouseTheta!
      -- mouseTheta = 0

      @x2 = @radius * cos(@theta + mouseTheta + @offsetTheta) + @x1
      @y2 = @radius * sin(@theta + mouseTheta + @offsetTheta) + @y1
    else
      @x2 = @radius * cos(@theta + @offsetTheta) + @x1
      @y2 = @radius * sin(@theta + @offsetTheta) + @y1

  controlPolar: (dt) =>
    if @theta > @deltaTheta
      @theta -= @thetaStep * dt

      if @radius > @minRadius
        @radius -= @radiusStep * dt
      else
        @radius = @minRadius
    else
      @theta = 0
      @active = false

  getTheta: =>
    return not @active and @theta + @getMouseTheta! + @offsetTheta or @theta + @offsetTheta

  draw: =>
    graphics.line @x1, @y1, @x2, @y2

  activateAttack: (x, y, button) =>
    if button == 1 and not @active
      @active = true
      local dx, dy
      dx = x - @x1
      dy = y - @y1

      @theta = atan2(dy, dx)
      @deltaTheta = @minTheta + @theta
      @radius = @maxRadius

return Sword