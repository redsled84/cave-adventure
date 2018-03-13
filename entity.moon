class Entity
  new: (@world, @x, @y, @width, @height) =>
    @world\add self, @x, @y, @width, @height

return Entity