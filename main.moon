bump = require "bump"
world = bump.newWorld!

Player = require "player"
Sword = require "sword"

{graphics: g} = love

sword = Sword!
player = Player world, g.getWidth! / 2, g.getHeight! / 2, sword

love.load = ->
  love.update = (dt) ->
    player\update dt
  love.draw = ->
    player\draw!
  love.mousepressed = (x, y, button) ->
    player\attack x, y, button