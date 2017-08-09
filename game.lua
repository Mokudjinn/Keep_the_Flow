local Game = {}

Game.Map = {}
Game.Map.Grid = {
              { 1,1,1,1,1,1,11,12,13,14,1,1,1,1,1,1 },
              { 1,6,15,8,8,8,8,8,8,8,8,8,8,8,4,1 },
              { 1,10,2,2,2,2,2,2,2,2,2,2,2,2,9,1 },
              { 1,10,2,2,34,2,2,2,2,37,2,2,2,2,9,1 },
              { 1,10,2,2,2,2,35,2,2,2,2,2,2,2,9,1 },
              { 1,10,2,2,2,2,2,2,36,2,2,2,2,2,9,1 },
              { 1,10,2,2,2,2,2,2,2,2,2,2,2,2,9,1 },
              { 1,10,2,2,38,2,2,2,39,2,2,2,2,2,9,1 },
              { 1,10,2,2,2,2,2,2,2,2,2,40,2,2,9,1 },
              { 1,5,7,7,7,7,7,7,7,7,7,7,16,7,3,1 },
              { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
            }
            
Game.Map.MAP_WIDTH = 16
Game.Map.MAP_HEIGHT = 11
Game.Map.TILE_WIDTH = 64
Game.Map.TILE_HEIGHT = 64

Game.TileSheet = nil
Game.TileTextures = {}
Game.TileTypes = {}

Game.Hero = require("hero")

local sndMusicMenu
local sndMusicPlay
local sndMusicGameover
local gameState = ""

function Game.Map.isSolid(pID)
  local tileType = Game.TileTypes[pID]
  
  if tileType == "Tube Start" or
      tileType == "Tube Stop" or
      tileType == "Croix Fermee" or
      tileType == "Tube V Ferme" or
      tileType == "Tube H Ferme" or
      tileType == "Coude Droit Bas Ferme" or
      tileType == "Coude Bas Gauche Ferme" or 
      tileType == "Coude Gauche Haut Ferme" or 
      tileType == "Coude Haut Droit  Ferme" then
    return true
  end
  
  return false
end

function Game.Load()
  Game.TileSheet = love.graphics.newImage("images/tilesheetKTF.png") -- Chargement de la texture
  local nbColumns  = Game.TileSheet:getWidth() / Game.Map.TILE_WIDTH
  local nbLines = Game.TileSheet:getHeight() / Game.Map.TILE_HEIGHT

  local l,c
  local id = 1
  Game.TileTextures[0] = nil

  for l=1,nbLines do
    for c=1,nbColumns do
      --Structure de la fonction ".newQuad" : love.graphics.newQuad(x,y,width,height,sw,sh)
      Game.TileTextures[id] = love.graphics.newQuad(
        (c-1)*Game.Map.TILE_WIDTH,
        (l-1)*Game.Map.TILE_HEIGHT,
        Game.Map.TILE_WIDTH,
        Game.Map.TILE_HEIGHT,
        Game.TileSheet:getWidth(),
        Game.TileSheet:getHeight()
      )
      
      id = id + 1
    end
  end
  
  Game.TileTypes[1] = "Fond UP"
  Game.TileTypes[2] = "Fond DWN"
  Game.TileTypes[3] = "Coude Bas Droit"
  Game.TileTypes[4] = "Coude Haut Droit"
  Game.TileTypes[5] = "Coude Bas Gauche"
  Game.TileTypes[6] = "Coude Haut Gauche"
  Game.TileTypes[7] = "Tube Droit Bas"
  Game.TileTypes[8] = "Tube Droit Haut"
  Game.TileTypes[9] = "Tube Droit Droite"
  Game.TileTypes[10] = "Tube Droit Gauche"
  Game.TileTypes[11] = "Logo part 1"
  Game.TileTypes[12] = "Logo part 2"
  Game.TileTypes[13] = "Logo part 3"
  Game.TileTypes[14] = "Logo part 4"
  Game.TileTypes[15] = "Tube Start"
  Game.TileTypes[16] = "Tube Stop"
  Game.TileTypes[17] = "Tube Win"
  Game.TileTypes[18] = "Bleu"
  Game.TileTypes[19] = "Coude Droit Bas Vide"
  Game.TileTypes[20] = "Coude Bas Gauche Vide"
  Game.TileTypes[21] = "Coude Gauche Haut Vide"
  Game.TileTypes[22] = "Coude Haut Droit Vide"
  Game.TileTypes[23] = "Coude Droit Bas Plein"
  Game.TileTypes[24] = "Coude Bas Gauche Plein"
  Game.TileTypes[25] = "Coude Gauche Haut Plein"
  Game.TileTypes[26] = "Coude Haut Droit Plein"
  Game.TileTypes[27] = "Bleu"
  Game.TileTypes[28] = "Tube H Vide"
  Game.TileTypes[29] = "Tube H Plein"
  Game.TileTypes[30] = "Tube V Vide"
  Game.TileTypes[31] = "Tube V Plein"
  Game.TileTypes[32] = "Croix Vide"
  Game.TileTypes[33] = "Croix Pleine"
  Game.TileTypes[34] = "Croix Fermee" --obstacle
  Game.TileTypes[35] = "Tube V Ferme" --obstacle
  Game.TileTypes[36] = "Tube H Ferme" --obstacle
  Game.TileTypes[37] = "Coude Droit Bas Ferme" --obstacle
  Game.TileTypes[38] = "Coude Bas Gauche Ferme" --obstacle
  Game.TileTypes[39] = "Coude Gauche Haut Ferme" --obstacle
  Game.TileTypes[40] = "Coude Haut Droit  Ferme" --obstacle
end

function Game.Draw()
  
  for l=1, Game.Map.MAP_HEIGHT do
    for c=1, Game.Map.MAP_WIDTH do
      local id = Game.Map.Grid[l][c]
      local texQuad = Game.TileTextures[id] -- On recup l'ID du newQuad
      if texQuad  ~= nil then
        love.graphics.draw(Game.TileSheet, texQuad, (c-1)*Game.Map.TILE_WIDTH, (l-1)*Game.Map.TILE_HEIGHT)
      end
    end 
  end
  
  Game.Hero.Draw(Game.Map)
  ------------------------------------------------------ Affichage de l'ID en debug par detection de coords.
  local x = love.mouse.getX() -- recup pos. souris 
  local y = love.mouse.getY()
  local col = math.floor(x / Game.Map.TILE_WIDTH) + 1 -- Ajout de 1 pour decaller le resultat
  local lig = math.floor(y / Game.Map.TILE_HEIGHT) + 1
  ------------------------------------------------------ Evite le crash due au depassement
  if col>0 and col<=Game.Map.MAP_WIDTH and lig>0 and lig<=Game.Map.MAP_HEIGHT then
    local id = Game.Map.Grid[lig][col]
    love.graphics.print("Type de tile: "..tostring(Game.TileTypes[id],1,750).." ("..tostring(id)..")",1,750)
  else
    love.graphics.print("Hors du tableau",1,750)
  end
end

function Game.Update(dt)
  Game.Hero.Update(Game.Map, dt)
end

return Game
