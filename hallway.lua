return {
    create = function(x, y, floor)
      return {
        x = x,
        y = y,
        doorX = x / 2,
        aliens = {},
        floor = floor,

        addAlien = function(self)
          local constructor = Alien1
          if math.random() > 0.5 then
            constructor = Alien2
          end

          local alien = constructor.create(self.x, self.y)
          alien.hallway = self
          alien.targetFloor = math.random(1, FLOOR_COUNT)
          alien.targetSide = 'left'
          if math.random() > 0.5 then
            alien.targetSide = 'right'
          end

          table.insert(self.aliens, alien)
          table.insert(AlienManager.aliens, alien)
        end,

        update = function(self)
          for i = 1, #self.aliens do
            self.aliens[i].seatIndex = i
          end
        end,

        draw = function(self)
          love.graphics.draw(HALLWAY_IMAGE, self.x, self.y, 0, 1, 1, 300, 200)
        end,
      }
    end
}