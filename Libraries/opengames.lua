function draw()
  win:removeChildren()
  gamee = game.screen
  win:addChild(GUI.panel(1,1,game.window.width,game.window.heigth,game.window.color))
  if game.window.abn == true then
    local tmp = win:addChild(GUI.actionButtons(2,2,false))
    tmp.close.onTouch = function() win:remove() end
    tmp.maximize.onTouch = function() win.maximize() end
    tmp.minimize.onTouch = function() win.minimize() end
  end
  for i = 1,#gamee do
    if gamee[i].visible == true then
      if gamee[i].type == 'text' then
        if gamee[i].text == '{loc}' or gamee[i].text == '{localization}' then text = game.localization[gamee[i].name] else text = gamee[i].text end
        win:addChild(GUI.text(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].color),text))
      end
      if gamee[i].type == 'panel' then
        win:addChild(GUI.panel(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[1].heigth),tonumber(gamee[i].color)))
      end
      if gamee[i].type == 'button' then
      if gamee[i].text == '{loc}' or gamee[i].text == '{localization}' then text = game.localization[gamee[i].name] else text = gamee[i].text end
        win:addChild(GUI.button(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].height),tonumber(gamee[i].colorbg),tonumber(gamee[i].colorfg),tonumber(gamee[i].colorbgp),tonumber(gamee[i].colorfgp),text)).onTouch = function() system.execute(scriptpath..'/Scripts/'..game.screen[i].onTouch) end
      end
      if gamee[i].type == 'input' then
      if gamee[i].text == '{loc}' or gamee[i].text == '{localization}' then text = game.localization[gamee[i].name] else text = gamee[i].text end
      if gamee[i].text == '{loc}' or gamee[i].text == '{localization}' then text = game.localization[gamee[i].name..'ph'] else text = gamee[i].text end
        local tmp = win:addChild(GUI.input(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].height),tonumber(gamee[i].colorbg),tonumber(gamee[i].colorfg),tonumber(gamee[i].colorph),tonumber(gamee[i].colorfg),tonumber(gamee[i].colorfgp),text,textph))
        tmp.onInputFinished = function() 
          game.screen[i].text = tmp.text
          system.execute(scriptpath..'/Scripts/'..game.screen[i].onInputEnded) 
        end
      end
      if gamee[i].type == 'slider' then
        win:addChild(GUI.slider(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].colorp),tonumber(gamee[i].colors),tonumber(gamee[i].colorpp),tonumber(gamee[i].colorv),tonumber(gamee[i].minv),tonumber(gamee[i].maxv),tonumber(gamee[i].value)))
      end
      if gamee[i].type == 'progressIndicator' then
        local tmp = win:addChild(GUI.progressIndicator(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].colorpa),tonumber(gamee[i].colorp),tonumber(gamee[i].colors)))
        tmp.active = gamee[i].active
        for i = 1, #gamee[i].rollStage do
          tmp:roll()
        end
      end
      if gamee[i].type == 'progressBar' then
        win:addChild(GUI.progressBar(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].colorp),tonumber(gamee[i].colors),tonumber(gamee[i].colorv),tonumber(gamee[i].value)))
      end
      if gamee[i].type == 'comboBox' then
        local tmp = win:addChild(GUI.comboBox(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].elh),tonumber(gamee[i].colorbg),tonumber(gamee[i].colort),tonumber(gamee[i].colorabg),tonumber(gamee[i].colorat)))
        for e = 1,#gamee[i].items do
          tmp:addItem(gamee[i].items[e].name,gamee[i].items[e].active)
        end
      end
      if gamee[i].type == 'colorSelector' then
        if gamee[i].text == '{loc}' or gamee[i].text == '{localization}' then text = game.localization[gamee[i].name] else text = gamee[i].text end
        win:addChild(GUI.colorSelector(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].height),tonumber(gamee[i].color),text)).onColorSelected = function() system.execute(scriptpath..'/Scripts/'..game.screen[i].onTouch) end
      end
      if gamee[i].type == 'switch' then
        win:addChild(GUI.switch(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].colorp),tonumber(gamee[i].colors),tonumber(gamee[i].colorpp),tonumber(gamee[i].state))).onStateChanged = function() system.execute(scriptpath..'/Scripts/'..game.screen[i].onStateChanged) end
      end
      if gamee[i].type == 'image' then
        idk = nil
        for e = 1,#game.storage do
          if game.storage[e].name == gamee[i].image then
            idk = game.storage[e].path
          end
        end
        if idk == nil then idk = '/MineOS/Icons/Script.pic' end
        win:addChild(GUI.image(tonumber(gamee[i].x),tonumber(gamee[i].y),image.load(idk)))
      end
    end
  end
