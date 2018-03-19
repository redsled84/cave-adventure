local bump = require("bump")
local world = bump.newWorld()
local Player = require("player")
local Sword = require("sword")
local SmallEnemy = require("smallEnemy")
local g, event
do
  local _obj_0 = love
  g, event = _obj_0.graphics, _obj_0.event
end
local sword = Sword()
local enemy = SmallEnemy(world, 100, 100)
local player = Player(world, g.getWidth() / 2, g.getHeight() / 2, sword)
love.load = function()
  love.update = function(dt)
    player:update(dt)
    return enemy:update(dt, player:getCenter())
  end
  love.draw = function()
    player:draw()
    return enemy:draw()
  end
  love.keypressed = function(key)
    if key == "escape" then
      return event.quit()
    end
  end
  love.mousepressed = function(x, y, button)
    return player:attack(x, y, button)
  end
end
