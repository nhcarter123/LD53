return {
    floors = {},

    init = function(self, floorCount)
      local spacingX = 500

      for i = 1, floorCount do
        local yOffset = -HALLWAY_HEIGHT * (i - 1)

        self.floors[i] = {
          left = Hallway.create(-spacingX, yOffset, i),
          right = Hallway.create(spacingX, yOffset, i),
        }
      end
    end,

    update = function(self)
      for i = 1, #self.floors do
        local floor = self.floors[i]
        floor.left:update()
        floor.right:update()
      end
    end,

    draw = function(self)
      for i = 1, #self.floors do
        local floor = self.floors[i]
        floor.left:draw()
        floor.right:draw()
      end
    end,
}