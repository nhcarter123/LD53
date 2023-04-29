return {
    create = function(x, y, floor)
      return {
        img = HALLWAY_IMAGE,
        x = x,
        y = y,
        doorX = x / 2,
        aliens = {},
        floor = floor,

        init = function(self)
          if self.color == 'green' then
            self.img = HALLWAY_G_IMAGE
          elseif self.color == 'yellow' then
            self.img = HALLWAY_Y_IMAGE
          elseif self.color == 'purple' then
            self.img = HALLWAY_P_IMAGE
          end
        end,

        addAlien = function(self)
          local constructor = Alien1
          local rand = math.random()

          if rand > 0.66 then
            constructor = Alien2
          elseif rand > 0.33 then
            constructor = Alien3
          end

          local alien = constructor.create(self.x * 2, self.y)
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
          love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 300, 200)
        end,
      }
    end
}