-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local mode = "MENU"

local background = nil
local submarine = {}
    submarine.img = nil
    submarine.x = 0
    submarine.y = 0
    submarine.ox = 0
    submarine.oy = 0
    submarine.speed = 60

function love.load()
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()
  background = love.graphics.newImage("assets/images/fond.jpg")
  submarine.img = love.graphics.newImage("assets/images/sous-marin-heros.png")
  submarine.x = largeur_ecran/2
  submarine.y = hauteur_ecran/2
  submarine.ox = submarine.img:getWidth()/2
  submarine.oy = submarine.img:getHeight()/2
end

function love.update(dt)
    if mode == "MENU" then 
        updateMenu(dt)
    elseif mode == "GAMEPLAY" then 
        updateGameplay(dt)
    elseif mode == "GAMEOVER" then 
        updateGameover(dt)
    end
end

function love.draw()
    if mode == "MENU" then 
        drawMenu()
    elseif mode == "GAMEPLAY" then 
        drawGameplay()
    elseif mode == "GAMEPLAY" then 
        drawGameover()
    end
end

-- =============================================================================
-- MENU
-- =============================================================================
function updateMenu(dt)
    
end
function drawMenu()
    love.graphics.print("MENU - PRESS SPACE TO PLAY", 1, 1)
end

-- =============================================================================
-- GAMEPLAY
-- =============================================================================
function updateGameplay(dt)
    if love.keyboard.isDown("up") and submarine.y >= hauteur_ecran/2 then
        submarine.y = submarine.y - (submarine.speed*dt)
    end
    if love.keyboard.isDown("left") and submarine.x >= 0+submarine.ox then
        submarine.x = submarine.x - (submarine.speed*dt)
    end
    if love.keyboard.isDown("right") and submarine.x <= largeur_ecran-submarine.ox then
        submarine.x = submarine.x + (submarine.speed*dt)
    end
    if love.keyboard.isDown("down") and submarine.y <= hauteur_ecran-submarine.oy then
        submarine.y = submarine.y + (submarine.speed*dt)
    end
end
function drawGameplay()
    love.graphics.print("drawGameplay")
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(submarine.img, submarine.x, submarine.y, 0, 1, 1, submarine.ox, submarine.oy)
end

-- =============================================================================
-- GAMEOVER
-- =============================================================================
function updateGameover(dt)
    
end

function drawGameover()
    love.graphics.print("drawGameover")
end


function love.keypressed(key)
    if key == "return" then 
        mode = "GAMEPLAY"
    end
    if key == "escape" then 
        mode = love.event.quit()
    end
  print(key)
end