function love.load()
  sprites = {}
  sprites.player = love.graphics.newImage("sprites/player.png")
  sprites.zombie = love.graphics.newImage("sprites/zombie.png")
  sprites.bullet = love.graphics.newImage("sprites/bullet.png")
  sprites.background = love.graphics.newImage("sprites/background.png")

  player = {}
  player.x = love.graphics.getWidth() / 2
  player.y = love.graphics.getHeight() / 2
  player.speed = 140

  zombies = {}
end

function love.update(deltaTime)
  if love.keyboard.isDown("w") then
    player.y = player.y - player.speed * deltaTime
  end
  if love.keyboard.isDown("a") then
    player.x = player.x - player.speed * deltaTime
  end
  if love.keyboard.isDown("s") then
    player.y = player.y + player.speed * deltaTime
  end
  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * deltaTime
  end

  for index, zombie in ipairs(zombies) do
    zombie.x = zombie.x + ( math.cos(zombiePlayerAngle(zombie)) * zombie.speed * deltaTime )
    zombie.y = zombie.y + ( math.sin(zombiePlayerAngle(zombie)) * zombie.speed * deltaTime )
  end
end

function love.draw()
  love.graphics.draw(sprites.background)

  love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)

  for i, zombie in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, zombie.x, zombie.y, zombiePlayerAngle(zombie), nil, nil, sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2)
  end
end

function love.keypressed(key)
  if key == "space" then
    spawnZombie()
  end
end

-- These 2 functions return the angle in radians between two points
function playerMouseAngle()
  return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function zombiePlayerAngle(zombie)
  return math.atan2(player.y - zombie.y, player.x - zombie.x)
end

function spawnZombie()
  local zombie = {}
  zombie.x = math.random(0, love.graphics.getWidth())
  zombie.y = math.random(0, love.graphics.getWidth())
  zombie.speed = 120

  table.insert(zombies, zombie)
end
