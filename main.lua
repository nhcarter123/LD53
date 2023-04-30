require("miscmath")
Gamera = require("gamera")
Player = require("unit/player")
Alien = require("unit/alien")
Alien1 = require("unit/alien1")
Alien2 = require("unit/alien2")
Alien3 = require("unit/alien3")
Alien4 = require("unit/alien4")
AlienManager = require("alienManager")
HallwayManager = require("hallwayManager")
BehaviorManager = require("behaviorManager")
Hallway = require("hallway")
StarShader = require("shaders/starShader")

time = 0

hud = {}
TABS = {}
DEBUG = {}
SPLASH = true
SELECTED_LEVEL = 1

WIDTH = 1280
HEIGHT = 720
love.window.setMode(WIDTH, HEIGHT, {
  --fullscreen = true
})

local camW = 3000
local camH = 12000
cam = Gamera.new(-camW / 2, -camH / 2, camW, camH)

function love.wheelmoved(x, y)
end

function love.textinput(t)
  --if TEXT_INPUT_TARGET then
  --  TEXT_INPUT_TARGET.t = TEXT_INPUT_TARGET.t .. t
  --  TEXT_INPUT_TARGET.onType(TEXT_INPUT_TARGET.t)
  --end
end

W_HELD = 0
S_HELD = 0
W_IS_DOWN = false
S_IS_DOWN = false

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    if SPLASH then
      love.event.quit()
      return
    end
    if LEVEL_SELECT then
      LEVEL_SELECT = false
      SPLASH = true
      return
    end

    if not ARE_YOU_SURE then
      PAUSED = true
      ARE_YOU_SURE = true
      return
    end
  end

  if SPLASH then
    SPLASH = false
    LEVEL_SELECT = true
    love.audio.play(BLIP_SOUND)
    return
  end

  --BehaviorManager.open = true

  if LEVEL_SELECT then
    if key == "a" or key == "left" then
      if SELECTED_LEVEL == 2 then
        SELECTED_LEVEL = 1
        love.audio.play(BLIP_SOUND)
      end
    end
    if key == "d" or key == "right" then
      if SELECTED_LEVEL == 1 then
        SELECTED_LEVEL = 2
        love.audio.play(BLIP_SOUND)
      end
    end

    if key == "space" or key == "return" then
      LEVEL_SELECT = false
      love.audio.play(BLIP_SOUND)
      resetGame()
    end

    return
  end

  if ARE_YOU_SURE then
    if key == "backspace" then
      LEVEL_SELECT = true
    end

    if key == "space" or key == "return" or key == "escape" then
      PAUSED = false
      ARE_YOU_SURE = false
      love.audio.play(BLIP_SOUND)
    end
  end

  BehaviorManager:next()

  --if key == "r" then
  --  resetGame()
  --end

  if key == "w" or key == "up" then
    W_IS_DOWN = true
  end
  if key == "s" or key == "down" then
    S_IS_DOWN = true
  end
end

function love.keyreleased(key, scancode, isrepeat)
  if key == "w" or key == "up"  then
    W_IS_DOWN = false
  end
  if key == "s" or key == "down" then
    S_IS_DOWN = false
  end
end

function love.mousereleased(x, y, button, istouch)
end

GAME_MODE = 1
FLOOR_COUNT = 8
PLAYGROUND_COUNT = 1
HALLWAY_HEIGHT = 190
PAUSED = true

