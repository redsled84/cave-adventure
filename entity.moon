{graphics: graphics} = love

collisionFilter = (item, other) ->
  if item.__class.__name == "Player" and other.__class.__name == "SmallEnemy"
    return "cross"
  if item.__class.__name == "SmallEnemy" and other.hit
    return "cross"
  return "slide"

class Entity
  new: (@world, @x, @y, @width, @height) =>
    @hit = false
    @maxHealth = 100
    @health = @maxHealth
    @world\add self, @x, @y, @width, @height

  handleCollision: (dt, f) =>
    local futureX, futureY, nextX, nextY, cols, col, len
    futureX, futureY = @x + @vx * dt, @y + @vy * dt

    if futureX < 0
      futureX = 0
    elseif futureX + @width > graphics.getWidth!
      futureX = graphics.getWidth! - @width

    if futureY < 0
      futureY = 0
    elseif futureY + @height > graphics.getHeight!
      futureY = graphics.getHeight! - @height

    nextX, nextY, cols, len = @world\move self, futureX, futureY, collisionFilter

    if f
      for i = 1, len
        col = cols[i]
        f col

    @x = nextX
    @y = nextY

return Entity