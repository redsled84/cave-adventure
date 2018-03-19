bump = require "bump"
world = bump.newWorld!

Player = require "player"
Sword = require "sword"
SmallEnemy = require "smallEnemy"

{graphics: g, event: event} = love

sword = Sword!
enemy = SmallEnemy world, 100, 100
player = Player world, g.getWidth! / 2, g.getHeight! / 2, sword

love.load = ->
  love.update = (dt) ->

    player\update dt
    enemy\update dt, player\getCenter!

  love.draw = ->
    player\draw!
    enemy\draw!

  love.keypressed = (key) ->
    if key == "escape"
      event.quit!

  love.mousepressed = (x, y, button) ->
    player\attack x, y, button