import asin, acos, sqrt, atan2 from math
{ graphics: graphics, keyboard: k, mouse: mouse } = love

Entity = require "entity"

class Player extends Entity
  new: (@world, @x, @y, @sword, @torch=0, @vx=0, @vy=0, @width=32, @height=32) =>
    super @world, @x, @y, @width, @height

    @speed = 1500
    @maxSpeed = 600
    @friction = 1500
    @low = 135
    @directionImage = graphics.newImage "dir.png"

  draw: =>
    graphics.setColor 255, 125, 125
    @sword\draw!
    
    graphics.setColor 125, 255, 125
    graphics.draw @directionImage, @x + @width / 2, @y + @height / 2,
      @sword\getMouseTheta! + math.pi / 2, 1, 1, @width / 2, @height / 2

    graphics.setColor 255, 255, 255
    graphics.rectangle "line", @x, @y, @width, @height

  update: (dt) =>
    @move dt
    @sword\update dt, @getCenter!

    -- print @x, @y
    -- print @sword.x1, @sword.y1

  move: (dt) =>

    -- acceleration
    if k.isDown "a"
      if @vx > 0
        @vx -= @friction * dt
      if @vx < -@maxSpeed
        @vx = -@maxSpeed
      else
        @vx = @vx - @speed * dt
    elseif k.isDown "d"
      if @vx < 0
        @vx += @friction * dt
      if @vx > @maxSpeed
        @vx = @maxSpeed
      else
        @vx = @vx + @speed * dt
    if k.isDown "s"
      if @vy < 0
        @vy += @friction * dt
      if @vy > @maxSpeed
        @vy = @maxSpeed
      else
        @vy = @vy + @speed * dt
    elseif k.isDown "w"
      if @vy > 0
        @vy -= @friction * dt
      if @vy < -@maxSpeed
        @vy = -@maxSpeed
      else
        @vy = @vy - @speed * dt

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

    @x += @vx * dt
    @y += @vy * dt

  getCenter: =>
    return {@x + @width / 2, @y + @height / 2}

  attack: (x, y, button) =>
    @sword\activateAttack x, y, button

return Player