function love.load()
  math.randomseed(os.time())
  --love.graphics.setDefaultFilter("linear", "linear", 4)
  love.graphics.setDefaultFilter("nearest", "nearest", 1)
  --love.graphics.setBackgroundColor(46 / 255, 50 / 255, 35 / 255)
  love.keyboard.setKeyRepeat(true)

  SOUNDTRACK_1 = love.audio.newSource("resources/sounds/track1.mp3", "stream")
  HAPPY_SOUND_1 = love.audio.newSource("resources/sounds/happy1.mp3", "static")
  HAPPY_SOUND_2 = love.audio.newSource("resources/sounds/happy2.mp3", "static")
  HAPPY_SOUND_3 = love.audio.newSource("resources/sounds/happy3.mp3", "static")
  HAPPY_SOUND_4 = love.audio.newSource("resources/sounds/happy4.mp3", "static")
  HAPPY_SOUND_5 = love.audio.newSource("resources/sounds/happy5.mp3", "static")
  ANGRY_SOUND_1 = love.audio.newSource("resources/sounds/angry1.mp3", "static")
  ANGRY_SOUND_2 = love.audio.newSource("resources/sounds/angry2.mp3", "static")
  ANGRY_SOUND_3 = love.audio.newSource("resources/sounds/angry3.mp3", "static")
  DEATH_SOUND_1 = love.audio.newSource("resources/sounds/death1.mp3", "static")
  DEATH_SOUND_2 = love.audio.newSource("resources/sounds/death2.mp3", "static")
  DEATH_SOUND_3 = love.audio.newSource("resources/sounds/death3.mp3", "static")
  BEMUSED_SOUND_1 = love.audio.newSource("resources/sounds/bemused1.mp3", "static")
  BEMUSED_SOUND_2 = love.audio.newSource("resources/sounds/bemused2.mp3", "static")
  BEMUSED_SOUND_3 = love.audio.newSource("resources/sounds/bemused3.mp3", "static")
  BEMUSED_SOUND_4 = love.audio.newSource("resources/sounds/bemused4.mp3", "static")
  BEMUSED_SOUND_5 = love.audio.newSource("resources/sounds/bemused5.mp3", "static")
  BEMUSED_SOUND_6 = love.audio.newSource("resources/sounds/bemused6.mp3", "static")
  OPEN_SOUND = love.audio.newSource("resources/sounds/open.mp3", "static")
  CLOSE_SOUND = love.audio.newSource("resources/sounds/close.mp3", "static")
  BLIP_SOUND = love.audio.newSource("resources/sounds/blip.mp3", "static")

  SOUNDTRACK_1:setLooping(true)
  SOUNDTRACK_1:play()

  --POINTER_CURSOR = love.mouse.getSystemCursor("hand")

  DEFAULT_FONT = love.graphics.newFont("resources/fonts/ls.ttf", 32)
  --LOG_FONT = love.graphics.newFont("resources/fonts/4.ttf", 20)
  --LOG_FONT:setLineHeight(1.2)

  love.graphics.setFont(DEFAULT_FONT)

  EMPTY_TEXTURE_IMAGE = love.graphics.newImage("resources/images/empty_tex.png")
  SPLASH_IMAGE = love.graphics.newImage("resources/images/splash.png")
  HALLWAY_IMAGE = love.graphics.newImage("resources/images/hallway.png")
  HALLWAY_2_IMAGE = love.graphics.newImage("resources/images/hallway2.png")
  PLAYGROUND_IMAGE = love.graphics.newImage("resources/images/playground.png")
  --HALLWAY_IMAGE = love.graphics.newImage("resources/images/hallway.png")
  --HALLWAY_G_IMAGE = love.graphics.newImage("resources/images/hallway_g.png")
  --HALLWAY_Y_IMAGE = love.graphics.newImage("resources/images/hallway_y.png")
  --HALLWAY_P_IMAGE = love.graphics.newImage("resources/images/hallway_p.png")
  ELEVATOR_SHAFT_IMAGE = love.graphics.newImage("resources/images/elevator_shaft.png")
  ALIEN1_IMAGE = love.graphics.newImage("resources/images/alien1.png")
  ALIEN2_IMAGE = love.graphics.newImage("resources/images/alien2.png")
  ALIEN3_IMAGE = love.graphics.newImage("resources/images/alien3.png")
  ALIEN4_IMAGE = love.graphics.newImage("resources/images/alien4.png")
  CLOCK_IMAGE = love.graphics.newImage("resources/images/clock.png")
  ELEVATOR_IMAGE = love.graphics.newImage("resources/images/elevator_back.png")
  DIR_IMAGE = love.graphics.newImage("resources/images/dir.png")
  HAPPY_IMAGE = love.graphics.newImage("resources/images/happy.png")
  BEMUSED_IMAGE = love.graphics.newImage("resources/images/bemused.png")
  ANGRY_IMAGE = love.graphics.newImage("resources/images/angry.png")
  SKULL_IMAGE = love.graphics.newImage("resources/images/skull.png")
  UI_PANEL_IMAGE = love.graphics.newImage("resources/images/ui_panel.png")
  BUBBLE_IMAGE = love.graphics.newImage("resources/images/bubble.png")
  FALLING_IMAGE = love.graphics.newImage("resources/images/falling.png")

  ELEVATOR = Player.create(0, 0)

  HallwayManager:init()
  BehaviorManager:init()

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
      yVel = -1 - W_HELD * 1.2
      W_HELD = W_HELD + dt
      S_HELD = 0
    else
      W_HELD = 0
    end
    if S_IS_DOWN then
      yVel = 1 + S_HELD * 1.2
      S_HELD = S_HELD + dt
      W_HELD = 0
    else
      S_HELD = 0
    end

    ELEVATOR:move(ceilingHeight, yVel)
    ELEVATOR:update(dt, ceilingHeight, yVel == 0)

    AlienManager:update(dt)
    HallwayManager:update(dt)

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

  local camX, camY = cam:getPosition()
  StarShader:send("time", time)
  StarShader:send("zoom", cam:getScale())
  StarShader:send("position", { camX * 2, camY * 2 })
  StarShader:send("slope", love.graphics.getWidth() / love.graphics.getHeight())

  if LEVEL_SELECT then
    --LEVEL_SELECT = false
    --BehaviorManager.open = true
    StarShader:send("position", { time * 500, 0 })
  end

  --DEBUG[1] = "Current FPS: " .. tostring(love.timer.getFPS())
