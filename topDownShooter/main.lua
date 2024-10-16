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
end

function love.draw()
  love.graphics.draw(sprites.background)

  love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)
end

-- This function returns the angle in radians between two points
function playerMouseAngle()
  return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end
