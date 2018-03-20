local graphics, timer
do
  local _obj_0 = love
  graphics, timer = _obj_0.graphics, _obj_0.timer
end
local FusRoDah
do
  local _class_0
  local _base_0 = {
    setPosition = function(self, x, y)
      self.x, self.y = x, y
    end,
    update = function(self, dt)
      if self.active then
        self.time = self.time - dt
        if self.time <= 0 then
          self.time = self.maxTime
          self.active = false
          self.activateCoolDown = true
        end
      end
      if self.activateCoolDown then
        self.coolDown = self.coolDown - dt
        if self.coolDown <= 0 then
          self.coolDown = self.maxCoolDown
          self.activateCoolDown = false
        end
      end
    end,
    activate = function(self, key)
      if key == "f" and not self.active and not self.activateCoolDown then
        self.active = true
        local items, item, len
        items, len = self.world:queryRect(self.x - self.length, self.y - self.length, 2 * self.length, 2 * self.length)
        for i = 1, len do
          item = items[i]
          if item.__class.__name ~= "Player" then
            local dt, dx, dy, minVel, multiplier
            dt = timer.getDelta()
            minVel = 200
            multiplier = 100
            dx = (item.x + item.width / 2 - self.x)
            dy = (item.y + item.height / 2 - self.y)
            dx = dx > 0 and dx + minVel or dx - minVel
            dy = dy > 0 and dy + minVel or dy - minVel
            item.vx = item.vx + dx * multiplier * dt
            item.vy = item.vy + dy * multiplier * dt
            item.hit = true
          end
        end
      end
    end,
    draw = function(self)
      if self.active then
        graphics.setColor(0, 255, 255, 100)
        return graphics.rectangle('fill', self.x - self.length, self.y - self.length, 2 * self.length, 2 * self.length)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, world, x, y)
      self.world, self.x, self.y = world, x, y
      self.length = 100
      self.active = false
      self.maxTime = .25
      self.time = self.maxTime
      self.activateCoolDown = false
      self.maxCoolDown = 4
      self.coolDown = self.maxCoolDown
    end,
    __base = _base_0,
    __name = "FusRoDah"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  FusRoDah = _class_0
  return _class_0
end
