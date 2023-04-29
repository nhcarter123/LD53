WAIT_SPACING = 50

return {
  create = function(x, y, img)
    local unit = {
      img = img,
      x = x,
      y = y,
      dir = 1,
      breathY = 1,
      breathOffset = math.random() * 20,
      seatIndex = 1,
    }

    unit.move = function(self, x, y)
      self.x = self.x + x
      self.y = self.y + y
    end

    unit.walkTo = function(self, dt, x)
      --local walkSpeed = math.abs(70 * dt * (1 + math.sin(time * 8) / 1))
      local walkSpeed = math.abs(70 * dt)
      self.x = self.x + clamp(-walkSpeed, x - self.x, walkSpeed)

      if x - self.x < 0 then
        self.dir = -1
      elseif x - self.x > 0 then
        self.dir = 1
      end
    end

    unit.isElevatorAccessible = function(self)
      if self.hallway.floor == ELEVATOR.floor and
          ELEVATOR.floorDiff < 0.2 and
          math.abs(ELEVATOR.vy) < 1
      then
        return true
      end
    end

    unit.update = function(self, dt)
      --self.y = self.y + 0.2;
      --self.x = self.x + self.vx

      if self.onElevator then
        self.y = ELEVATOR.y

        local elevatorWidth = 240
        local spacing = elevatorWidth / #ELEVATOR.aliens
        self:walkTo(dt, ELEVATOR.x - elevatorWidth / 2 + self.seatIndex * spacing)
      else

        local canWalkOnElevator = self:isElevatorAccessible()

        if canWalkOnElevator then
          self:walkTo(dt, 0)
        else
          self:walkTo(dt, self.hallway.doorX - (self.seatIndex - 1) * WAIT_SPACING)
        end

        if math.abs(self.x) < 200 then
          removeEl(self.hallway.aliens, self)
          self.hallway = nil
          self.onElevator = true
          table.insert(ELEVATOR.aliens, self)
        end
      end

      self.breathY = 1 + math.sin(time * 2 + self.breathOffset) / 30
    end

    unit.draw = function(self)
      love.graphics.draw(self.img, self.x, self.y, 0, self.dir, 1 * self.breathY, 107/2, 147)


      --love.graphics.print(self.targetSide, self.x, self.y - 130)

      local sideDir = -1
      if self.targetSide == 'right' then
        sideDir = 1
      end

      --if not self.onElevator then
      --  love.graphics.draw(DIR_IMAGE, self.x, self.y - 140, 0, sideDir * 0.5, 0.5, 20, 20)
      --  love.graphics.print(self.targetFloor, self.x, self.y - 140, 0, 1, 1, 5, 8)
      --end
      --love.graphics.print(self.seatIndex, self.x, self.y - 100, 0, 1, 1, 5, 8)
    end

    return unit
  end
}