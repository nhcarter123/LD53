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

    unit.move = function(self, x, y)
      self.x = self.x + x
      --self.y = self.y + y

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

      self.leftDoorOpen = love.keyboard.isDown("a")
      self.rightDoorOpen = love.keyboard.isDown("d")

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

      DEBUG[2] = "DoorPct: " .. tostring(self.doorPct)

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
        self.vy = lerp(self.vy, 0, dt * 7)
      else
        self.vy = lerp(self.vy, 0, dt * 7)
      end

      --- Set seat index
      for i = 1, #self.aliens do
        self.aliens[i].seatIndex = i
      end
    end

    unit.draw = function(self)
      local sx, sy, sw, sh = love.graphics.getScissor()

      local currentX, currentY = cam:getPosition()
      love.graphics.setScissor(WIDTH / 2 - self.w / 2, HEIGHT / 2 + self.y - currentY - self.h, self.w, self.h)

      love.graphics.draw(ELEVATOR_IMAGE, self.x, self.y, 0, 1, 1, self.w / 2, self.h)

      love.graphics.setColor(0.2, 0.2, 0.2)
      love.graphics.draw(ELEVATOR_IMAGE, self.x - self.w / 2, self.y - self.h * self.leftDoorPct, 0, 0.1, 1, self.w / 2, self.h)
      love.graphics.draw(ELEVATOR_IMAGE, self.x + self.w / 2, self.y - self.h * self.rightDoorPct, 0, 0.1, 1, self.w / 2, self.h)
      love.graphics.setColor(1, 1, 1)

      love.graphics.setScissor(sx, sy, sw, sh)
    end

    return unit
  end
}