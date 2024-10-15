function love.load()
  target = {}
  target.x = 200
  target.y = 200
  target.radius = 50

  sprites = {}
  sprites.background = love.graphics.newImage("sprites/background.png")
  sprites.target = love.graphics.newImage("sprites/target.png")
  sprites.crosshair = love.graphics.newImage("sprites/crosshair.png")

  score = 0
  timer = 0
  gameState = "menu"
  love.mouse.setVisible(false)
end

function love.update(deltaTime)
  if timer >= deltaTime then
    timer = timer - deltaTime
  else
    timer = 0
    gameState = "menu"
  end
end

function love.draw()
  love.graphics.draw(sprites.background)
  love.graphics.setNewFont(40)
  love.graphics.print("Score: " .. score, 5, 5)

  if gameState == "menu" and score == 0 then
    love.graphics.printf("Click anywhere to start the game!", 0, 100, love.graphics.getWidth(), "center")
  elseif gameState == "menu" and score > 0 then
    love.graphics.printf("Click to play again!", 0, 100, love.graphics.getWidth(), "center")
  end

  if gameState == "game" then
    love.graphics.printf("Time: " .. math.ceil(timer), -5, 5, love.graphics.getWidth(), "right")
    love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
  end

  love.graphics.draw(sprites.crosshair, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button)
  if (button == 1 or button == 2) and gameState == "game" then
    local mouseToTarget = distanceBetween(x, y, target.x, target.y)
    if mouseToTarget < target.radius then
      if button == 1 then
        score = score + 1
      elseif button == 2 then
        score = score + 2
        timer = timer - 1
      end
      target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
      target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
    elseif mouseToTarget > target.radius and score > 0 and button == 1 then
      score = score - 1
    elseif mouseToTarget > target.radius and score > 0 and button == 2 then
      if score == 1 then
        score = score - 1
        timer = timer - 1
      else
        score = score - 2
        timer = timer - 1
      end
    end
  elseif button == 1 and gameState == "menu" then
    gameState = "game"
    timer = 10
    score = 0
  end
end

-- Distance between the mouse and the center of the circle
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
