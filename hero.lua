local hero = {}

hero.images = {}
hero.images[1] = love.graphics.newImage("images/player_1.png")
hero.images[2] = love.graphics.newImage("images/player_2.png")
hero.images[3] = love.graphics.newImage("images/player_3.png")
hero.images[4] = love.graphics.newImage("images/player_4.png")
hero.imgCurrent = 1
hero.line = 3
hero.column = 3
hero.keyPressed = false

function hero.Update(pMap, dt)

  if love.keyboard.isDown("up", "right", "down", "left", "space") then
    
    if hero.keyPressed == false then
      local old_column = hero.column
      local old_line = hero.line
      
      if love.keyboard.isDown("space") then
        hero.imgCurrent = hero.imgCurrent + 1
        if hero.imgCurrent > #hero.images then
          hero.imgCurrent = 1
        end
      end
      
      if love.keyboard.isDown("up") and hero.line > 3 then
        hero.line = hero.line - 1
      end

      if love.keyboard.isDown("right") and hero.column < 14 then
        hero.column = hero.column + 1
      end

      if love.keyboard.isDown("down") and hero.line < 9 then 
        hero.line = hero.line + 1
      end

      if love.keyboard.isDown("left") and hero.column > 3 then
        hero.column = hero.column - 1
      end
      
      local id = pMap.Grid[hero.line][hero.column]
      if pMap.isSolid(id) then 
        print("collision avec un bloc solide")
        hero.column = old_column
        hero.line = old_line
      end
      
      hero.keyPressed = true
      
    end
  else
      hero.keyPressed = false
  end
end

  function hero.Draw(pMap)
    local x = (hero.column - 1) * pMap.TILE_WIDTH
    local y = (hero.line - 1) * pMap.TILE_HEIGHT
    love.graphics.draw(hero.images[hero.imgCurrent],x ,y ,0 ,1 , 1)
  end
  
return hero
