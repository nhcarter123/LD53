return {
    behaviors = {},
    currentBehavior = 1,

    init = function(self)
      self.behaviors = {
        {
          leftImg = ALIEN1_IMAGE,
          leftText = "Glorbles",
          leftOx = 107/2,
          leftOy = 147/2,

          emotion = 'loves',
          centerText = 'love',

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

          emotion = 'loves',
          centerText = 'love',

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

          emotion = 'hates',
          centerText = 'hate',

          rightImg = CLOCK_IMAGE,
          rightText = "waiting.",
          rightOx = 20,
          rightOy = 20
        }
      }
    end,

    update = function(self, dt)

    end,

    next = function(self)
      if self.currentBehavior < #self.behaviors then
        self.currentBehavior = self.currentBehavior + 1
      else
        PAUSED = false
      end
    end,

    draw = function(self)
      if self.currentBehavior > #self.behaviors then
        return
      end

      local behavior = self.behaviors[self.currentBehavior]

      local centerImg = HAPPY_IMAGE
      if behavior.emotion == 'hates' then
        centerImg = ANGRY_IMAGE
      end

      local textHeight = 100
      local spacing = 120
      local cx = WIDTH / 2
      local cy = HEIGHT / 2
      local oy = -30
      --local b1 = math.sin(time * 3 + 3) * 8
      love.graphics.setColor(0, 0, 0, 0.2)
      love.graphics.draw(UI_PANEL_IMAGE, cx - 12, cy + 12, 0, 1, 1, 300, 150)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(UI_PANEL_IMAGE, cx, cy, 0, 1, 1, 300, 150)

      love.graphics.draw(behavior.leftImg, cx - spacing, cy + oy, 0, 1, 1, behavior.leftOx, behavior.leftOy)
      love.graphics.draw(centerImg, cx, cy + oy, 0, 1.5, 1.5, 27 / 2, 24 / 2)
      love.graphics.draw(behavior.rightImg, cx + spacing, cy + oy, 0, 1, 1, behavior.rightOx, behavior.rightOy)

      love.graphics.setColor(0, 0, 0)
      love.graphics.print(behavior.leftText, cx - spacing - DEFAULT_FONT:getWidth(behavior.leftText) / 2, cy + textHeight + oy)
      love.graphics.print(behavior.centerText, cx - DEFAULT_FONT:getWidth(behavior.centerText) / 2, cy + textHeight + oy)
      love.graphics.print(behavior.rightText, cx + spacing - DEFAULT_FONT:getWidth(behavior.rightText) / 2, cy + textHeight + oy)
      love.graphics.setColor(1, 1, 1)
    end,
}