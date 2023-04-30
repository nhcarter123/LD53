return {
  create = function(x, y)
    local unit = Alien.create(x, y, ALIEN3_IMAGE)
    unit.color = 'purple'
    unit.height = -150
    unit.patienceInterval = 20

    return unit
  end
}