end
function move(what,x,y,speed,smooth)
  if speed then
    if smooth then
      xx = what.x - x
      yy = what.y - y
      xx = xx / 2
      yy = yy / 2
      tmpx = what.x
      tmpy = what.y
      xx,yy = math.ceil(xx/speed),math.ceil(yy/speed)
      speedq = 0
      while what.x > x or what.x < x or what.y > y or what.y < y do
        if speedq < speed and what.x - x*-1 > xx and what.y -y *-1 > yy then
          speedq = speedq + 1
        end
        if speedq > speed and what.x - x*-1 < xx and what.y -y *-1 < yy then
          seedq = speedq - 1
        end
        prev2x = prev1x
        prev1x = what.x
        prev2y = prev1y
        prev1y = what.y
        if what.x > x then
          what.x = what.x - speedq
        elseif what.x < x then
          what.x = what.x + speedq
        end
        if what.y > y then
          what.y = what.y - speedq
        elseif what.y < y then
          what.y = what.y + speedq
        end
        if prev2y ~= prev1y and prev1y ~= what.y and prev2y == what.y then
          if what.y > y or what.y < y then what.y = y end
        end
        if prev2x ~= prev1x and prev1x ~= what.x and prev2x == what.x then
          if what.x > x or what.x < x then what.x = x end
        end
        draw()
      end
    else
      tmpx = what.x-x
      tmpy = what.y -y
     while what.x > tmpx or what.y > tmpy or what.x > tmpx or what.y > tmpy do
      if what.x > tmpx then
       what.x = what.x - speed
      end
      if what.y > tmpy then
        what.y = what.y - speed
      end
      if what.y < tmpy then
        what.y = what.y - seed
      end
      if what.x < tmpx then
        what.x = what.x - speed
      end
      draw()
     end
    end
  else
    what.x = x
    what.y = y
    draw()
  end
end
function resize(what,w,h,speed,smooth)
  if speed then
    if smooth then
      ww = what.width - w
      hh = what.heigth - h
      ww = ww / 2
      hh = hh / 2
      tmpw = what.width
      tmph = what.heigth
      ww,hh = math.ceil(ww/speed),math.ceil(hh/speed)
      speedq = 0
      while what.width > w or what.width < w or what.heigth > h or what.heigth < h do
        if speedq < speed and what.width - w*-1 > ww and what.heigth -h*-1 > hh then
          speedq = speedq + 1
        end
        if speedq > speed and what.width - w*-1 < ww and what.heigth -h*-1 < hh then
          seedq = speedq - 1
        end
        prev2w = prev1w
        prev1w = what.width
        prev2h = prev1h
        prev1h = what.heigth
        if what.width > w then
          what.width = what.width - speedq
        elseif what.width < w then
          what.width = what.width + speedq
        end
        if what.heigth > h then
          what.heigth = what.heigth - speedq
        elseif what.heigth < h then
          what.heigth = what.heigth + speedq
        end
        if prev2h ~= prev1h and prev1h ~= what.heigth and prev2h == what.heigth then
          if what.heigth > h or what.heigth < h then what.heigth = h end
        end
        if prev2w ~= prev1w and prev1w ~= what.width and prev2w == what.width then
          if what.width > w or what.width < w then what.width = w end
        end
        draw()
      end
    else
      tmpw = what.width-w
      tmph = what.heigth -h
     while what.width > tmpw or what.heigth > tmph or what.width > tmpw or what.heigth > tmph do
      if what.width > tmpw then
       what.width = what.width - speed
      end
      if what.heigth > tmph then
        what.heigth = what.heigth - speed
      end
      if what.heigth < tmph then
        what.heigth = what.heigth - seed
      end
      if what.width < tmpw then
        what.width = what.width - speed
      end
      draw()
     end
    end
  else
    what.width = w
    what.heigth = h
    draw()
  end
end
