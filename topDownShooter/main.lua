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

  bullets = {}

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

    if distanceBetween(zombie.x, zombie.y, player.x, player.y) < 35 then
      for i, z in ipairs(zombies) do
        zombies[i] = nil
      end
    end
  end

  for index, bullet in ipairs(bullets) do
    bullet.x = bullet.x + ( math.cos(bullet.direction) * bullet.speed * deltaTime )
    bullet.y = bullet.y + ( math.sin(bullet.direction) * bullet.speed * deltaTime )
  end

-- Remove bullet from table when it's out of bonds
  for i=#bullets, 1, -1 do
    local bullet = bullets[i]
    if bullet.x < 0 or bullet.y < 0 or bullet.x > love.graphics.getWidth() or bullet.x > love.graphics.getHeight() then
      table.remove(bullets, i)
    end
  end
end

function love.draw()
  love.graphics.draw(sprites.background)

  love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)

  for i, zombie in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, zombie.x, zombie.y, zombiePlayerAngle(zombie), nil, nil, sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2)
  end

  for i, bullet in ipairs(bullets) do
    love.graphics.draw(sprites.bullet, bullet.x, bullet.y, playerMouseAngle(), 0.5, 0.5, sprites.bullet:getWidth() / 2, sprites.bullet:getHeight() / 2)
  end
end

function love.keypressed(key)
  if key == "space" then
    spawnZombie()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    spawnBullets()
  end
end

-- These 2 functions return the angle in radians between two points
function playerMouseAngle()
  return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function zombiePlayerAngle(zombie)
  return math.atan2(player.y - zombie.y, player.x - zombie.x)
end

-- Distance between two points
function distanceBetween(x1, y1, x2, y2)
	return math.sqrt( (x2 - x1) ^ 2 + (y2 - y1) ^ 2 )
end

function spawnZombie()
  local zombie = {}
  zombie.x = math.random(0, love.graphics.getWidth())
  zombie.y = math.random(0, love.graphics.getWidth())
  zombie.speed = 120

  table.insert(zombies, zombie)
end

function spawnBullets()
  local bullet = {}

  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 500
  bullet.direction = playerMouseAngle()

  table.insert(bullets, bullet)
end
