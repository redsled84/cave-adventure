local Entity = require("entity")
local graphics
graphics = love.graphics
local SmallEnemy
do
  local _class_0
  local _parent_0 = Entity
  local _base_0 = {
    update = function(self, dt, playerCenter)
      return self:move(dt, playerCenter)
    end,
    move = function(self, dt, playerCenter)
      local x, y, dist, dx, dy, directionX, directionY
      x, y = playerCenter[1], playerCenter[2]
      dx = x - self.x
      dy = y - self.y
      dist = math.sqrt((dx) ^ 2 + (dy) ^ 2)
      directionX = dx / dist
      directionY = dy / dist
      local futureX, futureY, nextX, nextY, cols, len
      futureX, futureY = self.x + directionX * self.speed * dt, self.y + directionY * self.speed * dt
      nextX, nextY, cols, len = self.world:move(self, futureX, futureY)
      self.x = nextX
      self.y = nextY
    end,
    draw = function(self)
      graphics.setColor(255, 0, 0)
      return graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, world, x, y, width, height, damage)
      if width == nil then
        width = 4
      end
      if height == nil then
        height = 4
      end
      if damage == nil then
        damage = 10
      end
      self.world, self.x, self.y, self.width, self.height, self.damage = world, x, y, width, height, damage
      _class_0.__parent.__init(self, self.world, self.x, self.y, self.width, self.height)
      self.speed = 200
      self.vx = 0
      self.vy = 0
    end,
    __base = _base_0,
    __name = "SmallEnemy",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  SmallEnemy = _class_0
  return _class_0
end
