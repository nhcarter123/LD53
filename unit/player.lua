return {
  create = function(x, y)
    local unit = {
      x = x,
      y = y,
      height = 0,
      vx = (math.random() - 0.5) * 0.2,
      vy = 0,
      w = 390,
      h = 190,
      aliens = {}
    }

    -- Slow down elevator based on capacity

    unit.move = function(self, x, y)
      self.x = self.x + x
      --self.y = self.y + y

      self.vy = self.vy + y * 0.07
    end

    unit.update = function(self, dt, ceilingHeight, noInputs)
      --self.y = self.y + 0.2;
      --self.x = self.x + self.vx

      self.y = self.y + self.vy * dt * 120
      --self.vy = self.vy * 0.98

      --- Stop at bottom
      if self.y > 0 then
        self.y = 0

        --- Bounce
        if self.vy > 0 then
          self.vy = -self.vy * 0.5
        end
      end

      --- Stop at the ceiling
      if self.y < ceilingHeight + self.h then
        self.y = ceilingHeight + self.h

        --- Bounce
        if self.vy < 0 then
          self.vy = -self.vy * 0.5
        end
      end

      self.floor = 1 + round(-self.y / HALLWAY_HEIGHT)
      self.floorDiff = math.abs((self.y + (self.floor - 1) * HALLWAY_HEIGHT) / HALLWAY_HEIGHT)
      --DEBUG[2] = "floor: " .. tostring(self.floor)
      --DEBUG[3] = "FloorDiff: " .. tostring(self.floorDiff)

      if noInputs then
        --self.y = lerp(self.y, (-currentFloor + 1) * HALLWAY_HEIGHT, 4 * dt)
        self.vy = self.vy * 0.98 --- Todo delta time
      else
        self.vy = self.vy * 0.98
      end

      --- Set seat index
      for i = 1, #self.aliens do
        self.aliens[i].seatIndex = i
      end
    end

    unit.draw = function(self)
      love.graphics.draw(ELEVATOR_IMAGE, self.x, self.y, 0, 1, 1, self.w / 2, self.h)
      --love.graphics.rectangle('fill', self.x - self.w/2, self.y-self.h, self.w, self.h)
    end

    return unit
  end
}