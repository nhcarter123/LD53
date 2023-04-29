return {


    update = function(self, dt)

    end,

    draw = function(self)
      local textHeight = 100
      local spacing = 140
      local cx = WIDTH / 2
      local cy = HEIGHT / 2
      local oy = -30
      --local b1 = math.sin(time * 3 + 3) * 8
      love.graphics.setColor(0, 0, 0, 0.2)
      love.graphics.draw(UI_PANEL_IMAGE, cx + 15, cy + 25, 0, 1, 1, 300, 150)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(UI_PANEL_IMAGE, cx, cy, 0, 1, 1, 300, 150)

      love.graphics.draw(ALIEN1_IMAGE, cx - spacing, cy + oy, 0, 1, 1, 107/2, 147/2)
      love.graphics.draw(HAPPY_IMAGE, cx, cy + oy, 0, 2, 2, 27 / 2, 24 / 2)
      love.graphics.draw(ALIEN2_IMAGE, cx + spacing, cy + oy, 0, 1, 1, 107/2, 147/2)

      love.graphics.setColor(0, 0, 0)
      love.graphics.print("Glorbles", cx - spacing - DEFAULT_FONT:getWidth("Glorbles") / 2, cy + textHeight + oy)
      love.graphics.print("Love", cx - DEFAULT_FONT:getWidth("Love") / 2, cy + textHeight + oy)
      love.graphics.print("Smeezers.", cx + spacing - DEFAULT_FONT:getWidth("Smeezers.") / 2, cy + textHeight + oy)
      love.graphics.setColor(1, 1, 1)
    end,
}