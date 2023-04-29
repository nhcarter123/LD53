return {
  create = function(x, y)
    local unit = Alien.create(x, y, ALIEN2_IMAGE)
    unit.color = 'yellow'
    unit.height = -110

    return unit
  end
}