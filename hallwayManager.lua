return {
    floors = {},

    init = function(self)
      local spacingX = 500

      local availableHallways = {}

      --- instantiate
      for i = 1, FLOOR_COUNT do
        local yOffset = -HALLWAY_HEIGHT * (i - 1)
        local left = Hallway.create(-spacingX, yOffset, i)
        local right = Hallway.create(spacingX, yOffset, i)

        self.floors[i] = {
          left = left,
          right = right,
        }
        table.insert(availableHallways, left)
        table.insert(availableHallways, right)
      end

      local exitColors = {
        'green',
        --'green',
        'yellow',
        --'yellow',
        'purple',
        --'purple',
        'aqua',
        --'aqua',
      }

      shuffle(availableHallways)
      local playground = table.remove(availableHallways, #availableHallways)
      playground.isPlayground = true

      for i = 1, #exitColors do
        local targetHallway = table.remove(availableHallways, #availableHallways)

        local side = 'right'
        if math.random() > 0.5 then
          side = 'left'
        end

        targetHallway.isExit = true
        targetHallway.color = exitColors[i]
      end

      AlienManager.entryPoints = availableHallways

      --- initialize
      for i = 1, FLOOR_COUNT do
        self.floors[i].left:init()
        self.floors[i].right:init()
      end
    end,

    update = function(self, dt)
      for i = 1, #self.floors do
        local floor = self.floors[i]
        floor.left:update(dt)
        floor.right:update(dt)
      end
    end,

    draw = function(self)
      for i = 1, #self.floors do
        local floor = self.floors[i]
        floor.left:draw()
        floor.right:draw()
      end
    end,
}