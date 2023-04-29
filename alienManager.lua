return {
    aliens = {},
    spawnCount = 0,
    spawnInterval = 4,

    update = function(self, dt)
      self.spawnCount = self.spawnCount + dt

      if self.spawnCount > self.spawnInterval then
        self.spawnCount = 0

        local randomFloor = math.random(1, FLOOR_COUNT)

        local side = 'left'
        if math.random() < 0.5 then
          side = 'right'
        end

        HallwayManager.floors[randomFloor][side]:addAlien()
      end

      for i = 1, #self.aliens do
        self.aliens[i]:update(dt)
      end
    end,

    draw = function(self)
      for i = 1, #self.aliens do
        self.aliens[i]:draw()
      end
    end,
}