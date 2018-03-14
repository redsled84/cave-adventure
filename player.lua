local graphics, k
do
  local _obj_0 = love
  graphics, k = _obj_0.graphics, _obj_0.keyboard
end
local Entity = require("entity")
local Player
do
  local _class_0
  local _parent_0 = Entity
  local _base_0 = {
    draw = function(self)
      graphics.rectangle("line", self.x, self.y, self.width, self.height)
      return self.sword:draw()
    end,
    update = function(self, dt)
      self:move(dt)
      return self.sword:update(dt, self:getCenter())
    end,
    move = function(self, dt)
      if k.isDown("a") then
        if self.vx > 0 then
          self.vx = self.vx - (self.friction * dt)
        end
        if self.vx < -self.maxSpeed then
          self.vx = -self.maxSpeed
        else
          self.vx = self.vx - self.speed * dt
        end
      elseif k.isDown("d") then
        if self.vx < 0 then
          self.vx = self.vx + (self.friction * dt)
        end
        if self.vx > self.maxSpeed then
          self.vx = self.maxSpeed
        else
          self.vx = self.vx + self.speed * dt
        end
      end
      if k.isDown("s") then
        if self.vy < 0 then
          self.vy = self.vy + (self.friction * dt)
        end
        if self.vy > self.maxSpeed then
          self.vy = self.maxSpeed
        else
          self.vy = self.vy + self.speed * dt
        end
      elseif k.isDown("w") then
        if self.vy > 0 then
          self.vy = self.vy - (self.friction * dt)
        end
        if self.vy < -self.maxSpeed then
          self.vy = -self.maxSpeed
        else
          self.vy = self.vy - self.speed * dt
        end
      end
      if not k.isDown("a") and not k.isDown("d") then
        if self.vx > 0 and self.vx > self.low then
          self.vx = self.vx - (self.friction * dt)
        elseif self.vx < 0 and self.vx < -self.low then
          self.vx = self.vx + (self.friction * dt)
        else
          self.vx = 0
        end
      end
      if not k.isDown("s") and not k.isDown("w") then
        if self.vy > 0 and self.vy > self.low then
          self.vy = self.vy - (self.friction * dt)
        elseif self.vy < 0 and self.vy < -self.low then
          self.vy = self.vy + (self.friction * dt)
        else
          self.vy = 0
        end
      end
      self.x = self.x + (self.vx * dt)
      self.y = self.y + (self.vy * dt)
    end,
    getCenter = function(self)
      return {
        self.x + self.width / 2,
        self.y + self.height / 2
      }
    end,
    attack = function(self, x, y, button)
      return self.sword:activateAttack(x, y, button)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, world, x, y, sword, torch, vx, vy, width, height)
      if torch == nil then
        torch = 0
      end
      if vx == nil then
        vx = 0
      end
      if vy == nil then
        vy = 0
      end
      if width == nil then
        width = 32
      end
      if height == nil then
        height = 32
      end
      self.world, self.x, self.y, self.sword, self.torch, self.vx, self.vy, self.width, self.height = world, x, y, sword, torch, vx, vy, width, height
      _class_0.__parent.__init(self, self.world, self.x, self.y, self.width, self.height)
      self.speed = 1500
      self.maxSpeed = 600
      self.friction = 1500
      self.low = 135
    end,
    __base = _base_0,
    __name = "Player",
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
  Player = _class_0
end
return Player
