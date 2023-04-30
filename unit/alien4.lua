return {
  create = function(x, y)
    local unit = Alien.create(x, y, ALIEN4_IMAGE)
    unit.color = 'aqua'
    unit.height = -90

    return unit
  end
}