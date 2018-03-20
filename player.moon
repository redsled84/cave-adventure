import asin, acos, sqrt, atan2 from math
{ graphics: graphics, keyboard: k, mouse: mouse } = love

Entity = require "entity"
FusRoDah = require "fusRoDah"

class Player extends Entity
  new: (@world, @x, @y, @sword, @torch=0, @vx=0, @vy=0, @width=32, @height=32) =>
    super @world, @x, @y, @width, @height

    @fusRoDah = FusRoDah @world, @x, @y
    @speed = 1500
    @maxSpeed = 600
    @friction = 1500
    @low = 135
    @directionImage = graphics.newImage "dir.png"

  update: (dt) =>
    @move dt
    @handleCollision dt
    @sword\update dt, @getCenter!
    @fusRoDah\update dt
    @fusRoDah\setPosition @x + @width / 2, @y + @height / 2
    @manipulateHits dt

  manipulateHits: (dt) =>
    local items, len
    items, len = @world\querySegment @sword.x1, @sword.y1, @sword.x2, @sword.y2
    for i = 1, len
      local item, dx, dy
      item = items[i]
      if i > 1 and not item.hit and @sword.active
        local minVel, multiplier
        minVel = 200
        multiplier = 100
        dx = (item.x + item.width / 2 - @sword.x1)
        dy = (item.y + item.height / 2 - @sword.y1)

        dx = dx > 0 and dx + minVel or dx - minVel
        dy = dy > 0 and dy + minVel or dy - minVel

        item.vx = item.vx + dx * multiplier * dt
        item.vy = item.vy + dy * multiplier * dt
        item.health -= @sword.damage

      item.hit = i > 1

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

  handleCollision: (dt) =>
    super dt, (col) ->
      if col.other.__class.__name == "SmallEnemy"
        col.other.vx = col.normal.x ~= 0 and @vx * col.normal.x or col.other.vx
        col.other.vy = col.normal.y ~= 0 and @vy * col.normal.y or col.other.vy

  draw: =>
    graphics.setColor 255, 125, 125
    @sword\draw!
    @fusRoDah\draw!
    
    graphics.setColor 10, 10, 10
    graphics.rectangle "fill", @x, @y, @width, @height, 6

    graphics.setColor 125, 255, 125
    graphics.draw @directionImage, @x + @width / 2, @y + @height / 2,
      @sword\getMouseTheta! + math.pi / 2, 1, 1, @width / 2, @height / 2


  getCenter: =>
    return {@x + @width / 2, @y + @height / 2}

  attack: (key) =>
    @sword\activateAttack key
    @fusRoDah\activate key

return Player