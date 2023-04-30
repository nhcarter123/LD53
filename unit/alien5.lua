return {
  create = function(x, y)
    local unit = Alien.create(x, y, ALIEN5_IMAGE)
    unit.color = 'pink'
    unit.height = -120

    return unit
  end
}