return {
  create = function(x, y)
    local unit = Alien.create(x, y, ALIEN1_IMAGE)
    unit.color = 'green'

    return unit
  end
}