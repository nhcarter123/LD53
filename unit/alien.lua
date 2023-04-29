WAIT_SPACING = 50
ELEVATOR_ENTRY_DIST = 200
EXIT_DIST = 600
ELEVATOR_ACCEPTABLE_DIFF = 15

return {
  create = function(x, y, img)
    local unit = {
      img = img,
      x = x,
      y = y,
      vy = 0,
      dir = 1,
      breathY = 1,
      breathOffset = math.random() * 20,
      seatIndex = 1,
      emotes = {},
      height = -140,
      happiness = 0.5,
      dialogueOpen = 0,
      waitingCount = 0,
      patienceInterval = 60,
      gravityStretch = 1
    }

    unit.move = function(self, x, y)
      self.x = self.x + x
      self.y = self.y + y
    end

    unit.walkTo = function(self, dt, x)
      --local walkSpeed = math.abs(70 * dt * (1 + math.sin(time * 8) / 1))
      local walkSpeed = math.abs(130 * dt)
      self.x = self.x + clamp(-walkSpeed, x - self.x, walkSpeed)

      if x - self.x < 0 then
        self.dir = -1
      elseif x - self.x > 0 then
        self.dir = 1
      end
    end

    unit.isElevatorAccessible = function(self)
      if self.hallway.floor == ELEVATOR.floor and
          ELEVATOR.floorDiff < ELEVATOR_ACCEPTABLE_DIFF and
          math.abs(ELEVATOR.vy) < 1
      then
        return true
      end
    end

    unit.isExitAccessible = function(self, hallway)
      if hallway.color == self.color and
          ELEVATOR.floorDiff < ELEVATOR_ACCEPTABLE_DIFF and
          math.abs(ELEVATOR.vy) < 1
      then
        return true
      end
    end

    unit.declareHappiness = function(self)
      self.dialogueOpen = 3

      self.happinessImg = ANGRY_IMAGE
      if self.happiness > 0.66 then
        self.happinessImg = HAPPY_IMAGE
      elseif self.happiness > 0.33 then
        self.happinessImg = BEMUSED_IMAGE
      end
    end

    unit.addEmote = function(self, img, delay)
      table.insert(self.emotes, {
        img = img,
        x = (math.random() - 0.5) * 20,
        y = 0,
        life = 2.2,
        delay = delay
      })
    end

    unit.update = function(self, dt)
      --self.y = self.y + 0.2;
      --self.x = self.x + self.vx

      for i = #self.emotes, 1, -1 do
        local emote = self.emotes[i]

        if emote.delay > 0 then
          emote.delay = emote.delay - dt
        else
          emote.life = emote.life - dt
          if emote.life > 0 then
            emote.y = emote.y - dt * 20
          else
            table.remove(self.emotes, i)
          end
        end
      end

      if self.onElevator then
        --self.y = ELEVATOR.y

        self.vy = self.vy + dt * 500
        self.y = self.y + self.vy * dt

        if self.y > ELEVATOR.y then
          --self.vy = ELEVATOR.vy * 200
          if ELEVATOR.vy <= 0.2 then
            self.vy = 0
          end

          self.y = ELEVATOR.y
        end

        --if self.vy > 0 then
        --  self.gravityStretch = lerp(self.gravityStretch, 1.2, dt * 10)
        --else
        --  self.gravityStretch = lerp(self.gravityStretch, 1, dt * 10)
        --end

        --self.gravityStretch = 1 + self.vy / 1000


        --if ELEVATOR.vy > 0 then
        --  self.y = ELEVATOR.y - 5 * ELEVATOR.vy
        --else
        --  self.y = ELEVATOR.y
        --end

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

          self:declareHappiness()
          --self:addEmote(HAPPY_IMAGE)
        end
      else
        self.y = self.hallway.y

        if self.hallway.isExit then
          self:walkTo(dt, self.x * 4)
          --- Delete if exited
          if math.abs(self.x) > EXIT_DIST then
            removeEl(AlienManager.aliens)
            removeEl(self.hallway.aliens)
          end
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

      if (self.hallway and not self.hallway.isExit) or self.onElevator then
        self.waitingCount = self.waitingCount + dt
      else
        self.waitingCount = 0
      end

      if self.waitingCount > self.patienceInterval then
        self:addEmote(CLOCK_IMAGE, 0)
        self:addEmote(ANGRY_IMAGE, 1)
        self.waitingCount = 0
        self.happiness = self.happiness - 0.2
      end

      self.breathY = 1 + math.sin(time * 2 + self.breathOffset) / 30
    end

    unit.draw = function(self)
      love.graphics.draw(self.img, self.x, self.y, 0, self.dir, 1 * self.breathY * self.gravityStretch, 107 / 2, 147)

      if self.dialogueOpen > 0 then
        local bubbleX = -20
        local bubbleY = -35
        love.graphics.draw(BUBBLE_IMAGE, self.x + bubbleX, self.y + self.height + bubbleY, 0, 1, 1, 28, 20)
        love.graphics.draw(self.happinessImg, self.x + bubbleX, self.y + self.height + bubbleY, 0, 0.7, 0.7, 20, 20)
      end

      for i = 1, #self.emotes do
        local emote = self.emotes[i]

        if emote.delay <= 0 then
          love.graphics.setColor(1, 1, 1, emote.life * 1.2)
          love.graphics.draw(emote.img, self.x + emote.x, self.y + self.height + emote.y, 0, 1, 1, 20, 20)
          love.graphics.setColor(1, 1, 1)
        end
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