-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function sign(n)
  return n > 0 and 1 or n < 0 and -1 or 0
end

-- Returns the distance between two points.
function dist(x1, y1, x2, y2)
  return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

-- Returns the angle between two vectors assuming the same origin.
function angle(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end

function lengthDirX(dist, dir)
  return dist * math.cos(dir)
end
function lengthDirY(dist, dir)
  return dist * math.sin(dir)
end

-- Linear interpolation between two numbers.
function lerp(a, b, t)
  return (1 - t) * a + t * b
end

-- Clamps a number to within a certain range.
function clamp(low, n, high)
  return math.min(math.max(low, n), high)
end

function toRad(ang)
  return ang * math.pi / 180
end
function toDeg(ang)
  return 180 * ang / math.pi
end

function round(num)
  return math.floor(num + 0.5)
end

function roundWithStep(number, increment, offset)
  return round((number - offset) / increment) * increment + offset;
end

function roundDecimal(v, p)
  -- figure out scaling factor for number of decimal points, or 0 if 'p' not supplied
  local scale = math.pow(10, p or 0);
  -- calculate result ignoring sign
  local res = math.floor(math.abs(v) * scale + 0.5) / scale;
  -- if 'v' was negative return value should be too
  if v < 0 then
    res = -res;
  end ;
  -- return rounded value
  return res;
end;

function angleDiff(a1, a2)
  local result = a1 - a2
  return (result + 180) % 360 - 180
end

function weightSort(object1, object2)
  return object1.weight < object2.weight
end


local random = math.random
function uuid()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end)
end

function perlin(x, y, z, scale, octaves)
  local noise = 1

  for i = 1, octaves do
    noise = noise * love.math.noise(i * x / scale, i * y / scale, z)
  end

  return math.pow(noise, 1 / octaves)
end

function perlin2(x, y, z, scale, octaves)
  local noise = 0

  for i = 1, octaves do
    noise = noise + love.math.noise(x / (scale * i), y / (scale * i), z)
  end

  return noise / octaves
end

function perlin3(x, y, z, scale)
  local a = math.max(
      love.math.noise(x / (scale), y / (scale), z),
      love.math.noise(x / (scale) + 10000, y / (scale) + 10000, z)
  )

  return a
end

function perlin4(x, y, scale)
  local a = love.math.noise(x / (scale), y / (scale)) * (1 + math.sin(math.abs(x + y))) / 2

  return a
end

function perlin5(x, y, seed, scale, octaves)
  local noise = 1

  for i = 1, octaves do
    noise = noise * love.math.noise(x / (scale * i) + seed, y / (scale * i) + seed)
  end

  return noise
end

function perlin6(x, y, seed, scale, octaves)
  local lacunarity = 2
  local amp = 1 / 1.75
  local gain = 0.5
  local noise = 0

  for i = 1, octaves do
    noise = noise + love.math.noise(x / scale + seed * i, y / scale + seed * i) * amp
    x = x * lacunarity
    y = y * lacunarity
    amp = amp * gain
  end

  return noise
end

function perlin7(x, y, z, scale, octaves)
  local lacunarity = 2
  local amp = 1 / 1.75
  local gain = 0.5
  local noise = 0

  for i = 1, octaves do
    noise = noise + love.math.noise(x / scale, y / scale, z) * amp
    x = x * lacunarity
    y = y * lacunarity
    amp = amp * gain
  end

  return noise
end

--- Shuffles the values in a table.
function shuffle(tab)
  local len = #tab
  local r, tmp
  for i = 1, len do
    r = math.random(i, len)
    tmp = tab[i]
    tab[i] = tab[r]
    tab[r] = tmp
  end
end

--- Swaps the positions of two values in a table.
function swap(tab, i, j)
  local tmp = tab[i]
  tab[i] = tab[j]
  tab[j] = tmp
end

function round2Decimal(v, p)
  local mult = math.pow(10, p or 0)
  return math.floor(v * mult + 0.5) / mult
end

smoothStep = function(x, steps, flatness)
  local w = 1 / steps
  return w * ((0.5 / math.tanh(flatness / 2)) * math.tanh(flatness * ((x / w - math.floor(x / w)) - 0.5)) + 0.5 + math.floor(x / w))
end

--- Safely gets a value from a table
safeGet = function(hashmap, i, j)
  if hashmap[i] then
    return hashmap[i][j]
  end
end

--- Safely sets a value in a table
safeSet = function(hashmap, i, j, v)
  hashmap[i] = hashmap[i] or {}
  hashmap[i][j] = v
end

--- Upside down sigmoid function
flippedSigmoid = function(x)
  return 1 / (1 + math.exp(10 * (x - 0.5)))
end

function contains(table, value)
  for i = 1, #table do
    if table[i] == value then
      return true
    end
  end

  return false
end

function merge(table1, table2)
  local merged = {}
  for i = 1, #table1 do
    table.insert(merged, table1[i])
  end
  for i = 1, #table2 do
    table.insert(merged, table2[i])
  end

  return merged
end