HALLWAY_MAX_CAPACITY = 8

return {
  create = function(x, y, floor)
    return {
      img = HALLWAY_DETAIL_IMAGE,
      x = x,
      y = y,
      doorX = x / 2,
      aliens = {},
      floor = floor,
      rand = math.random(),
      playgroundPlayCount = 0,
      playgroundPlayInterval = 5,

      init = function(self)
        if self.isPlayground then
          self.img = PLAYGROUND_IMAGE
          self.backColor = { 0.7, 0.54, 0.35 }
        elseif self.color == 'green' then
          self.backColor = { 0.45, 0.54, 0.35 }
        elseif self.color == 'yellow' then
          self.backColor = { 0.99, 0.75, 0.37 }
        elseif self.color == 'purple' then
          self.backColor = { 0.46, 0.31, 0.51 }
        elseif self.color == 'aqua' then
          self.backColor = { 0.41, 0.59, 0.68 }
        else
          self.backColor = { 0.84, 0.82, 0.72 }
        end
      end,

      addAlien = function(self)
        local constructor = Alien1

        if self.rand > 0.75 then
          constructor = Alien2
        elseif self.rand > 0.5 then
          constructor = Alien3
        elseif self.rand > 0.25 then
          constructor = Alien4
        end

        local alien = constructor.create(self.x * 1.5, self.y)
        alien.hallway = self
        alien.targetFloor = math.random(1, FLOOR_COUNT)
        alien.targetSide = 'left'
        if math.random() > 0.5 then
          alien.targetSide = 'right'
        end

        table.insert(self.aliens, alien)
        table.insert(AlienManager.aliens, alien)
      end,

      update = function(self, dt)
        local played = false

        if self.isPlayground then
          self.playgroundPlayCount = self.playgroundPlayCount + dt
          if self.playgroundPlayCount > self.playgroundPlayInterval then
            self.playgroundPlayCount = 0
            shuffle(self.aliens)
            played = true
          end
        end

        for i = 1, #self.aliens do
          local alien = self.aliens[i]
          alien.seatIndex = i

          if played then
            alien.beenInPlaygroundCount = alien.beenInPlaygroundCount + 1
            alien.happiness = clamp(0, alien.happiness + 0.1, 1)
            alien:addEmote(HAPPY_IMAGE, 0)
          end
        end
      end,

      draw = function(self)
        love.graphics.setColor(self.backColor)
        love.graphics.rectangle("fill", self.x - 300, self.y - 200, 600, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 300, 200)
      end,
    }
  end
}