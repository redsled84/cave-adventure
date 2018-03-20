local bump = require("bump")
local world = bump.newWorld()
local Player = require("player")
local Sword = require("sword")
local SmallEnemy = require("smallEnemy")
local state = "play"
local g, event, window, m
do
  local _obj_0 = love
  g, event, window, m = _obj_0.graphics, _obj_0.event, _obj_0.window, _obj_0.math
end
window.setTitle("Sword Swiper")
local getEnemies
getEnemies = function(num)
  local _accum_0 = { }
  local _len_0 = 1
  for i = 1, num do
    _accum_0[_len_0] = SmallEnemy(world, m.random(0, g.getWidth()), m.random(0, g.getHeight()))
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
local loopEnemies
loopEnemies = function(enemies, f)
  for i = 1, #enemies do
    f(enemies[i])
  end
end
local removeDeadEnemies
removeDeadEnemies = function(enemies, player)
  for i = #enemies, 1, -1 do
    local enemy, items, len
    enemy = enemies[i]
    items, len = world:queryRect(enemy.x, enemy.y, enemy.width, enemy.height)
    if enemy.health <= 0 then
      player.sword.maxRadius = player.sword.maxRadius + 2
      world:remove(enemy)
      table.remove(enemies, i)
    end
  end
end
local drawPlayerHealth
drawPlayerHealth = function(player)
  local ratio, barWidth, barHeight, barX, barY
  barWidth = 300
  barHeight = 18
  barX, barY = g.getWidth() / 2 - barWidth / 2, g.getHeight() - barHeight - 10
  g.setColor(10, 10, 10)
  g.rectangle("fill", barX - 5, barY - 5, barWidth + 10, barHeight + 10)
  if player.health > 0 then
    ratio = barWidth * player.health / player.maxHealth
    g.setColor(255, 0, 0)
    return g.rectangle("fill", barX, barY, ratio, barHeight)
  end
end
local drawFusRoDahCoolDown
drawFusRoDahCoolDown = function(player)
  local ratio, barWidth, barHeight, barX, barY
  barWidth = 300
  barHeight = 4
  barX, barY = g.getWidth() / 2 - barWidth / 2, g.getHeight() - barHeight - 10 - 64
  g.setColor(10, 10, 10)
  g.rectangle("fill", barX - 5, barY - 5, barWidth + 10, barHeight + 10)
  if player.fusRoDah.coolDown > 0 then
    ratio = barWidth * player.fusRoDah.coolDown / player.fusRoDah.maxCoolDown
    g.setColor(0, 100, 255)
    return g.rectangle("fill", barX, barY, ratio, barHeight)
  end
end
local updateState
updateState = function(enemies, player)
  if player.health <= 0 then
    state = "over"
  elseif #enemies == 0 then
    state = "win"
  else
    state = "play"
  end
end
local drawGameOver
drawGameOver = function()
  g.setColor(0, 0, 0)
  return g.print("Game Over", g.getWidth() / 2 - 120, g.getHeight() / 2 - 25, 0, 4, 4)
end
local drawWin
drawWin = function()
  g.setColor(0, 0, 0)
  g.print("Winner", g.getWidth() / 2 - 90, g.getHeight() / 2 - 25, 0, 4, 4)
  return g.print("Press 'R' to restart", g.getWidth() / 2 - 235, g.getHeight() / 2 + 20, 0, 4, 4)
end
local sword = Sword()
local player = Player(world, g.getWidth() / 2, g.getHeight() / 2, sword)
local difficulty, nEnemies
difficulty = "hard"
if difficulty == "hard" then
  nEnemies = 150
elseif difficulty == "medium" then
  nEnemies = 75
else
  nEnemies = 40
end
local enemies = getEnemies(nEnemies)
love.load = function()
  g.setBackgroundColor(230, 230, 230)
  love.update = function(dt)
    updateState(enemies, player)
    if state == "play" then
      player:update(dt)
      loopEnemies(enemies, function(enemy)
        return enemy:update(dt, player:getCenter())
      end)
      return removeDeadEnemies(enemies, player)
    end
  end
  love.draw = function()
    if state == "play" then
      player:draw()
      loopEnemies(enemies, function(enemy)
        return enemy:draw()
      end)
      drawPlayerHealth(player)
      return drawFusRoDahCoolDown(player)
    elseif state == "over" then
      return drawGameOver()
    elseif state == "win" then
      return drawWin()
    end
  end
  love.keypressed = function(key)
    if state == "play" then
      player:attack(key)
    end
    if key == "escape" then
      return event.quit()
    elseif key == "r" and state ~= "play" then
      return event.quit("restart")
    end
  end
end
