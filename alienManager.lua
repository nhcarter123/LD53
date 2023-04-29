return {
    aliens = {},
    spawnCount = 999,
    spawnInterval = 2,
    --differ

    update = function(self, dt)
      self.spawnCount = self.spawnCount + dt

      if self.spawnCount > self.spawnInterval then
        self.spawnCount = 0

        local targetHallway = self.entryPoints[math.random(#self.entryPoints)]
        targetHallway:addAlien()
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