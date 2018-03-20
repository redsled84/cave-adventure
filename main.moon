bump = require "bump"
world = bump.newWorld!

Player = require "player"
Sword = require "sword"
SmallEnemy = require "smallEnemy"

state = "play"

{graphics: g, event: event, window: window, math: m} = love

window.setTitle "Sword Swiper"

getEnemies = (num) ->
  return [SmallEnemy(world, m.random(0, g.getWidth!), m.random(0, g.getHeight!)) for i = 1, num]

loopEnemies = (enemies, f) ->
  for i = 1, #enemies
    f enemies[i]

removeDeadEnemies = (enemies, player) ->
  for i = #enemies, 1, -1
    local enemy, items, len
    enemy = enemies[i]
    items, len = world\queryRect enemy.x, enemy.y, enemy.width, enemy.height
    if enemy.health <= 0
      player.sword.maxRadius += 2

      world\remove enemy
      table.remove enemies, i

drawPlayerHealth = (player) ->
  local ratio, barWidth, barHeight, barX, barY
  barWidth = 300
  barHeight = 18
  barX, barY = g.getWidth! / 2 - barWidth / 2, g.getHeight! - barHeight - 10
  g.setColor 10, 10, 10
  g.rectangle "fill", barX - 5, barY - 5, barWidth + 10, barHeight + 10
  if player.health > 0
    ratio = barWidth * player.health / player.maxHealth

    g.setColor 255, 0, 0
    g.rectangle "fill", barX, barY, ratio, barHeight

drawFusRoDahCoolDown = (player) ->
  local ratio, barWidth, barHeight, barX, barY
  barWidth = 300
  barHeight = 4
  barX, barY = g.getWidth! / 2 - barWidth / 2, g.getHeight! - barHeight - 10 - 64
  g.setColor 10, 10, 10
  g.rectangle "fill", barX - 5, barY - 5, barWidth + 10, barHeight + 10
  if player.fusRoDah.coolDown > 0
    ratio = barWidth * player.fusRoDah.coolDown / player.fusRoDah.maxCoolDown

    g.setColor 0, 100, 255
    g.rectangle "fill", barX, barY, ratio, barHeight

updateState = (enemies, player) ->
  if player.health <= 0
    state = "over"
  elseif #enemies == 0
    state = "win"
  else
    state = "play"

drawGameOver = ->
  g.setColor 0, 0, 0
  g.print "Game Over", g.getWidth! / 2 - 120, g.getHeight! / 2 - 25, 0, 4, 4

drawWin = ->
  g.setColor 0, 0, 0
  g.print "Winner", g.getWidth! / 2 - 90, g.getHeight! / 2 - 25, 0, 4, 4
  g.print "Press 'R' to restart", g.getWidth! / 2 - 235, g.getHeight! / 2 + 20, 0, 4, 4

sword = Sword!


player = Player world, g.getWidth! / 2, g.getHeight! / 2, sword

local difficulty, nEnemies

-- set game difficulty
difficulty = "hard"
-- difficulty = "medium"
-- difficulty = "easy"

if difficulty == "hard"
  nEnemies = 150
elseif difficulty == "medium"
  nEnemies = 75
else
  nEnemies = 40

enemies = getEnemies nEnemies

love.load = ->

  g.setBackgroundColor 230, 230, 230

  love.update = (dt) ->
    updateState enemies, player
    if state == "play"  
      player\update dt

      loopEnemies enemies, (enemy) ->
        enemy\update dt, player\getCenter!

      removeDeadEnemies enemies, player

  love.draw = ->
    if state == "play"
      player\draw!
      loopEnemies enemies, (enemy) ->
        enemy\draw!

      drawPlayerHealth player
      drawFusRoDahCoolDown player
    elseif state == "over"
      drawGameOver!
    elseif state == "win"
      drawWin!

  love.keypressed = (key) ->
    if state == "play"
      player\attack key
    if key == "escape"
      event.quit!
    elseif key == "r" and state ~= "play"
      event.quit "restart"
