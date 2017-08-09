io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end
math.randomseed(os.time())
-------------------------------
local myGame = require("game")

local imgMenu

function StartMenu()
  gameState = "menu"
  --sndMusicPlay:stop()
  sndMusicMenu:play()
  
  myGame.Load()
end

function StartGame()
  gameState = "play"
  sndMusicMenu:stop()
end

function love.load() -------------------------------------------------------------------- LOAD
  
  love.window.setMode(1024, 768)
  
  largeurEcran = love.graphics.getWidth()
  hauteurEcran = love.graphics.getHeight()
  
  sndMusicMenu = love.audio.newSource("sound/menu.mp3")
  love.audio.setVolume(0.2)
  sndMusicMenu:setLooping(true)
  
  imgMenu = love.graphics.newImage("images/menu.png")
  StartMenu()
end

function UpdatePlay(dt)
    myGame.Update(dt)
end

function UpdateMenu()
end

function UpdateGameover()
end

function InputMenu(key)
  if key == "return" then
    StartGame()
  end
end

function love.update(dt)  -------------------------------------------------------------- UPDATE
  if gameState == "menu" then
    UpdateMenu(dt)
  elseif gameState == "play" then
    UpdatePlay(dt)
  elseif gameState == "gameover" then
    UpdateGameover(dt)
  end
end

function DrawMenu()
    love.graphics.draw(imgMenu, 0, 0)
end

function DrawPlay()
  myGame.Draw()
end

function DrawGameover()
end

function love.draw()  --------------------------------------------------------------------- DRAW
  if gameState == "menu" then
    DrawMenu()
  elseif gameState == "play" then
    DrawPlay()
  elseif gameState == "gameover" then
    DrawGameover()
  end
end

function love.keypressed(key)
  if gameState == "menu" then
    InputMenu(key)
  end
end
