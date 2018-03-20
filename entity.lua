local graphics
graphics = love.graphics
local collisionFilter
collisionFilter = function(item, other)
  if item.__class.__name == "Player" and other.__class.__name == "SmallEnemy" then
    return "cross"
  end
  if item.__class.__name == "SmallEnemy" and other.hit then
    return "cross"
  end
  return "slide"
end
local Entity
do
  local _class_0
  local _base_0 = {
    handleCollision = function(self, dt, f)
      local futureX, futureY, nextX, nextY, cols, col, len
      futureX, futureY = self.x + self.vx * dt, self.y + self.vy * dt
      if futureX < 0 then
        futureX = 0
      elseif futureX + self.width > graphics.getWidth() then
        futureX = graphics.getWidth() - self.width
      end
      if futureY < 0 then
        futureY = 0
      elseif futureY + self.height > graphics.getHeight() then
        futureY = graphics.getHeight() - self.height
      end
      nextX, nextY, cols, len = self.world:move(self, futureX, futureY, collisionFilter)
      if f then
        for i = 1, len do
          col = cols[i]
          f(col)
        end
      end
      self.x = nextX
      self.y = nextY
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, world, x, y, width, height)
      self.world, self.x, self.y, self.width, self.height = world, x, y, width, height
      self.hit = false
      self.maxHealth = 100
      self.health = self.maxHealth
      return self.world:add(self, self.x, self.y, self.width, self.height)
    end,
    __base = _base_0,
    __name = "Entity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Entity = _class_0
end
return Entity
