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
local lst_missile = {}
local img_missile = nil
local speed_missile = 0
local lst_plane = {}
local img_plane = nil
local speed_plane = nil

local lst_explosion = {}
local img_explosion = nil

function InitJeu()
    submarine.x = largeur_ecran/2
    submarine.y = hauteur_ecran/2
    submarine.ox = submarine.img:getWidth()/2
    submarine.oy = submarine.img:getHeight()/2
    speed_missile = 200
    speed_plane = 200
    lst_missile = {}
    lst_plane = {}
    lst_explosion = {}
    CreerRaid()
end

function love.load()
    largeur_ecran = love.graphics.getWidth()
    hauteur_ecran = love.graphics.getHeight()
    background = love.graphics.newImage("assets/images/fond.jpg")
    submarine.img = love.graphics.newImage("assets/images/sous-marin-heros.png")
    img_missile = love.graphics.newImage("assets/images/missile.png")
    img_plane = love.graphics.newImage("assets/images/avion.png")
    img_explosion = love.graphics.newImage("assets/images/explosion_avion.png")

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
function CreerMissile()
    local missile = {}
            missile.x = submarine.x - (submarine.ox/2)
            missile.y = submarine.y - (submarine.oy*2)
    table.insert(lst_missile, missile)
end

function CreerPlane(pX, pY, pSens)
    local plane = {}
        plane.x = pX
        plane.y = pY
        plane.sx = pSens
        plane.sy = 1
        plane.sens = pSens
    table.insert(lst_plane, plane)
end

function CreerRaid()
    local sens = 1
    for n=1, 6 do
        if sens == 1 then 
            CreerPlane(0- (n* img_plane:getWidth()/2), n*img_plane:getHeight(), sens)
        else
            CreerPlane(largeur_ecran + (n* img_plane:getWidth()/2), n*img_plane:getHeight(), sens)
        end
        if sens == 1 then 
            sens = -1
        else
            sens = 1
        end
    end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

function Explosion(pX, pY)
    local explosion = {}
        explosion.x = pX
        explosion.y = pY
        explosion.vie = 0.5
    table.insert(lst_explosion, explosion)
end

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

    for i = #lst_missile, 1, -1 do 
        local m = lst_missile[i]
        m.y = m.y - (speed_missile*dt)
        if (m.y+img_missile:getHeight()) <= 0 then 
            table.remove(lst_missile, i)
        end
    end

    for i = #lst_plane, 1, -1 do
        local p = lst_plane[i]
        local bSupprime = false

        for n = #lst_missile, 1, -1 do 
            local m = lst_missile[n]
            if CheckCollision(p.x, p.y, img_plane:getWidth(), img_plane:getHeight(),
                            m.x, m.y, img_missile:getWidth(), img_missile:getHeight()) then 
                table.remove(lst_plane, i) 
                table.remove(lst_missile, n) 
                bSupprime = true
            end
        end
        if bSupprime == false then 
            p.x = p.x + ((speed_plane*dt)*p.sens)
             
            if p.sens == 1 then 
                if p.x > largeur_ecran then 
                    p.x = 0 - img_plane:getWidth()
                    p.sx = 1
                end
            else
                if p.x < 0-img_plane:getWidth() then 
                    p.x = largeur_ecran
                    p.sx = -1
                end
            end
        end
    end
end

function drawGameplay()
    love.graphics.print("drawGameplay")
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(submarine.img, submarine.x, submarine.y, 0, 1, 1, submarine.ox, submarine.oy)

    for k,m in ipairs(lst_missile) do
        love.graphics.draw(img_missile, m.x, m.y)
    end

    for k,m in ipairs(lst_plane) do
        love.graphics.draw(img_plane, m.x, m.y, 0, m.sx, m.sy)
    end

    for k,m in ipairs(lst_explosion) do
        love.graphics.draw(img_explosion, m.x, m.y)
    end
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
    if key == "return" and mode == "MENU" then 
        mode = "GAMEPLAY"
        InitJeu()
    elseif key == "a" and mode == "GAMEPLAY" then 
        CreerMissile()
    end

    if key == "escape" then 
        mode = love.event.quit()
    end
  print(key)
end