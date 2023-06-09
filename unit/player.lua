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
      aliens = {},
      leftDoorPct = 0,
      rightDoorPct = 0,
      leftDoorOpen = true,
      rightDoorOpen = true,
    }

    -- Slow down elevator based on capacity

    unit.move = function(self, ceilingHeight, y)
      self.vy = self.vy + y * 0.07
    end

    unit.toggleDoor = function(self, isLeft)
      if isLeft then
        self.leftDoorOpen = not self.leftDoorOpen
      else
        self.rightDoorOpen = not self.rightDoorOpen
      end
    end

    unit.update = function(self, dt, ceilingHeight, noInputs)
      --self.y = self.y + 0.2;
      --self.x = self.x + self.vx
      --love.audio.setPosition(self.x, self.y, 0)

      self.leftDoorOpen = love.keyboard.isDown("a") or love.keyboard.isDown("left")
      self.rightDoorOpen = love.keyboard.isDown("d") or love.keyboard.isDown("right")

      if (self.leftDoorOpen and not self.wasLeftDown) or (self.rightDoorOpen and not self.wasRightDown) then
        love.audio.play(OPEN_SOUND)
      end
      if (not self.leftDoorOpen and self.wasLeftDown) or (not self.rightDoorOpen and self.wasRightDown) then
        love.audio.play(CLOSE_SOUND)
      end

      self.wasLeftDown = self.leftDoorOpen
      self.wasRightDown = self.rightDoorOpen

      if self.leftDoorOpen then
        self.leftDoorPct = lerp(self.leftDoorPct, 1, 10 * dt)
      else
        self.leftDoorPct = lerp(self.leftDoorPct, 0, 10 * dt)
      end
      if self.rightDoorOpen then
        self.rightDoorPct = lerp(self.rightDoorPct, 1, 10 * dt)
      else
        self.rightDoorPct = lerp(self.rightDoorPct, 0, 10 * dt)
      end

      --- Slow down based on capacity
      self.y = self.y + self.vy * dt * 100 * (1 - #self.aliens / 22)
      --self.vy = self.vy * 0.98

      --- Stop at bottom
      if self.y > 0 then
        self.y = 0

        --- Bounce
        if self.vy > 0 then
          self.vy = -self.vy * 0.5
        end
      end

      --if self.y < ceilingHeight + self.h then
      --  self.y = ceilingHeight + self.h
      --
      --  --- Bounce
      --  if self.vy < 0 then
      --    self.vy = -self.vy * 0.5
      --  end
      --end

      self.floor = 1 + round(-self.y / HALLWAY_HEIGHT)
      self.floorDiff = math.abs((self.y + (self.floor - 1) * HALLWAY_HEIGHT) / HALLWAY_HEIGHT)
      --DEBUG[2] = "floor: " .. tostring(self.floor)
      --DEBUG[3] = "FloorDiff: " .. tostring(self.floorDiff)

      --- Stop at the ceiling
      --if self.y < ceilingHeight + self.h then
      --  self.vy = self.vy + dt * 12
      --else
      --  --- Friction
      --  if noInputs then
      --    --self.y = lerp(self.y, (-currentFloor + 1) * HALLWAY_HEIGHT, 4 * dt)
      --    self.vy = lerp(self.vy, 0, dt * 3)
      --  else
      --    self.vy = lerp(self.vy, 0, dt * 3)
      --  end
      --end


      --- Stop at the ceiling
      if self.y < ceilingHeight + self.h then
        self.y = ceilingHeight + self.h

        --- Bounce
        if self.vy < 0 then
          self.vy = -self.vy * 0.5
        end
      end

      --- Friction
      if noInputs then
        --self.y = lerp(self.y, (-currentFloor + 1) * HALLWAY_HEIGHT, 4 * dt)
        self.vy = lerp(self.vy, 0, dt * 3)
      else
        self.vy = lerp(self.vy, 0, dt * 3)
      end


      --- Set seat index
      for i = 1, #self.aliens do
        self.aliens[i].seatIndex = i
      end
    end

    unit.draw = function(self)
      --love.graphics.push()
      --love.graphics.translate(self.x, self.y)
      --love.graphics.rotate(time)
      --love.graphics.translate(-self.x, -self.y)

      local sx, sy, sw, sh = love.graphics.getScissor()

      local currentX, currentY = cam:getPosition()
      love.graphics.setScissor(love.graphics.getWidth() / 2 - self.w / 2, love.graphics.getHeight() / 2 + self.y - currentY - self.h, self.w, self.h)

      love.graphics.draw(ELEVATOR_IMAGE, self.x, self.y, 0, 1, 1, self.w / 2, self.h)

      love.graphics.setColor(0.2, 0.2, 0.2)
      love.graphics.draw(ELEVATOR_IMAGE, self.x - self.w / 2, self.y - self.h * self.leftDoorPct, 0, 0.1, 1, self.w / 2, self.h)
      love.graphics.draw(ELEVATOR_IMAGE, self.x + self.w / 2, self.y - self.h * self.rightDoorPct, 0, 0.1, 1, self.w / 2, self.h)
      love.graphics.setColor(1, 1, 1)

      love.graphics.setScissor(sx, sy, sw, sh)

      --love.graphics.pop()
    end

    return unit
  end
}