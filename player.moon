{ graphics: graphics, keyboard: k } = love

Entity = require "entity"

class Player extends Entity
  new: (@world, @x, @y, @sword, @torch=0, @vx=0, @vy=0, @width=32, @height=32) =>
    super @world, @x, @y, @width, @height

    @speed = 50
    @maxSpeed = 6
    @friction = 50
    @low = 1.2

  draw: =>
    graphics.rectangle "line", @x, @y, @width, @height
    @sword\draw!

  update: (dt) =>
    @move dt
    @sword\update dt, @getCenter!

    -- print @vx, @vy
    -- print @sword.x1, @sword.y1

  move: (dt) =>

    -- acceleration
    if k.isDown "a"
      @vx = @vx - @speed * dt
      if @vx < -@maxSpeed
        @vx = -@maxSpeed
    elseif k.isDown "d"
      @vx = @vx + @speed * dt
      if @vx > @maxSpeed
        @vx = @maxSpeed
    if k.isDown "s"
      @vy = @vy + @speed * dt
      if @vy > @maxSpeed
        @vy = @maxSpeed
    elseif k.isDown "w"
      @vy = @vy - @speed * dt
      if @vy < -@maxSpeed
        @vy = -@maxSpeed

    -- deceleration
    if not k.isDown("a") and not k.isDown("d")
      if @vx > 0 and @vx > @low
        @vx -= @friction * dt
      elseif @vx < 0 and @vx < -@low
        @vx += @friction * dt
      else
        @vx = 0
    if not k.isDown("s") and not k.isDown("w")
      if @vy > 0 and @vy > @low
        @vy -= @friction * dt
      elseif @vy < 0 and @vy < -@low
        @vy += @friction * dt
      else
        @vy = 0

    @x += @vx
    @y += @vy

  getCenter: =>
    return {@x + @width / 2, @y + @height / 2}

  attack: (x, y, button) =>
    @sword\activateAttack x, y, button

return Player