end

local function drawCameraStuff(l, t, w, h)
  local currentX, currentY = cam:getPosition()
  local sx, sy, sw, sh = love.graphics.getScissor()
  local buildingHeight = HALLWAY_HEIGHT * (FLOOR_COUNT)
  love.graphics.setScissor(0, -currentY - buildingHeight + (HALLWAY_HEIGHT * 2) - 30, love.graphics.getWidth(), buildingHeight)

  for i = 1, 1 + FLOOR_COUNT / 2 do
    local yOffset = -HALLWAY_HEIGHT * (i - 1.5) * 2 + ELEVATOR.y / 6
    love.graphics.draw(ELEVATOR_SHAFT_IMAGE, 0, yOffset, 0, 1, 1, 390 / 2, 380 / 2)
  end
  love.graphics.setScissor(sx, sy, sw, sh)


  --drawHallways(FLOOR_COUNT)
  HallwayManager:draw()

  --love.graphics.rectangle("fill", -5000, -5000, 100000, 1000000)
  ELEVATOR:draw()
  AlienManager:draw()
end

function love.draw()
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()
  love.graphics.setShader(StarShader)
  love.graphics.draw(EMPTY_TEXTURE_IMAGE, 0, 0, 0, screenWidth, screenHeight)
  love.graphics.setShader()

  --actual_width = love.graphics.getWidth()
  --actual_height = love.graphics.getHeight()
  --desired_width = 1280
  --desired_height = 720
  --
  --local xscale = actual_width/desired_width
  --local yscale = actual_height/desired_height
  --local scale = math.min(xscale, yscale)
  --local xoffset = (actual_width-desired_width*scale)/2
  --local yoffset = (actual_height-desired_height*scale)/2
  --love.graphics.translate(xoffset, yoffset)
  --love.graphics.scale(scale, scale)
  --
  --cam:setScale(scale)

  if SPLASH then
    love.graphics.draw(SPLASH_IMAGE, 0, 0, 0, 2, 2)
    love.graphics.print("Press any key", screenWidth / 2 - DEFAULT_FONT:getWidth("Press any key") / 2, 80 + math.sin(time) * 10, 0, 1, 1)
    --love.graphics.printf("Press any key", love.graphics.getWidth() / 2, 80, 200, 'center')
    return
  end

  if LEVEL_SELECT then
    drawPanel(screenWidth, screenHeight, SELECTED_LEVEL == 1, -270, "Apartments", {
      "- 8x floors",
      "- 1x playground",
    })
    drawPanel(screenWidth, screenHeight, SELECTED_LEVEL == 2, 270, "Skyscraper", {
      "- 20x floors",
      "- 2x playground",
    })
    return
  end

  cam:draw(drawCameraStuff)

  if PAUSED then
    BehaviorManager:draw()
  end

  --- Draw UI
  love.graphics.draw(HAPPY_IMAGE, 20, 20, 0, 1, 1)
  love.graphics.draw(BEMUSED_IMAGE, 120, 20, 0, 1, 1)
  love.graphics.draw(ANGRY_IMAGE, 220, 20, 0, 1, 1)
  love.graphics.draw(SKULL_IMAGE, 320, 20, 0, 1, 1)
  --- Text
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.print(TOTAL_SMILIES, 65 + 2, 28 + 2, 0, 0.5, 0.5)
  love.graphics.print(TOTAL_BEMUSED, 165 + 2, 28 + 2, 0, 0.5, 0.5)
  love.graphics.print(TOTAL_FROWNIES, 265 + 2, 28 + 2, 0, 0.5, 0.5)
  love.graphics.print(TOTAL_DEATHS .. " / " .. tostring(GAME_OVER_DEATHS), 365 + 2, 28 + 2, 0, 0.5, 0.5)

  love.graphics.setColor(1, 1, 1)
  love.graphics.print(TOTAL_SMILIES, 65, 28, 0, 0.5, 0.5)
  love.graphics.print(TOTAL_BEMUSED, 165, 28, 0, 0.5, 0.5)
  love.graphics.print(TOTAL_FROWNIES, 265, 28, 0, 0.5, 0.5)
  love.graphics.print(tostring(TOTAL_DEATHS) .. " / " .. tostring(GAME_OVER_DEATHS), 365, 28, 0, 0.5, 0.5)

  --for i = 1, 100 do
  --  BALLS[i]:draw()
  --end

  -- Loves Falling
  -- Loves/Hates other alien type
  -- Loves/Hates crowds
  -- Loves/Hates waiting

  --love.graphics.rectangle('fill', WIDTH / 2, HEIGHT / 2, 400, 200)

  --love.graphics.rectangle("fill", 30, HEIGHT, 4, 4)

  if ARE_YOU_SURE then
    love.graphics.setColor(0.3, 0.3, 0.3, 0.85)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Paused", screenWidth / 2 - DEFAULT_FONT:getWidth("Paused") / 2, screenHeight / 2 - 180, 0, 1, 1)
    love.graphics.print("Exit [backspace]", screenWidth / 2 - 0.5 * DEFAULT_FONT:getWidth("Exit [backspace]") / 2 - 110, screenHeight / 2 + 180, 0, 0.5, 0.5)
    love.graphics.print("Resume [space]", screenWidth / 2 - 0.5 * DEFAULT_FONT:getWidth("Resume [space]") / 2 + 110, screenHeight / 2 + 180, 0, 0.5, 0.5)
  end

  for i = 1, #DEBUG do
    love.graphics.print(DEBUG[i], screenWidth - 160, 10 + (i - 1) * 20)
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

