require("miscmath")
Gamera = require("gamera")
Player = require("unit/player")
Alien = require("unit/alien")
Alien1 = require("unit/alien1")
Alien2 = require("unit/alien2")
AlienManager = require("alienManager")
HallwayManager = require("hallwayManager")
BehaviorManager = require("behaviorManager")
Hallway = require("hallway")

time = 0

hud = {}
TABS = {}
DEBUG = {}

WIDTH = 1280
HEIGHT = 720
love.window.setMode(WIDTH, HEIGHT)

local camW = 2000
local camH = 8000
cam = Gamera.new(-camW/2, -camH/2, camW, camH)

function love.wheelmoved(x, y)
end

function love.textinput(t)
  --if TEXT_INPUT_TARGET then
  --  TEXT_INPUT_TARGET.t = TEXT_INPUT_TARGET.t .. t
  --  TEXT_INPUT_TARGET.onType(TEXT_INPUT_TARGET.t)
  --end
end

W_IS_DOWN = false
S_IS_DOWN = false
A_IS_DOWN = false
D_IS_DOWN = false

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end

  if key == "space" then
  end

  if key == "w" then
    W_IS_DOWN = true
  end
  if key == "a" then
    A_IS_DOWN = true
  end
  if key == "s" then
    S_IS_DOWN = true
  end
  if key == "d" then
    D_IS_DOWN = true
  end
end

function love.keyreleased(key, scancode, isrepeat)
  if key == "w" then
    W_IS_DOWN = false
  end
  if key == "a" then
    A_IS_DOWN = false
  end
  if key == "s" then
    S_IS_DOWN = false
  end
  if key == "d" then
    D_IS_DOWN = false
  end
end

function love.mousereleased(x, y, button, istouch)
end

FLOOR_COUNT = 10
HALLWAY_HEIGHT = 190
--PAUSED = true

function love.load()
  --math.randomseed(os.time())
  --love.graphics.setDefaultFilter("linear", "linear", 4)
  love.graphics.setDefaultFilter("nearest", "nearest", 1)
  love.graphics.setBackgroundColor(46 / 255, 50 / 255, 35 / 255)
  love.keyboard.setKeyRepeat(true)


  --POINTER_CURSOR = love.mouse.getSystemCursor("hand")

  DEFAULT_FONT = love.graphics.newFont("resources/fonts/ls.ttf", 16)
  --LOG_FONT = love.graphics.newFont("resources/fonts/4.ttf", 20)
  --LOG_FONT:setLineHeight(1.2)

  love.graphics.setFont(DEFAULT_FONT)

  ---- Units
  HALLWAY_IMAGE = love.graphics.newImage("resources/images/hallway.png")
  HALLWAY_G_IMAGE = love.graphics.newImage("resources/images/hallway_g.png")
  HALLWAY_Y_IMAGE = love.graphics.newImage("resources/images/hallway_y.png")
  HALLWAY_P_IMAGE = love.graphics.newImage("resources/images/hallway_p.png")
  ALIEN1_IMAGE = love.graphics.newImage("resources/images/alien1.png")
  ALIEN2_IMAGE = love.graphics.newImage("resources/images/alien2.png")
  ALIEN3_IMAGE = love.graphics.newImage("resources/images/alien3.png")
  ELEVATOR_IMAGE = love.graphics.newImage("resources/images/elevator_back.png")
  DIR_IMAGE = love.graphics.newImage("resources/images/dir.png")
  HAPPY_IMAGE = love.graphics.newImage("resources/images/happy.png")
  BEMUSED_IMAGE = love.graphics.newImage("resources/images/bemused.png")
  ANGRY_IMAGE = love.graphics.newImage("resources/images/angry.png")
  UI_PANEL_IMAGE = love.graphics.newImage("resources/images/ui_panel.png")

  ELEVATOR = Player.create(0, 0)

  HallwayManager:init()

  --HallwayManager.floors[1].left:addAlien()
  --HallwayManager.floors[2].left:addAlien()
  --HallwayManager.floors[3].left:addAlien()
  --HallwayManager.floors[4].left:addAlien()
  --HallwayManager.floors[2].right:addAlien()
  --HallwayManager.floors[4].right:addAlien()

  --table.insert(AlienManager.aliens, Alien.create(-300, 0))
  --table.insert(AlienManager.aliens, Alien.create(-350, 0))
  --table.insert(AlienManager.aliens, Alien.create(-400, 0))
  --table.insert(AlienManager.aliens, Alien.create(-450, 0))
end

-- UPDATE ######################################################################
function love.update(dt)
  time = time + dt

  if not PAUSED then
    local ceilingHeight = -FLOOR_COUNT * HALLWAY_HEIGHT

    local yVel = 0
    if W_IS_DOWN then
      yVel = -1
    end
    if S_IS_DOWN then
      yVel = 1
    end

    ELEVATOR:move(0, yVel)
    ELEVATOR:update(dt, ceilingHeight, yVel == 0)

    AlienManager:update(dt)
    HallwayManager:update()

    --DEBUG[2] = "Floor: " .. tostring(1 + round(-ELEVATOR.y / HALLWAY_HEIGHT))

    --- Position the camera
    local currentX, currentY = cam:getPosition()
    local camX = lerp(currentX, ELEVATOR.x, 5 * dt)
    local camY = lerp(currentY, ELEVATOR.y - 100, 5 * dt)
    cam:setPosition(camX, camY)

    --cam:setPosition(0, 0)

    --for i = 1, 100 do
    --  BALLS[i]:update()
    --end
  end

  DEBUG[1] = "Current FPS: " .. tostring(love.timer.getFPS())
end

local function drawCameraStuff(l, t, w, h)
  --drawHallways(FLOOR_COUNT)
  HallwayManager:draw()

  --love.graphics.rectangle("fill", -5000, -5000, 100000, 1000000)
  ELEVATOR:draw()
  AlienManager:draw()
end

function love.draw()
  cam:draw(drawCameraStuff)

  if PAUSED then
    BehaviorManager:draw()
  end

  --for i = 1, 100 do
  --  BALLS[i]:draw()
  --end

  -- Loves Falling
  -- Loves/Hates other alien type
  -- Loves/Hates crowds
  -- Loves/Hates waiting


  --love.graphics.rectangle('fill', WIDTH / 2, HEIGHT / 2, 400, 200)

  --love.graphics.rectangle("fill", 30, HEIGHT, 4, 4)

  for i = 1, #DEBUG do
    love.graphics.print(DEBUG[i], love.graphics.getWidth() - 160, 10 + (i - 1) * 20)
  end
end

--function drawHallways(floorCount)
--  local spacingX = 500
--
--  for i = 1, floorCount do
--    local yOffset = -HALLWAY_HEIGHT * (i - 1)
--    love.graphics.draw(HALLWAY_IMAGE, -spacingX, yOffset, 0, 1, 1, 300, 200)
--    love.graphics.draw(HALLWAY_IMAGE, spacingX, yOffset, 0, 1, 1, 300, 200)
--  end
--  --love.graphics.circle("fill", 0, 0, 10)
--end

function _if(bool, func1, func2)
  if bool then return func1() else return func2() end
end