WAIT_SPACING = 50
ELEVATOR_ENTRY_DIST = 200
EXIT_DIST = 800
ELEVATOR_ACCEPTABLE_DIFF = 0.5
ELEVATOR_WIDTH = 320
TOTAL_FROWNIES = 0
TOTAL_BEMUSED = 0
TOTAL_SMILIES = 0
PLAYGROUND_BOREDOM_COUNT = 3

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
      happiness = 0.7,
      dialogueOpen = 0,
      waitingCount = 0,
      patienceInterval = 30,
      gravityStretch = 1,
      groundedCount = 0,
      currentWalkSpeed = 0,
      hbOffset = math.random() * 10,
      beenInPlaygroundCount = 0,
      deathCount = 0,
    }

    unit.move = function(self, x, y)
      self.x = self.x + x
      self.y = self.y + y
    end

    unit.walkTo = function(self, dt, x, multi)
      --local walkSpeed = math.abs(70 * dt * (1 + math.sin(time * 8) / 1))
      local walkSpeed = math.abs(120 * dt * multi)
      self.currentWalkSpeed = lerp(self.currentWalkSpeed, walkSpeed, 4 * dt)
      self.x = self.x + clamp(-self.currentWalkSpeed, x - self.x, self.currentWalkSpeed)

      if x - self.x < 0 then
        self.dir = -1
      elseif x - self.x > 0 then
        self.dir = 1
      end

      --if not self.onElevator and ELEVATOR.floorDiff > ELEVATOR_ACCEPTABLE_DIFF and self.hallway.floor == ELEVATOR.floor then
      --  if x > self.x then
      --    if self.x < 200 then
      --      self.x = 200
      --    end
      --  else
      --    if self.x > -200 then
      --      self.x = -200
      --    end
      --  end
      --end
    end

    unit.isElevatorAccessible = function(self)
      if #ELEVATOR.aliens >= 8 then
        return false
      end

      if self.x > ELEVATOR.x then
        if not ELEVATOR.rightDoorOpen then
          return false
        end
      else
        if not ELEVATOR.leftDoorOpen then
          return false
        end
      end

      --if self.hallway.isPlayground and (self.beenInPlaygroundCount < PLAYGROUND_BOREDOM_COUNT and self.happiness < 0.7) then
      if self.hallway.isPlayground and self.happiness < 0.7 then
        return false
      end

      if self.hallway.floor == ELEVATOR.floor
          --ELEVATOR.floorDiff < ELEVATOR_ACCEPTABLE_DIFF
          --math.abs(ELEVATOR.vy) < 10
      then
        return true
      end
    end

    unit.isExitAccessible = function(self, hallway)
      if ELEVATOR.x < hallway.x then
        if not ELEVATOR.rightDoorOpen then
          return false
        end
      else
        if not ELEVATOR.leftDoorOpen then
          return false
        end
      end

      if #hallway.aliens >= HALLWAY_MAX_CAPACITY then
        return false
      end

      --if hallway.isPlayground and (self.beenInPlaygroundCount < PLAYGROUND_BOREDOM_COUNT and self.happiness < 0.7) then
      if hallway.isPlayground and self.happiness < 0.7 then
        return true
      end

      if hallway.color == self.color
          --ELEVATOR.floorDiff < ELEVATOR_ACCEPTABLE_DIFF
          --math.abs(ELEVATOR.vy) < 1
      then
        return true
      end
    end

    unit.declareHappiness = function(self)
      self.dialogueOpen = 3

      if self.happiness > 0.66 then
        playRandomHappyNoise()
        self.happinessImg = HAPPY_IMAGE
        TOTAL_SMILIES = TOTAL_SMILIES + 1
      elseif self.happiness > 0.33 then
        self.happinessImg = BEMUSED_IMAGE
        TOTAL_BEMUSED = TOTAL_BEMUSED + 1
      else
        playRandomAngryNoise()
        self.happinessImg = ANGRY_IMAGE
        TOTAL_FROWNIES = TOTAL_FROWNIES + 1
      end

      --DEBUG[2] = "Smilies: " .. tostring(TOTAL_SMILIES)
      --DEBUG[3] = "Bemused: " .. tostring(TOTAL_BEMUSED)
      --DEBUG[4] = "Frownies: " .. tostring(TOTAL_FROWNIES)
    end

    unit.addEmote = function(self, img, delay)
      if img == ANGRY_IMAGE then
        playRandomAngryNoise()
      elseif img == HAPPY_IMAGE then
        playRandomHappyNoise()
      end

      table.insert(self.emotes, {
        img = img,
        x = (math.random() - 0.5) * 20,
        y = 0,
        life = 2.2,
        delay = delay
      })
    end

    unit.adjustHappiness = function(self, inc)
      if self.deathCount > 0 then
        return
      end

      self.happiness = clamp(0, self.happiness + inc, 1)

      if self.happiness == 0 then
        self.deathCount = 2
      end
    end

    unit.applySeenReward = function(self, isGood)
      if not self.seenReward then
        self.seenReward = true

        if isGood then
          self:adjustHappiness(0.45)
          self:addEmote(HAPPY_IMAGE, 0)
        else
          self:adjustHappiness(-0.45)
          self:addEmote(ANGRY_IMAGE, 0)
        end
      end
    end

    unit.update = function(self, dt)
      --self.y = self.y + 0.2;
      --self.x = self.x + self.vx

      if self.deathCount > 0 then
        self.deathCount = self.deathCount - dt

        if self.deathCount <= 0 then
          --- Destroy this alien
          if self.hallway then
            removeEl(self.hallway.aliens, self)
            removeEl(ELEVATOR.aliens, self)
            removeEl(AlienManager.aliens, self)
          end
        end
      end

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

        self.vy = self.vy + dt * 240
        self.y = self.y + self.vy * dt

        if self.y < ELEVATOR.y - HALLWAY_HEIGHT - self.height then
          self.y = ELEVATOR.y - HALLWAY_HEIGHT - self.height
        end

        if self.y > ELEVATOR.y then
          self.groundedCount = 0
          --self.vy = ELEVATOR.vy * 200
          if ELEVATOR.vy <= 0.2 then
            self.vy = ELEVATOR.vy
          end

          self.y = ELEVATOR.y
        else
          self.groundedCount = self.groundedCount + dt
          if self.groundedCount > 2 and not self.gotFallingReward then
            local happinessInc = BehaviorManager.fallingHappinessMap[self.color]
            if happinessInc ~= nil then
              self.gotFallingReward = true
              self:adjustHappiness(happinessInc)
              self:addEmote(FALLING_IMAGE, 0)
              if happinessInc > 0 then
                self:addEmote(HAPPY_IMAGE, 1)
              else
                self:addEmote(ANGRY_IMAGE, 1)
              end
            end
          end
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

        local floor = HallwayManager.floors[ELEVATOR.floor]
        local target = nil

        if floor then
          local left = floor.left
          local right = floor.right

          if self:isExitAccessible(left) then
            target = left
          elseif self:isExitAccessible(right) then
            target = right
          end
        end

        if target then
          self:walkTo(dt, target.x, 6)
        else
          local spacing = ELEVATOR_WIDTH / #ELEVATOR.aliens
          self:walkTo(dt, ELEVATOR.x - ELEVATOR_WIDTH / 2 + (self.seatIndex - 0.5) * spacing, 1)
        end

        if math.abs(self.x) > ELEVATOR_ENTRY_DIST then
          --- Unload from the elevator
          removeEl(ELEVATOR.aliens, self)
          self.hallway = target
          self.onElevator = false
          table.insert(self.hallway.aliens, self)
          love.audio.play(BLIP_SOUND)


          if self.hallway.isExit then
            self:declareHappiness()
          end
          --self:addEmote(HAPPY_IMAGE)
        end
      else
        self.y = self.hallway.y

        if self.hallway.isExit then
          self:walkTo(dt, self.x * 4, 1)
          --- Delete if exited
          if math.abs(self.x) > EXIT_DIST then
            removeEl(AlienManager.aliens, self)
            removeEl(self.hallway.aliens, self)
          end
        else
          local canWalkOnElevator = self:isElevatorAccessible()

          if canWalkOnElevator then
            self:walkTo(dt, 0, 6)
          else
            if self.hallway.isPlayground then
              self:walkTo(dt, 1.2 * self.hallway.doorX + sign(self.hallway.doorX) * (self.seatIndex - 1) * 450 / #self.hallway.aliens, 1)
            else
              self:walkTo(dt, self.hallway.doorX - (self.seatIndex - 1) * WAIT_SPACING, 1)
            end
          end

          if canWalkOnElevator and math.abs(self.x) < ELEVATOR_ENTRY_DIST and ELEVATOR.floorDiff < ELEVATOR_ACCEPTABLE_DIFF then
            --- Enter the elevator
            removeEl(self.hallway.aliens, self)
            self.hallway = nil
            self.onElevator = true
            table.insert(ELEVATOR.aliens, self)
            love.audio.play(BLIP_SOUND)
            --self.beenInPlaygroundCount = 0

            for i = 1, #ELEVATOR.aliens do
              local alien = ELEVATOR.aliens[i]
              if alien.color == 'green' and self.color == 'yellow' then
                alien:applySeenReward(true)
              end
              if alien.color == 'yellow' and self.color == 'green' then
                self:applySeenReward(true)
              end

              if alien.color == 'aqua' and self.color == 'green' then
                alien:applySeenReward(false)
              end
              if alien.color == 'green' and self.color == 'aqua' then
                self:applySeenReward(false)
              end
            end
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
        self:adjustHappiness(-0.33)
      end

      self.breathY = 1 + 8 * math.sin(time * 2 + self.breathOffset) / self.height
    end

    unit.draw = function(self)
      --if self.onElevator then
      --  love.graphics.push()
      --  love.graphics.translate(ELEVATOR.x, ELEVATOR.y)
      --  love.graphics.rotate(time)
      --  love.graphics.translate(-ELEVATOR.x, -ELEVATOR.y)
      --end

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

      local healthBarWidth = 50
      love.graphics.setColor(0.1, 0.1, 0.1)
      love.graphics.rectangle("fill", self.x - healthBarWidth / 2 - 2, self.y + self.hbOffset - 2, healthBarWidth + 4, 8)
      love.graphics.setColor(1 - self.happiness, self.happiness, 0)
      love.graphics.rectangle("fill", self.x - healthBarWidth / 2, self.y + self.hbOffset, healthBarWidth * self.happiness, 4)
      love.graphics.setColor(1, 1, 1)

      --love.graphics.print(self.happiness, self.x, self.y + 25)


      --if not self.onElevator then
      --  love.graphics.draw(DIR_IMAGE, self.x, self.y - 140, 0, sideDir * 0.5, 0.5, 20, 20)
      --  love.graphics.print(self.targetFloor, self.x, self.y - 140, 0, 1, 1, 5, 8)
      --end
      --love.graphics.print(self.seatIndex, self.x, self.y - 100, 0, 1, 1, 5, 8)

      --if self.onElevator then
      --  love.graphics.pop()
      --end
    end

    return unit
  end
}