return {
  create = function(x, y)
    local unit = {
      x = x,
      y = y,
      height = 0,
      vx = (math.random() - 0.5) * 0.2
    }

    unit.move = function(self, x, y)

    end

    unit.update = function(self)
      self.y = self.y + 0.2;
      self.x = self.x + self.vx
    end

    unit.draw = function(self)
      love.graphics.rectangle('fill', self.x, self.y, 5, 5)
    end

    return unit
  end
}