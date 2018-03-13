local bump = require("bump")
local world = bump.newWorld()
local Player = require("player")
local Sword = require("sword")
local g
g = love.graphics
local sword = Sword()
local player = Player(world, g.getWidth() / 2, g.getHeight() / 2, sword)
love.load = function()
  love.update = function(dt)
    return player:update(dt)
  end
  love.draw = function()
    return player:draw()
  end
  love.mousepressed = function(x, y, button)
    return player:attack(x, y, button)
  end
end
