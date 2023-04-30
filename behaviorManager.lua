return {
    behaviors = {},
    currentBehavior = 1,
    fallingHappinessMap = {
      yellow = 0.35,
      green = 0.1,
      purple = 0.1,
      aqua = 0.1,
    },

    init = function(self)
      self.currentBehavior = 1
      self.behaviors = {
        {
          leftImg = ALIEN1_IMAGE,
          leftText = "Glorbles",
          leftOx = 107/2,
          leftOy = 147/2,

          loves = true,

          rightImg = ALIEN2_IMAGE,
          rightText = "Smeezers.",
          rightOx = 107/2,
          rightOy = 147/2,
        },
        {
          leftImg = ALIEN2_IMAGE,
          leftText = "Smeezers",
          leftOx = 107/2,
          leftOy = 147/2,

          loves = true,

          rightImg = FALLING_IMAGE,
          rightText = "falling.",
          rightOx = 20,
          rightOy = 20,
        },
        {
          leftImg = ALIEN3_IMAGE,
          leftText = "Oggles",
          leftOx = 107/2,
          leftOy = 147/2,

          loves = false,

          rightImg = CLOCK_IMAGE,
          rightText = "waiting.",
          rightOx = 20,
          rightOy = 20
        },
        {
          leftImg = ALIEN4_IMAGE,
          leftText = "Blormas",
          leftOx = 107/2,
          leftOy = 147/2,

          loves = false,

          rightImg = ALIEN1_IMAGE,
          rightText = "Glorbles.",
          rightOx = 107/2,
          rightOy = 147/2,
        }
      }
    end,

    addNewBehavior = function(self)
      if #self.fallingHappinessMap < TOTAL_COLORS then

      end
    end,

    update = function(self, dt)

    end,

    next = function(self)
      if not self.open then
        return
      end

      love.audio.play(BLIP_SOUND)

      if self.currentBehavior < #self.behaviors then
        self.currentBehavior = self.currentBehavior + 1
      else
        PAUSED = false
        self.open = false
      end
    end,

    draw = function(self)
      if self.currentBehavior > #self.behaviors or not self.open then
        return
      end

      local behavior = self.behaviors[self.currentBehavior]

      local shakeX = math.random() * 1.5
      local shakeY = math.random() * 1.5

      local centerImg = ANGRY_IMAGE
      local centerText = 'hate'
      if behavior.loves then
        centerImg = HAPPY_IMAGE
        centerText = 'love'
        shakeX = math.sin(time * 2) * 16
        shakeY = math.sin(time * 1) * 16
      end

      local textHeight = 100
      local spacing = 120
      local cx = WIDTH / 2
      local cy = HEIGHT / 2
      local oy = -30
      local b1 = 1 + math.sin(time * 2) / 20
      local b2 = 1 + math.sin(time * 2 + 1) / 20
      local b3 = 1 + math.sin(time * 2 + 2) / 20
      love.graphics.setColor(0, 0, 0, 0.2)
      love.graphics.draw(UI_PANEL_IMAGE, cx - 8, cy + 8, 0, 1, 1, 300, 150)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(UI_PANEL_IMAGE, cx, cy, 0, 1, 1, 300, 150)

      love.graphics.draw(behavior.leftImg, cx - spacing, cy + oy, 0, 1 * b1, 1 * b1, behavior.leftOx, behavior.leftOy)
      love.graphics.draw(centerImg, cx + shakeX, cy + oy + shakeY, 0, 1.5, 1.5, 27 / 2, 24 / 2)
      love.graphics.draw(behavior.rightImg, cx + spacing, cy + oy, 0, 1 * b3, 1 * b3, behavior.rightOx, behavior.rightOy)

      love.graphics.setColor(0, 0, 0)
      love.graphics.print(behavior.leftText, cx - spacing - DEFAULT_FONT:getWidth(behavior.leftText) / 4, cy + textHeight + oy, 0, 0.5, 0.5)
      love.graphics.print(centerText, cx - DEFAULT_FONT:getWidth(centerText) / 4, cy + textHeight + oy, 0, 0.5, 0.5)
      love.graphics.print(behavior.rightText, cx + spacing - DEFAULT_FONT:getWidth(behavior.rightText) / 4, cy + textHeight + oy, 0, 0.5, 0.5)
      love.graphics.setColor(1, 1, 1)
    end,
}