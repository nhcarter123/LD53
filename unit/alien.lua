WAIT_SPACING = 50
ELEVATOR_ENTRY_DIST = 200

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
      emotes = {},
      height = -140
    }

    unit.move = function(self, x, y)
      self.x = self.x + x
      self.y = self.y + y
    end

    unit.walkTo = function(self, dt, x)
      --local walkSpeed = math.abs(70 * dt * (1 + math.sin(time * 8) / 1))
      local walkSpeed = math.abs(110 * dt)
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

    unit.isExitAccessible = function(self, hallway)
      if hallway.color == self.color and
          ELEVATOR.floorDiff < 0.2 and
          math.abs(ELEVATOR.vy) < 1
      then
        return true
      end
    end

    unit.addEmote = function(self, img)
      table.insert(self.emotes, {
        img = img,
        y = self.y + self.height,
        life = 2.2
      })
    end

    unit.update = function(self, dt)
      --self.y = self.y + 0.2;
      --self.x = self.x + self.vx

      for i = #self.emotes, 1, -1 do
        local emote = self.emotes[i]
        emote.life = emote.life - dt
        if emote.life > 0 then
          emote.y = emote.y - dt * 20
        else
          table.remove(self.emotes, i)
        end
      end

      if self.onElevator then
        self.y = ELEVATOR.y

        local left = HallwayManager.floors[ELEVATOR.floor].left
        local right = HallwayManager.floors[ELEVATOR.floor].right

        local target = nil
        if self:isExitAccessible(left) then
          target = left
        elseif self:isExitAccessible(right) then
          target = right
        end

        if target then
          self:walkTo(dt, target.x)
        else
          local elevatorWidth = 240
          local spacing = elevatorWidth / #ELEVATOR.aliens
          self:walkTo(dt, ELEVATOR.x - elevatorWidth / 2 + self.seatIndex * spacing)
        end

        if math.abs(self.x) > ELEVATOR_ENTRY_DIST then
          --- Unload from the elevator
          removeEl(ELEVATOR.aliens, self)
          self.hallway = target
          self.onElevator = false
          table.insert(self.hallway.aliens, self)

          self:addEmote(HAPPY_IMAGE)
        end
      else
        self.y = self.hallway.y

        if self.hallway.isExit then
          self:walkTo(dt, self.x * 2)
        else
          local canWalkOnElevator = self:isElevatorAccessible()

          if canWalkOnElevator then
            self:walkTo(dt, 0)
          else
            self:walkTo(dt, self.hallway.doorX - (self.seatIndex - 1) * WAIT_SPACING)
          end

          if math.abs(self.x) < ELEVATOR_ENTRY_DIST then
            removeEl(self.hallway.aliens, self)
            self.hallway = nil
            self.onElevator = true
            table.insert(ELEVATOR.aliens, self)
          end
        end
      end

      self.breathY = 1 + math.sin(time * 2 + self.breathOffset) / 30
    end

    unit.draw = function(self)
      love.graphics.draw(self.img, self.x, self.y, 0, self.dir, 1 * self.breathY, 107/2, 147)

      for i = 1, #self.emotes do
        local emote = self.emotes[i]

        love.graphics.setColor(1, 1, 1, emote.life * 1.2)
        love.graphics.draw(emote.img, self.x, emote.y, 0, 1.5, 1.5, 27 / 2, 24 / 2)
        love.graphics.setColor(1, 1, 1)
      end
      --love.graphics.print(self.targetSide, self.x, self.y - 130)


      --if not self.onElevator then
      --  love.graphics.draw(DIR_IMAGE, self.x, self.y - 140, 0, sideDir * 0.5, 0.5, 20, 20)
      --  love.graphics.print(self.targetFloor, self.x, self.y - 140, 0, 1, 1, 5, 8)
      --end
      --love.graphics.print(self.seatIndex, self.x, self.y - 100, 0, 1, 1, 5, 8)
    end

    return unit
  end
}