return {
  aliens = {},
  spawnCount = 999,
  spawnInterval = 3,
  --differ

  update = function(self, dt)
    self.spawnCount = self.spawnCount + dt

    if self.spawnCount > self.spawnInterval then
      self.spawnCount = 0

      local targetHallway = self.entryPoints[math.random(#self.entryPoints)]
      targetHallway:addAlien()
    end

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