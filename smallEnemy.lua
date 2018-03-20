local Entity = require("entity")
local graphics, m
do
  local _obj_0 = love
  graphics, m = _obj_0.graphics, _obj_0.math
end
local SmallEnemy
do
  local _class_0
  local _parent_0 = Entity
  local _base_0 = {
    update = function(self, dt, playerCenter)
      self:move(dt, playerCenter)
      return self:handleCollision(dt)
    end,
    move = function(self, dt, playerCenter)
      local x, y, dist, dx, dy, directionX, directionY
      if not self.hit and not self.touchingEnemies and not self.touchingPlayer then
        x, y = playerCenter[1], playerCenter[2]
        dx = x - self.x
        dy = y - self.y
        dist = math.sqrt((dx) ^ 2 + (dy) ^ 2)
        directionX = dx / dist
        directionY = dy / dist
        self.vx, self.vy = directionX * self.speed, directionY * self.speed
      else
        if self.vx > 0 and self.vx > self.low then
          self.vx = self.vx - (self.friction * dt)
        elseif self.vx < 0 and self.vx < -self.low then
          self.vx = self.vx + (self.friction * dt)
        else
          self.vx = 0
        end
        if self.vy > 0 and self.vy > self.low then
          self.vy = self.vy - (self.friction * dt)
        elseif self.vy < 0 and self.vy < -self.low then
          self.vy = self.vy + (self.friction * dt)
        else
          self.vy = 0
        end
        if self.vx == 0 or self.vy == 0 then
          self.hit = false
        end
      end
    end,
    handleCollision = function(self, dt)
      return _class_0.__parent.__base.handleCollision(self, dt, function(col)
        if col.other.__class.__name == "Player" then
          col.other.health = col.other.health - (self.damage * dt)
        end
      end)
    end,
    draw = function(self)
      graphics.push()
      graphics.translate(self.x + self.width / 2, self.y + self.height / 2)
      graphics.rotate((self.x / 100 % math.pi))
      graphics.setColor(200, 0, 145)
      graphics.translate(-self.x - self.width / 2, -self.y - self.height / 2)
      graphics.rectangle("line", self.x, self.y, self.width, self.height, 3)
      return graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, world, x, y)
      self.world, self.x, self.y = world, x, y
      local num
      num = m.random(1, 2)
      self.width, self.height = 16 * num, 16 * num
      _class_0.__parent.__init(self, self.world, self.x, self.y, self.width, self.height)
      self.speed = m.random(90, 160)
      self.vx = 0
      self.vy = 0
      self.low = 10
      self.friction = 200
      self.damage = self.width * self.height / 50
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
