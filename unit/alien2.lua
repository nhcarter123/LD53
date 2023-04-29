return {
  create = function(x, y)
    local unit = Alien.create(x, y, ALIEN2_IMAGE)
    unit.color = 'yellow'
    unit.height = -110

    --local baseUpdate = unit.update()
    --
    --unit.update = function(self, dt)
    --  baseUpdate(dt)
    --end

    return unit
  end
}