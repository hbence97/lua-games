function love.load()
  -- Creating a randomseed for every new game
  math.randomseed(os.time())

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

  score = 0
  lastScore = 0
  highScore = 0

  -- 0: game over / in menu, 1: in game
  gameState = 0
  spawnTime = 2
  timerToSpawn = spawnTime
end

function love.update(deltaTime)
  if gameState == 1 then
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
  end

  for index, zombie in ipairs(zombies) do
    zombie.x = zombie.x + ( math.cos(zombiePlayerAngle(zombie)) * zombie.speed * deltaTime )
    zombie.y = zombie.y + ( math.sin(zombiePlayerAngle(zombie)) * zombie.speed * deltaTime )

    -- Game over
    if distanceBetween(zombie.x, zombie.y, player.x, player.y) < 35 then
      for i, z in ipairs(zombies) do
        zombies[i] = nil
        gameState = 0
        lastScore = score
        spawnTime = 2
        if highScore < score then
          highScore = score
        end
      end
    end
  end

  for index, bullet in ipairs(bullets) do
    bullet.x = bullet.x + ( math.cos(bullet.direction) * bullet.speed * deltaTime )
    bullet.y = bullet.y + ( math.sin(bullet.direction) * bullet.speed * deltaTime )
  end

  -- Remove bullet from table when it's out of bonds
  for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    if bullet.x < 0 or bullet.y < 0 or bullet.x > love.graphics.getWidth() or bullet.y > love.graphics.getHeight() then
      table.remove(bullets, i)
    end
  end

  -- Hit detection for zombies and bullets
  for i, zombie in ipairs(zombies) do
    for j, bullet in ipairs(bullets) do
      if distanceBetween(zombie.x, zombie.y, bullet.x, bullet.y) < 20 then
        zombie.dead = true
        bullet.dead = true
        score = score + 10
      end
    end
  end

  -- Remove dead zombies and bullets
  for i = #zombies, 1, -1 do
    local zombie = zombies[i]
    if zombie.dead then
      table.remove(zombies, i)
    end
  end

  for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    if bullet.dead then
      table.remove(bullets, i)
    end
  end

  -- Zombie spawn time maxed out at 0.4 seconds
  if gameState == 1 then
    timerToSpawn = timerToSpawn - deltaTime
    if timerToSpawn <= 0 then
      spawnZombie()
      spawnTime = spawnTime * 0.95
      timerToSpawn = spawnTime
      if (timerToSpawn < 0.41) then
        timerToSpawn = 0.4
      end
    end
  end
end

function love.draw()
  love.graphics.draw(sprites.background)
  love.graphics.setNewFont(40)

  if gameState == 0 then
    love.graphics.printf("Press enter to start the game!", 0, 100, love.graphics.getWidth(), "center")
    if highScore > 0 then
      love.graphics.print("High score : " .. highScore, 5, 5)
      love.graphics.print("Last score : " .. lastScore, 5, 50)
    end
  end

  if gameState == 1 then
    if highScore == 0 then
      love.graphics.print("Score: " .. score, 5, 5)
    elseif highScore > 0 then
      love.graphics.print("High score : " .. highScore, 5, 5)
      love.graphics.print("Score: " .. score, 5, 50)
    end
  end

  love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)

  for i, zombie in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, zombie.x, zombie.y, zombiePlayerAngle(zombie), nil, nil, sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2)
  end

  for i, bullet in ipairs(bullets) do
    love.graphics.draw(sprites.bullet, bullet.x, bullet.y, playerMouseAngle(), 0.5, 0.5, sprites.bullet:getWidth() / 2, sprites.bullet:getHeight() / 2)
  end
end

function love.keypressed(key)
  if key == "return" and gameState == 0 then
    gameState = 1
    score = 0
  end

  if key == "space" then
    spawnZombie()
  end
end

function love.mousepressed(x, y, button)
  if gameState == 1 and button == 1 then
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
  local spawnPoint = math.random(1, 4) -- 1 left, 2 right, 3 top, 4 bottom

  zombie.x = 0
  zombie.y = 0
  zombie.speed = 120
  zombie.dead = false

  if spawnPoint == 1 then
    zombie.x = -30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif spawnPoint == 2 then
    zombie.x = love.graphics.getWidth() + 30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif spawnPoint == 3 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = -30
  elseif spawnPoint == 4 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight() + 30
  end

  table.insert(zombies, zombie)
end

function spawnBullets()
  local bullet = {}

  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 500
  bullet.direction = playerMouseAngle()
  bullet.dead = false

  table.insert(bullets, bullet)
end
