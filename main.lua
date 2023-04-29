Gamera = require("gamera")
Player = require("unit/player")

time = 0

hud = {}
TABS = {}
DEBUG = {}


function love.wheelmoved(x, y)
end

function love.textinput(t)
  --if TEXT_INPUT_TARGET then
  --  TEXT_INPUT_TARGET.t = TEXT_INPUT_TARGET.t .. t
  --  TEXT_INPUT_TARGET.onType(TEXT_INPUT_TARGET.t)
  --end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end

  if key == "space" then
  end
end

function love.keyreleased(key, scancode, isrepeat)
  if key == "lshift" then
    SHIFT_IS_DOWN = false
  end
end

function love.mousereleased(x, y, button, istouch)
end

BALLS = {}
for i = 1, 100 do
  BALLS[i] = Player.create(math.random(0, 300), math.random(0, 100))
end

function love.load()
  --math.randomseed(os.time())
  love.graphics.setDefaultFilter("linear", "linear", 4)
  --love.graphics.setDefaultFilter("nearest", "nearest", 1)
  love.graphics.setBackgroundColor(46 / 255, 50 / 255, 35 / 255)
  love.keyboard.setKeyRepeat(true)

  --POINTER_CURSOR = love.mouse.getSystemCursor("hand")

  --DEFAULT_FONT = love.graphics.newFont("resources/fonts/3.ttf", 15)
  --LOG_FONT = love.graphics.newFont("resources/fonts/4.ttf", 20)
  --LOG_FONT:setLineHeight(1.2)

  --love.graphics.setFont(DEFAULT_FONT)

  ---- Units
  --PLAYER_IMAGE = love.graphics.newImage("images/hero.png")

  PLAYER = Player.create(0, 0)
end

HEIGHT = 0

-- UPDATE ######################################################################
function love.update(dt)
  time = time + dt

  PLAYER:update()

  for i = 1, 100 do
    BALLS[i]:update()
  end

  HEIGHT = HEIGHT + 0.3

  DEBUG[1] = "Current FPS: " .. tostring(love.timer.getFPS())
end

local function drawCameraStuff(l, t, w, h)

end

function love.draw()
  --cam:draw(drawCameraStuff)

  for i = 1, 100 do
    BALLS[i]:draw()
  end

  -- Draw a square
  love.graphics.setColor(1, 1, 1)
  --love.graphics.rectangle("fill", 30, HEIGHT, 4, 4)

  love.graphics.setColor(1, 1, 1)
  for i = 1, #DEBUG, 1 do
    love.graphics.print(DEBUG[i], love.graphics.getWidth() - 160, 10 + (i - 1) * 20)
  end
end