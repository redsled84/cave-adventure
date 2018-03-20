local asin, acos, sqrt, atan2
do
  local _obj_0 = math
  asin, acos, sqrt, atan2 = _obj_0.asin, _obj_0.acos, _obj_0.sqrt, _obj_0.atan2
end
local graphics, k, mouse
do
  local _obj_0 = love
  graphics, k, mouse = _obj_0.graphics, _obj_0.keyboard, _obj_0.mouse
end
local Entity = require("entity")
local FusRoDah = require("fusRoDah")
local Player
do
  local _class_0
  local _parent_0 = Entity
  local _base_0 = {
    update = function(self, dt)
      self:move(dt)
      self:handleCollision(dt)
      self.sword:update(dt, self:getCenter())
      self.fusRoDah:update(dt)
      self.fusRoDah:setPosition(self.x + self.width / 2, self.y + self.height / 2)
      return self:manipulateHits(dt)
    end,
    manipulateHits = function(self, dt)
      local items, len
      items, len = self.world:querySegment(self.sword.x1, self.sword.y1, self.sword.x2, self.sword.y2)
      for i = 1, len do
        local item, dx, dy
        item = items[i]
        if i > 1 and not item.hit and self.sword.active then
          local minVel, multiplier
          minVel = 200
          multiplier = 100
          dx = (item.x + item.width / 2 - self.sword.x1)
          dy = (item.y + item.height / 2 - self.sword.y1)
          dx = dx > 0 and dx + minVel or dx - minVel
          dy = dy > 0 and dy + minVel or dy - minVel
          item.vx = item.vx + dx * multiplier * dt
          item.vy = item.vy + dy * multiplier * dt
          item.health = item.health - self.sword.damage
        end
        item.hit = i > 1
      end
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
    end,
    handleCollision = function(self, dt)
      return _class_0.__parent.__base.handleCollision(self, dt, function(col)
        if col.other.__class.__name == "SmallEnemy" then
          col.other.vx = col.normal.x ~= 0 and self.vx * col.normal.x or col.other.vx
          col.other.vy = col.normal.y ~= 0 and self.vy * col.normal.y or col.other.vy
        end
      end)
    end,
    draw = function(self)
      graphics.setColor(255, 125, 125)
      self.sword:draw()
      self.fusRoDah:draw()
      graphics.setColor(10, 10, 10)
      graphics.rectangle("fill", self.x, self.y, self.width, self.height, 6)
      graphics.setColor(125, 255, 125)
      return graphics.draw(self.directionImage, self.x + self.width / 2, self.y + self.height / 2, self.sword:getMouseTheta() + math.pi / 2, 1, 1, self.width / 2, self.height / 2)
    end,
    getCenter = function(self)
      return {
        self.x + self.width / 2,
        self.y + self.height / 2
      }
    end,
    attack = function(self, key)
      self.sword:activateAttack(key)
      return self.fusRoDah:activate(key)
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
      self.fusRoDah = FusRoDah(self.world, self.x, self.y)
      self.speed = 1500
      self.maxSpeed = 600
      self.friction = 1500
      self.low = 135
      self.directionImage = graphics.newImage("dir.png")
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