function resetGame()
  if SELECTED_LEVEL == 1 then
    FLOOR_COUNT = 8
    PLAYGROUND_COUNT = 1
  else
    FLOOR_COUNT = 20
    PLAYGROUND_COUNT = 2
  end

  BehaviorManager.open = true
  LEVEL_SELECT = false
  ELEVATOR.aliens = {}
  AlienManager.aliens = {}
  HallwayManager:init()
  BehaviorManager:init()
  TOTAL_DEATHS = 0
  TOTAL_FROWNIES = 0
  TOTAL_BEMUSED = 0
  TOTAL_SMILIES = 0
  ELEVATOR.y = 0
  ELEVATOR.vy = 0
  W_HELD = 0
  S_HELD = 0
  ARE_YOU_SURE = false
  cam:setPosition(0, 0)
end

function drawPanel(screenWidth, screenHeight, isSelected, offset, title, stats)
  local panelX = screenWidth / 2 + offset
  local panelY = screenHeight / 2

  if isSelected then
    love.graphics.push()
    love.graphics.translate(panelX, panelY)
    love.graphics.scale(1.08 + math.sin(time * 3) / 80)
    love.graphics.translate(-panelX, -panelY)
  else
    love.graphics.setColor(0.8, 0.8, 0.8)
  end

  love.graphics.draw(UI_PANEL_IMAGE, panelX, panelY, 0, 0.75, 0.75, 300, 150)
  love.graphics.setColor(0.25, 0.25, 0.25)
  love.graphics.print(title, round(panelX - 210), round(panelY - 100), 0, 1, 1)
  for i = 1, #stats do
    love.graphics.print(stats[i], round(panelX - 210), round(panelY - 100 + 50 + 25 * (i - 1)), 0, 0.5, 0.5)
  end

  love.graphics.setColor(1, 1, 1)

  if isSelected then
    love.graphics.pop()
  end
end