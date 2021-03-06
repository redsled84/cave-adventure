local Map
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, world, level, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      self.world, self.level, self.x, self.y = world, level, x, y
    end,
    __base = _base_0,
    __name = "Map"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Map = _class_0
  return _class_0
end
