local bump = require "bump"
local player = require "player"

function love.load()

end

function love.update(dt)
	player:update(dt)
end

function love.draw()
	player:draw()
end

function love.keypressed(key)
	player:attack(key)
	if key == "escape" then
		love.event.quit()
	end
end