Entity = require "entity"

{graphics: graphics, math: m} = love

class SmallEnemy extends Entity
  new: (@world, @x, @y) =>
    local num
    num = m.random(1,2)
    @width, @height = 16 * num, 16 * num

    super @world, @x, @y, @width, @height

    @speed = m.random(90, 160)
    @vx = 0
    @vy = 0
    @low = 10
    @friction = 200
    @damage = @width * @height / 50

  update: (dt, playerCenter) =>
    @move dt, playerCenter
    @handleCollision dt

  move: (dt, playerCenter) =>
    local x, y, dist, dx, dy, directionX, directionY
    if not @hit and not @touchingEnemies and not @touchingPlayer
      x, y = playerCenter[1], playerCenter[2]
      dx = x - @x
      dy = y - @y
      dist = math.sqrt((dx)^2 + (dy)^2)

      directionX = dx / dist
      directionY = dy / dist
      @vx, @vy = directionX * @speed, directionY * @speed
    else
      if @vx > 0 and @vx > @low
        @vx -= @friction * dt
      elseif @vx < 0 and @vx < -@low
        @vx += @friction * dt
      else
        @vx = 0

      if @vy > 0 and @vy > @low
        @vy -= @friction * dt
      elseif @vy < 0 and @vy < -@low
        @vy += @friction * dt
      else
        @vy = 0

      if @vx == 0 or @vy == 0
        @hit = false

  handleCollision: (dt) =>
    super dt, (col) ->
      if col.other.__class.__name == "Player"
        col.other.health -= @damage * dt

  draw: =>
    graphics.push!
    graphics.translate @x + @width / 2, @y + @height / 2
    graphics.rotate (@x / 100 % math.pi)
    graphics.setColor 200, 0, 145
    graphics.translate -@x - @width / 2, -@y - @height / 2
    graphics.rectangle "line", @x, @y, @width, @height, 3
    graphics.pop!
