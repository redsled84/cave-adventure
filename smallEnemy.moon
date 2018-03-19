Entity = require "entity"

{graphics: graphics} = love

class SmallEnemy extends Entity
	new: (@world, @x, @y, @width=4, @height=4, @damage=10) =>
		super @world, @x, @y, @width, @height

		@speed = 200
		@vx = 0
		@vy = 0

	update: (dt, playerCenter) =>
		@move dt, playerCenter

	move: (dt, playerCenter) =>
		local x, y, dist, dx, dy, directionX, directionY
		x, y = playerCenter[1], playerCenter[2]
		dx = x - @x
		dy = y - @y
		dist = math.sqrt((dx)^2 + (dy)^2)

		directionX = dx / dist
		directionY = dy / dist

		local futureX, futureY, nextX, nextY, cols, len
		futureX, futureY = @x + directionX * @speed * dt, @y + directionY * @speed * dt
		nextX, nextY, cols, len = @world\move self, futureX, futureY

		@x = nextX
		@y = nextY

	draw: =>
		graphics.setColor 255, 0, 0
		graphics.rectangle "fill", @x, @y, @width, @height