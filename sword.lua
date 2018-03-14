local sin, cos, atan2
do
  local _obj_0 = math
  sin, cos, atan2 = _obj_0.sin, _obj_0.cos, _obj_0.atan2
end
local mouse, graphics
do
  local _obj_0 = love
  mouse, graphics = _obj_0.mouse, _obj_0.graphics
end
local Sword
do
  local _class_0
  local _base_0 = {
    update = function(self, dt, playerPos)
      self:setPosition(dt, playerPos)
      if self.active then
        return self:controlPolar(dt)
      end
    end,
    setPosition = function(self, dt, playerPos)
      self.x1 = playerPos[1]
      self.y1 = playerPos[2]
      if not self.active then
        local mouseTheta, mouseX, mouseY
        mouseX = mouse.getX()
        mouseY = mouse.getY()
        local dx, dy
        dx = mouseX - self.x1
        dy = mouseY - self.y1
        mouseTheta = atan2(dy, dx)
        self.x2 = self.radius * cos(self.theta + mouseTheta + self.offsetTheta) + self.x1
        self.y2 = self.radius * sin(self.theta + mouseTheta + self.offsetTheta) + self.y1
      else
        self.x2 = self.radius * cos(self.theta + self.offsetTheta) + self.x1
        self.y2 = self.radius * sin(self.theta + self.offsetTheta) + self.y1
      end
    end,
    controlPolar = function(self, dt)
      if self.theta > self.deltaTheta then
        self.theta = self.theta - (self.thetaStep * dt)
        if self.radius > self.minRadius then
          self.radius = self.radius - (self.radiusStep * dt)
        else
          self.radius = self.minRadius
        end
      else
        self.theta = 0
        self.active = false
      end
    end,
    draw = function(self)
      return graphics.line(self.x1, self.y1, self.x2, self.y2)
    end,
    activateAttack = function(self, x, y, button)
      if button == 1 and not self.active then
        self.active = true
        local dx, dy
        dx = x - self.x1
        dy = y - self.y1
        self.theta = atan2(dy, dx)
        self.deltaTheta = self.minTheta + self.theta
        self.radius = self.maxRadius
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x1, y1, x2, y2)
      if x1 == nil then
        x1 = 0
      end
      if y1 == nil then
        y1 = 0
      end
      if x2 == nil then
        x2 = 0
      end
      if y2 == nil then
        y2 = 0
      end
      self.x1, self.y1, self.x2, self.y2 = x1, y1, x2, y2
      self.deltaTheta = 0
      self.minTheta = -4 * math.pi / 3
      self.theta = 0
      self.thetaStep = math.pi * 4
      self.offsetTheta = 2 * math.pi / 3
      self.maxRadius = 50
      self.minRadius = 25
      self.radius = self.maxRadius
      self.radiusStep = 4
      self.active = false
    end,
    __base = _base_0,
    __name = "Sword"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Sword = _class_0
end
return Sword
