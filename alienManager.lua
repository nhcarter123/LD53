return {
  aliens = {},
  spawnCount = 999,
  spawnInterval = 2,
  difficultyCount = 0,
  difficultyIncreaseInterval = 45,
  spawnRateUp = 0,
  --differ

  update = function(self, dt)
    self.spawnCount = self.spawnCount + dt

    if self.spawnCount > self.spawnInterval then
      self.spawnCount = 0

      --- Don't spawn in a full hallway
      local legalSpawnAreas = {}
      for i = 1, #self.entryPoints do
        local hallway = self.entryPoints[i]
        if #hallway.aliens < HALLWAY_MAX_CAPACITY then
          table.insert(legalSpawnAreas, hallway)
        end
      end

      local targetHallway = legalSpawnAreas[math.random(#legalSpawnAreas)]
      targetHallway:addAlien()
    end

    if self.difficultyCount > self.difficultyIncreaseInterval then
      self.difficultyCount = 0

      if self.spawnInterval > 1 then
        self.spawnInterval = self.spawnInterval - 0.2

        self.spawnRateUp = 3
      end
    end

    self.difficultyCount = self.difficultyCount + dt
    self.spawnRateUp = self.spawnRateUp - dt

    --local mx, my = love.mouse.getPosition()
    --local wmx, wmy = cam:toWorld(mx, my)
    --local hovered = nil

    for i = #self.aliens, 1, -1 do
      local alien = self.aliens[i]
      alien:update(dt)
      --
      --if not hovered then
      --  if wmx > alien.x - 50 and
      --      wmx < alien.x + 50 and
      --      wmy > alien.y - 100 and
      --      wmy < alien.y + 100
      --  then
      --    hovered = alien
      --  end
      --end
    end

    --if hovered and love.mouse.isDown(1) then
    --  hovered.x = wmx
    --  hovered.y = wmy
    --end

  end,

  draw = function(self)
    for i = 1, #self.aliens do
      self.aliens[i]:draw()
    end
  end,
}