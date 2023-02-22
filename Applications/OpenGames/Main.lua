local GUI = require('gui')
local paths = require('paths')
local system = require('system')
local event = require('event')
local image = require('image')
local fs = require('filesystem')
local lc = system.getCurrentScriptLocalization()
local cr1, cr2,cr3 = 0x989898, 0x505050,0x000000
treemode = 'screen'
game = {scripts = {},window = {abn = true,type = 'window',width=80,heigth=40,title = 'test',color = cr2,titleColor = cr2},screen = {},storage={}}

wk,win,menu = system.addWindow(GUI.filledWindow(0,0,160,50,0x989898))

local exit = win:addChild(GUI.button(160,1,1,1,0xFF0000,0xAA0000,0xFF0000,0xAA0000,'X'))
exit.onTouch = function()
  win:remove()
end
local function changePosition(where,fromposition,toposition)
  if where[toposition] and where[fromposition] then
    tmp = where[toposition]
    tmp2 = where[fromposition]
    where[toposition] = tmp2
    where[fromposition] = tmp
  end
end
local title = win:addChild(GUI.text(1,1,0x505050,'Editor 0.2'))
local screen = win:addChild(GUI.container(2,3,160,50))
local params = win:addChild(GUI.filledWindow(102,24,40,20,0x989898))
local obj = win:addChild(GUI.filledWindow(102,2,36,20,0x989898))
function hts(...)
  return ("0x%06X"):format(...)
end
function it(...)
  return params:addChild(GUI.input(...))
end
function bn(...)
  return params:addChild(GUI.button(...))
end
function tt(...)
  return params:addChild(GUI.text(...))
end
function bx(...)
  return params:addChild(GUI.comboBox(...))
end
function del() for i = 1,#game.screen do if what == game.screen[i] then table.remove(game.screen,i) break end end draw() drawtree() drawparams(game.screen[1]) end
function drawparams(whatt)
  what = whatt
  params:removeChildren()
  if not what then 
    params:addChild(GUI.panel(1,1,40,25,cr1))
    return 
  end
  params:addChild(GUI.panel(1,1,40,25,cr1))
  tt(1,1,0x505050,'Params')
  if what.type == 'text' then
    tt(1,2,cr2,lc.type..' | '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.text)
    tt(1,7,cr2,lc.color)
    tt(1,8,cr2,lc.visible)
    tt(1,9,cr2,lc.delete)
    tt(1,10,cr2,lc.up)
    tt(1,11,cr2,lc.down)
    local tmp = bn(15,10,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,11,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,9,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(15, 8, 20, 1, cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
    local xx = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    xx.onInputFinished = function()
      what.x = xx.text
      draw()
    end
    local yy = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    yy.onInputFinished = function()
      what.y = yy.text
      draw()
    end
    local Text = it(15, 6, 20, 1, cr1, cr2, cr3, cr1, cr2, what.text, "T")
    Text.onInputFinished = function()
       what.text = Text.text
       draw()
    end
    local color = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.color), "C")
    color.onInputFinished = function()
      what.color = tonumber(color.text)
      draw()
    end
    local name = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    name.onInputFinished = function()
      what.name = name.text
      drawtree()
    end
  elseif what.type == 'button' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.heigth)
    tt(1,7,cr2,lc.widht)
    tt(1,8,cr2,lc.text)
    tt(1,9,cr2,lc.colorbg)
    tt(1,10,cr2,lc.colorgbp)
    tt(1,11,cr2,lc.colorfg)
    tt(1,12,cr2,lc.colorfgp)
    tt(1,13,cr2,lc.onTouch)
    tt(1,14,cr2,lc.visible)
    tt(1,15,cr2,lc.delete)
    tt(1,16,cr2,lc.up)
    tt(1,17,cr2,lc.down)
    local tmp = bn(15,16,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,17,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,15,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(15, 14, 5, 1, cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x =tmp.text
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tmp.text
      draw()
    end
    local tmp = it(15, 8, 20, 1, cr1, cr2, cr3, cr1, cr2, what.text, "T")
    tmp.onInputFinished = function()
       what.text = tmp.text
       draw()
    end
    local tmp = it(15, 9, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorbg), "BG")
    tmp.onInputFinished = function()
      what.colorbg = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 10, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorbgp), "BGP")
    tmp.onInputFinished = function()
      what.colorbgp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 12, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorfgp), "FGP")
    tmp.onInputFinished = function()
      what.colorfgp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 11, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorfg), "FG")
    tmp.onInputFinished = function()
      what.colorfg = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 6, 20,1,cr1, cr2, cr3, cr1, cr2, what.height, "H")
    tmp.onInputFinished = function()
      what.height = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 13, 20,1, cr1, cr2, cr3, cr1, cr2, string.gsub(what.onTouch,'.lua',''), "oT")
    tmp.onInputFinished = function()
      what.onTouch = tmp.text .. '.lua'
    end
    local tmp = it(15, 3, 20,1,cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
  elseif what.type == 'script' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,lc.path)
    tt(1,5,cr2,lc.autoload)
    tt(1,6,cr2,lc.delete)
    tt(1,7,cr2,lc.up)
    tt(1,8,cr2,lc.down)
    local tmp = bn(15,7,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.scripts,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,8,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.scripts,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,6,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = function() for i = 1,#game.script do if what == game.script[i] then table.remove(game.script,i) break end end draw() drawtree() drawparams(game.script[1]) end
    local tmp = bx(15, 5, 5, 1, cr1, cr2, cr1, cr2)
    if what.autoload == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.autoload = true
       draw()
     end
     tmp:addItem(lc.falsee).onTouch = function()
        what.autoload = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.autoload = false
        draw()
      end
      tmp:addItem(lc.truee).onTouch = function()
        what.autoload = true
        draw()
      end
    end
    local tmp  = bn(15,4,#what.path,1,cr1,cr2,cr1,cr2,what.path)
    tmp.onTouch = function()
      system.execute(paths.system.applicationMineCodeIDE, what.path)
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
  elseif what.type == 'image' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.image)
    tt(1,7,cr2,lc.visible)
    tt(1,8,cr2,lc.delete)
    tt(1,9,cr2,lc.up)
    tt(1,10,cr2,lc.down)
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2, what.image, "I")
    tmp.onInputFinished = function()
      what.image = tmp.text
      draw()
    end
    local tmp = bn(15,9,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,10,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,8,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(15, 7, 5, 1, cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x =tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tonumber(tmp.text)
      draw()
    end
  elseif what.type == 'input' then
    tt(1,2,cr2,lc.type..': | '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.heigth)
    tt(1,7,cr2,lc.width)
    tt(1,8,cr2,lc.text)
    tt(1,9,cr2,lc.ph)
    tt(1,10,cr2,lc.colorbg)
    tt(1,11,cr2,lc.colorbgp)
    tt(1,12,cr2,lc.colorfg)
    tt(1,13,cr2,lc.colorfgp)
    tt(1,14,cr2,lc.colorph)
    tt(1,15,cr2,lc.path)
    tt(1,16,cr2,lc.delete)
    tt(1,17,cr2,lc.visible)
    tt(1,18,cr2,lc.up)
    tt(1,19,cr2,lc.down)
    local tmp = bn(15,18,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,19,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,16,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(15, 17, 5, 1, cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
    local tmp = it(15, 14, 20, 1, cr1, cr2, cr3, cr1, cr2, hts(what.colorph), "PH")
    tmp.onInputFinished = function()
      what.colorph =tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x =tmp.text
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tmp.text
      draw()
    end
    local tmp = it(15, 8, 20, 1, cr1, cr2, cr3, cr1, cr2, what.text, "T")
    tmp.onInputFinished = function()
       what.text = tmp.text
       draw()
    end
    local tmp = it(15, 9, 20, 1, cr1, cr2, cr3, cr1, cr2, what.textph, "T")
    tmp.onInputFinished = function()
       what.textph = tmp.text
       draw()
    end
    local tmp = it(15, 10, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorbg), "BG")
    tmp.onInputFinished = function()
      what.colorbg = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 11, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorbgp), "BGP")
    tmp.onInputFinished = function()
      what.colorbgp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 13, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorfgp), "FGP")
    tmp.onInputFinished = function()
      what.colorfgp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 12, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorfg), "FG")
    tmp.onInputFinished = function()
      what.colorfg = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2, what.height, "H")
    tmp.onInputFinished = function()
      what.height = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 15, 20,1, cr1, cr2, cr3, cr1, cr2, string.gsub(what.onInputEnded,'.lua',''), "oT")
    tmp.onInputFinished = function()
      what.onInputEnded = tmp.text .. '.lua'
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
  elseif what.type == 'switch' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.width)
    tt(1,7,cr2,lc.colorp)
    tt(1,8,cr2,lc.colors)
    tt(1,9,cr2,lc.colorpp)
    tt(1,10,cr2,lc.path)
    tt(1,11,cr2,lc.state)
    tt(1,12,cr2,lc.visible)
    tt(1,13,cr2,lc.delete)
    tt(1,14,cr2,lc.up)
    tt(1,15,cr2,lc.down)
    local tmp = bn(15,14,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,15,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(15, 3, 5,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(15,13,6,1,cr1,cr2,cr1,cr2,'Delete')
    tmp.onTouch = del
    local tmp = bx(15, 12, 20, 1,cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2, string.gsub(what.onStateChanged,'.lua',''), "oSC")
    tmp.onInputFinished = function()
      what.onStateChanged = tmp.text .. '.lua'
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorp), "P")
    tmp.onInputFinished = function()
      what.colorp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 8, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colors), "S")
    tmp.onInputFinished = function()
      what.colorbs = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 9, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorpp), "PP")
    tmp.onInputFinished = function()
      what.colorpp = tonumber(tmp.text)
      draw()
    end
    local tmp = bx(15, 11, 20, 1,cr1, cr2, cr1,cr2)
    if what.state == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.state = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.state = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.state = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.state = true
        draw()
      end
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x =tmp.text
      draw()
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tmp.text
      draw()
    end
  elseif what.type == 'window' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,3,cr2,lc.width)
    tt(1,4,cr2,lc.heigth)
    tt(1,5,cr2,lc.title)
    tt(1,6,cr2,lc.titleColor)
    tt(1,7,cr2,lc.color)
    tt(1,8,cr2,lc.actionbuttons)
    tt(1,9,cr2,lc.iconi)
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
          drawtree()
    end
    local tmp = it(15, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.heigth, "H")
    tmp.onInputFinished = function()
      what.heigth = tonumber(tmp.text)
      draw()
          drawtree()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.color), "C")
    tmp.onInputFinished = function()
      what.color = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.titleColor), "CT")
    tmp.onInputFinished = function()
      what.titleColor = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 5, 20,1, cr1, cr2, cr3, cr1, cr2,  what.title, "T")
    tmp.onInputFinished = function()
      what.title = tmp.text
      draw()
    end
    local tmp = bx(15, 8, 5, 1,cr1, cr2, cr1, cr2)
    if what.abn == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.abn = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.abn = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.abn = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.abn = true
        draw()
      end
    end
  elseif what.type == 'colorSelector' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.width)
    tt(1,7,cr2,lc.heigth)
    tt(1,8,cr2,lc.color)
    tt(1,9,cr2,lc.text)
    tt(1,10,cr2,lc.path)
    tt(1,11,cr2,lc.visible)
    tt(1,12,cr2,lc.delete)
    tt(1,13,cr2,lc.up)
    tt(1,14,cr2,lc.down)
    local tmp = bn(15,13,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,14,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(15, 9, 20,1, cr1, cr2, cr3, cr1, cr2, what.path, "P")
    tmp.onInputFinished = function()
      what.path = tmp.text
      draw()
    end
    local tmp = it(15, 9, 20,1, cr1, cr2, cr3, cr1, cr2, what.text, "T")
    tmp.onInputFinished = function()
      what.text = tmp.text
      draw()
    end
    local tmp = it(15, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.color), "C")
    tmp.onInputFinished = function()
      what.color = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.height, "H")
    tmp.onInputFinished = function()
      what.height = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x =tmp.text
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tmp.text
      draw()
    end
    local tmp = bn(15,12,6,1,cr1,cr2,cr1,cr2,'Delete')
    tmp.onTouch = del
    local tmp = bx(15,11, 5, 1,cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
  elseif what.type == 'progressBar' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.width)
    tt(1,7,cr2,lc.colorp)
    tt(1,8,cr2,lc.colors)
    tt(1,9,cr2,lc.colorv)
    tt(1,10,cr2,lc.value)
    tt(1,11,cr2,lc.visible)
    tt(1,12,cr2,lc.delete)
    tt(1,13,cr2,lc.up)
    tt(1,14,cr2,lc.down)
    local tmp = bn(15,13,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,14,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(15, 10, 20,1, cr1, cr2, cr3, cr1, cr2, what.value, "V")
    tmp.onInputFinished = function()
      what.value = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorp), "P")
    tmp.onInputFinished = function()
      what.colorp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colors), "S")
    tmp.onInputFinished = function()
      what.colors = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorv), "V")
    tmp.onInputFinished = function()
      what.colorv = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x =tmp.text
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tmp.text
      draw()
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(15,12,6,1,cr1,cr2,cr1,cr2,'Delete')
    tmp.onTouch = del
    local tmp = bx(15, 11, 5, 1,cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
  elseif what.type == 'comboBox' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.width)
    tt(1,7,cr2,lc.elh)
    tt(1,8,cr2,lc.colorbg)
    tt(1,9,cr2,lc.colort)
    tt(1,10,cr2,lc.colorabg)
    tt(1,11,cr2,lc.colorat)
    tt(1,12,cr2,lc.items)
    tt(1,13,cr2,lc.visible)
    tt(1,14,cr2,lc.delete)
    tt(1,15,cr2,lc.up)
    tt(1,16,cr2,lc.down)
    local tmp = bn(15,15,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,16,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,12, 4,1, cr1, cr2, cr1, cr2,  lc.show)
    tmp.onTouch = function()
      choosed = what.items[1]
      local choose = win:addChild(GUI.filledWindow(1,1,45,12,cr1))
      local function update()
      local tmp1 = choose:addChild(GUI.comboBox(2,2,20,3,cr2,cr1,cr2,cr1))
      local tmp = choose:addChild(GUI.input(1,6, 20,1, cr1, cr2, cr3, cr1, cr2,  choosed.name, "N")) 
      tmp.onInputFinished = function()
        choosed.name = tmp.text
        draw()
      end
      local tmp = choose:addChild(GUI.comboBox(1, 10, 5, 1,cr1, cr2, cr1, cr2))
     if choosed.active == false then
        tmp:addItem(lc.truee).onTouch = function()
          choosed.active = false
          draw()
        end
        tmp:addItem(lc.falsee).onTouch = function()
          choosed.active = true
          draw()
        end
      else
        tmp:addItem(lc.falsee).onTouch = function()
          choosed.active =true
          draw()
        end
       tmp:addItem(lc.truee).onTouch = function()
          choosed.active = false
          draw()
        end
      end
      local tmp = choose:addChild(GUI.button(30,8,#lc.close,1,cr1,cr2,cr1,cr2,lc.close))
      tmp.onTouch = function()
       choose:remove()
       draw()
      end
      local tmp = choose:addChild(GUI.input(1,8, 20, 1,cr1, cr2, cr3, cr1, cr2,  choosed.path, "P")) 
      tmp.onInputFinished = function()
        choosed.path = tonumber(tmp.text)
      end
        tmp1:addItem(choosed.name).onTouch = function()
         update()
        end
      for i = 1,#what.items do
        if what.items[i] ~= choosed then
        tmp1:addItem(what.items[i].name).onTouch = function()
         choosed = what.items[i]
         update()
        end
        end
      end
      local tmp = choose:addChild(GUI.button(30,2,#lc.add,1,cr1,cr2,cr1,cr2,lc.add))
      tmp.onTouch = function()
        table.insert(what.items,{name='Item',path='',active=false})
        choosed = what.items[#what.items]
        update()
      end
      local tmp = choose:addChild(GUI.button(30,4,#lc.remove,1,cr1,cr2,cr1,cr2,lc.remove))
      tmp.onTouch = function()
        for i = 1,#what.items do 
        if what.items[i] == choosed then
          table.remove(what.items,i)
        end end
        choosed = what.items[#what.items]
        update()
      end
    end  update() end
    local tmp = it(15, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorbg), "BG")
    tmp.onInputFinished = function()
      what.colorbg = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colort), "T")
    tmp.onInputFinished = function()
      what.colort = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 10, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorabg), "ABG")
    tmp.onInputFinished = function()
      what.colorabg = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 11, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorat), "AT")
    tmp.onInputFinished = function()
      what.colorat = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.elh, "ELH")
    tmp.onInputFinished = function()
      what.elh = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x =tmp.text
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tmp.text
      draw()
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(15,14,6,1,cr1,cr2,cr1,cr2,'Delete')
    tmp.onTouch = del
    local tmp = bx(10, 13, 5, 1,cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
  elseif what.type == 'slider' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.width)
    tt(1,7,cr2,lc.colorp)
    tt(1,8,cr2,lc.colorpp)
    tt(1,9,cr2,lc.colorv)
    tt(1,10,cr2,lc.minv)
    tt(1,11,cr2,lc.maxv)
    tt(1,12,cr2,lc.value)
    tt(1,13,cr2,lc.path)
    tt(1,14,cr2,lc.visble)
    tt(1,15,cr2,lc.delete)
    tt(1,16,cr2,lc.up)
    tt(1,17,cr2,lc.down)
    local tmp = bn(15,16,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,17,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(15, 13, 20,1, cr1, cr2, cr3, cr1, cr2, what.path, "P")
    tmp.onInputFinished = function()
      what.path = tmp.text
      draw()
    end
    local tmp = it(15, 10, 20,1, cr1, cr2, cr3, cr1, cr2, what.minv, "MINV")
    tmp.onInputFinished = function()
      what.minv = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 11, 20,1, cr1, cr2, cr3, cr1, cr2, what.maxv, "MAXV")
    tmp.onInputFinished = function()
      what.maxv = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 12, 20,1, cr1, cr2, cr3, cr1, cr2, what.value, "V")
    tmp.onInputFinished = function()
      what.value = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorp), "P")
    tmp.onInputFinished = function()
      what.colorp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorpp), "PP")
    tmp.onInputFinished = function()
      what.colorpp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorv), "V")
    tmp.onInputFinished = function()
      what.colorv = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x =tmp.text
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tmp.text
      draw()
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(15,15,6,1,cr1,cr2,cr1,cr2,'Delete')
    tmp.onTouch = del
    local tmp = bx(10, 14, 5, 1,cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
  elseif what.type == 'progressIndicator' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.colorpa)
    tt(1,7,cr2,lc.colorp)
    tt(1,8,cr2,lc.colors)
    tt(1,9,cr2,lc.visible)
    tt(1,10,cr2,lc.delete)
    tt(1,11,cr2,lc.up)
    tt(1,12,cr2,lc.down)
    local tmp = bn(15,11,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,12,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorpa), "PA")
    tmp.onInputFinished = function()
      what.colorpa = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorp), "P")
    tmp.onInputFinished = function()
      what.colorp = tonumber(tmp.text)
      draw()
    end
    local tmp = it(12, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colors), "S")
    tmp.onInputFinished = function()
      what.colors = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(15,10,6,1,cr1,cr2,cr1,cr2,'Delete')
    tmp.onTouch = del
    local tmp = bx(15, 9, 5, 1,cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
  elseif what.type == 'panel' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,'X')
    tt(1,5,cr2,'Y')
    tt(1,6,cr2,lc.width)
    tt(1,7,cr2,lc.heigth)
    tt(1,8,cr2,lc.color)
    tt(1,9,cr2,lc.visible)
    tt(1,10,cr2,lc.delete)
    tt(1,11,cr2,lc.up)
    tt(1,12,cr2,lc.down)
    local tmp = it(12, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.color), "S")
    tmp.onInputFinished = function()
      what.color = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 6, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
      what.width = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.heigth, "H")
    tmp.onInputFinished = function()
      what.heigth = tonumber(tmp.text)
      draw()
    end
    local tmp = bn(15,11,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(15,12,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(game.screen,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = it(15, 4, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
      what.x = tonumber(tmp.text)
      draw()
    end
    local tmp = it(15, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
      what.y = tonumber(tmp.text)
      draw()
    end
    local tmp = bn(15,10,6,1,cr1,cr2,cr1,cr2,'Delete')
    tmp.onTouch = del
    local tmp = bx(15, 9, 5, 1,cr1, cr2, cr1, cr2)
    if what.visible == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.visible = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.visible = true
        draw()
      end
    end
  elseif what.type == 'file' then
    tt(1,2,cr2,lc.type..': '..what.type)
    tt(1,3,cr2,lc.name)
    tt(1,4,cr2,lc.path)
    local tmp = params:addChild(GUI.filesystemChooser(15, 4, 10, 1,cr1, cr2, cr1, cr2, nil, lc.open, lc.close, string.gsub(what.path,fs.extension(what.path) or '',''), "/"))
    tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
    tmp.onSubmit = function(path)
      what.path = path
      drawtree()
      draw()
    end
    local tmp = it(15, 3, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
      draw()
    end
  else
    tt(1,1,cr2,lc.WYC)
  end
end
function objectmenu()
  choose = win:addChild(GUI.filledWindow(55,20,50,20,cr1))
  choose.actionButtons.close.onTouch = function() choose:remove() end
  if treemode == 'screen' then
  local tmp = choose:addChild(GUI.button(6,14,#lc.panel,1,cr1,cr2,cr1,cr2,lc.panel))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'panel',x=1,y=1,color=cr1,width = 10,heigth=  10,name = 'Panel'})
  end
  local tmp = choose:addChild(GUI.button(6,4,#lc.text,1,cr1,cr2,cr1,cr2,lc.text))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'text',x=1,y=1,color=cr1,text='Text',name = 'Text'})
  end
  local tmp = choose:addChild(GUI.button(15,10,#lc.progressBar,1,cr1,cr2,cr1,cr2,lc.progressBar))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,width=20,colorp = cr1,colors=cr2,colorv=cr2,type = 'progressBar',x=1,y=1,color=cr1,value=50,name = 'ProgressBar'})
  end
  local tmp = choose:addChild(GUI.button(15,8,#lc.comboBox,1,cr1,cr2,cr1,cr2,lc.comboBox))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'comboBox',width=20,x=1,y=1,elh=3,items={{name='item',active = false,type='itemComboBox',path=''}},colorbg=cr1,colort=cr2,colorabg=cr2,colorat=cr2,name = 'ComboBox'})
  end
  local tmp = choose:addChild(GUI.button(15,6,#lc.slider,1,cr1,cr2,cr1,cr2,lc.slider))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'slider',x=1,y=1,width=20,colorp=cr1,colors=cr2,colorpp=cr1,colorv=cr2,minv=1,maxv=100,value=50,text='Text',name = 'Slider'})
  end
  local tmp = choose:addChild(GUI.button(15,4,#lc.progressIndicator,1,cr1,cr2,cr1,cr2,lc.progressIndicator))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'progressIndicator',x=1,y=1,active=false,rollStage=1,colorp=cr1,colors=cr2,colorpa=cr3,name = 'pI'})
  end
  local tmp = choose:addChild(GUI.button(15,2,#lc.collorSelector,1,cr1,cr2,cr1,cr2,lc.collorSelector))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,path='',type = 'colorSelector',color=0xFF00FF,x=1,y=1,width=20,height=3,text='Color',name = 'ColorSelector'})
  end
  local tmp = choose:addChild(GUI.button(6,10,#lc.input,1,cr1,cr2,cr1,cr2,lc.input))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,onInputEnded = '',width=20,height=3,colorbg = 0x989898,colorfg = 0x505050,colorfgp = 0x50505050,colorbgp = 0x989898,colorph=0x2D2D2D,type = 'input',x=1,y=1,name = 'Input',text = 'Input',textph = 'Text'})
  end
  local tmp = choose:addChild(GUI.button(6,12,#lc.switch,1,cr1,cr2,cr1,cr2,lc.switch))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,state=false,type = 'switch',x=1,y=1,width=8,colorp=0x505050,colors=0x505050,colorpp=0x989898,name = 'Switch'})
  end
  local tmp = choose:addChild(GUI.button(6,8,#lc.image,1,cr1,cr2,cr1,cr2,lc.image))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true, type = 'image',x=1,y=1,image='StorageEl',name = 'image',path = 'Script'})
  end
  local tmp = choose:addChild(GUI.button(6,6,#lc.button,1,cr1,cr2,cr1,cr2,lc.button))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,onTouch = '', height = 5,width = 20, type = 'button',x=1,y=1,name = 'button',colorbg= cr1,colorfg = cr2,colorbgp = cr1,colorfgp=cr2,text='Button'})
  end
  elseif treemode == 'script' then
    local tmp = choose:addChild(GUI.button(6,3,#lc.scripts,1,cr1,cr2,cr1,cr2,lc.scripts))
    tmp.onTouch = function()
    choose:remove()
    fs.write('/Temporary/'..tostring(#game.scripts+1)..'.lua',lc.DFtS)
    new(game.scripts,{autoload = false,path = '/Temporary/'..tostring(#game.scripts+1)..'.lua',name = 'script',type = 'script'})
  end
  elseif treemode == 'storage' then
local tmp = choose:addChild(GUI.filesystemChooser(2, 5, 10, 1, cr1, cr2, cr1, cr2, nil, lc.open, lc.close, lc.name, "/"))
tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
tmp.onSubmit = function(path)
choose:remove()
    new(game.storage,{path = path,name = 'StorageEl',type = 'file'})
  draw()
  drawtree()
end
  end
end

function new(where,what)
  table.insert(where,what)
  for i = 1,#where do
    if where[i].name == what.name and where[i].type == what.type and where[i].x == what.x and where[i].y == what.y then
      drawparams(where[i])
    end
  end
  drawtree()
  draw()
end

function drawtree()
  obj:removeChildren()
  obj:addChild(GUI.panel(1,1,36,20,0x989898))
  local screenmode = obj:addChild(GUI.button(1,1,#lc.screen,1,cr1,cr2,cr1,cr2,lc.screen))
  screenmode.onTouch = function()
    treemode = 'screen'
    drawparams(game.screen[1])
    drawtree()
  end
  local storagemode = obj:addChild(GUI.button(19,1,#lc.storage,1,cr1,cr2,cr1,cr2,lc.storage))
  storagemode.onTouch = function()
    treemode = 'storage'
    drawparams(game.storage[1])
    drawtree()
  end
  local scriptmode = obj:addChild(GUI.button(8,1,#lc.scripts,1,cr1,cr2,cr1,cr2,lc.scripts))
  scriptmode.onTouch = function()
    treemode = 'script'
    drawparams(game.scripts[1])
    drawtree()
  end
  if treemode == 'screen' then
    local tmp = obj:addChild(GUI.button(1,2,#lc.screen,1,cr1,cr2,cr1,cr2,lc.screen))
    tmp.onTouch = function()
       drawparams(game.window)
    end
    local addScreen = obj:addChild(GUI.button(#lc.screen,2,1,1,cr1,cr2,cr1,cr2,'+'))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 3
    for i = 1,#game.screen do
      tmp = obj:addChild(GUI.button(2,y,#game.screen[i].name,1,cr1,cr2,cr1,cr2, game.screen[i].name))
      tmp.onTouch = function()
        drawparams(game.screen[i])
      end
      y = y + 1
    end
  elseif treemode == 'script' then
   obj:addChild(GUI.text(1,2,0x505050,lc.scripts))
   local addScreen = obj:addChild(GUI.button(#lc.scripts,2,1,1,cr1,cr2,cr1,cr2,'+'))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 3
    for i = 1,#game.scripts do
      tmp = obj:addChild(GUI.button(2,y,#game.scripts[i].name,1,cr1,cr2,cr1,cr2, game.scripts[i].name))
      tmp.onTouch = function()
        drawparams(game.scripts[i])
      end
      y = y + 1
    end
  elseif treemode == 'storage' then
   obj:addChild(GUI.text(1,2,0x505050,lc.storage))
   local addScreen = obj:addChild(GUI.button(#lc.storage,2,1,1,cr1,cr2,cr1,cr2,'+'))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 3
    for i = 1,#game.storage do
      tmp = obj:addChild(GUI.button(2,y,#game.storage[i].name,1,cr1,cr2,cr1,cr2, game.storage[i].name))
      tmp.onTouch = function()
        drawparams(game.storage[i])
      end
      y = y + 1
    end
  end
end

function draw()
  screen:removeChildren()
  gamee = game.screen
  screen:addChild(GUI.panel(1,1,game.window.width,game.window.heigth,game.window.color))
  screen:addChild(GUI.text(math.floor(game.window.width/2),1,game.window.titleColor,game.window.title))
  if game.window.abn == true then
    screen:addChild(GUI.actionButtons(1,1,false))
  end
  for i = 1,#gamee do
    if gamee[i].visible == true then
      if gamee[i].type == 'text' then
        screen:addChild(GUI.text(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].color),gamee[i].text))
      end
      if gamee[i].type == 'panel' then
        screen:addChild(GUI.panel(tonumber(gamee[i].x),tonumber(gamee[i]).y,tonumber(gamee[i].width),tonumber(gamee[1].heigth),tonumber(gamee[i].color)))
      end
      if gamee[i].type == 'button' then
        screen:addChild(GUI.button(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].height),tonumber(gamee[i].colorbg),tonumber(gamee[i].colorfg),tonumber(gamee[i].colorbgp),tonumber(gamee[i].colorfgp),gamee[i].text))
      end
      if gamee[i].type == 'slider' then
        screen:addChild(GUI.slider(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].colorp),tonumber(gamee[i].colors),tonumber(gamee[i].colorpp),tonumber(gamee[i].colorv),tonumber(gamee[i].minv),tonumber(gamee[i].maxv),tonumber(gamee[i].value)))
      end
      if gamee[i].type == 'progressIndicator' then
        screen:addChild(GUI.progressIndicator(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].colorpa),tonumber(gamee[i].colorp),tonumber(gamee[i].colors)))
      end
      if gamee[i].type == 'progressBar' then
        screen:addChild(GUI.progressBar(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].colorp),tonumber(gamee[i].colors),tonumber(gamee[i].colorv),tonumber(gamee[i].value)))
      end
      if gamee[i].type == 'comboBox' then
        local tmp = screen:addChild(GUI.comboBox(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].elh),tonumber(gamee[i].colorbg),tonumber(gamee[i].colort),tonumber(gamee[i].colorabg),tonumber(gamee[i].colorat)))
        for e = 1,#gamee[i].items do
          tmp:addItem(gamee[i].items[e].name,gamee[i].items[e].active)
        end
      end
      if gamee[i].type == 'colorSelector' then
        screen:addChild(GUI.colorSelector(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].height),tonumber(gamee[i].color),gamee[i].text))
      end
      if gamee[i].type == 'input' then
       screen:addChild(GUI.input(gamee[i].x,gamee[i].y,gamee[i].width,gamee[i].height,gamee[i].colorbg,gamee[i].colorfg,gamee[i].colorph,gamee[i].colorfg,gamee[i].colorfgp,gamee[i].text,gamee[i].textph))
      end
      if gamee[i].type == 'switch' then
        screen:addChild(GUI.switch(tonumber(gamee[i].x),tonumber(gamee[i].y),tonumber(gamee[i].width),tonumber(gamee[i].colorp),tonumber(gamee[i].colors),tonumber(gamee[i].colorpp),gamee[i].state))
      end
      if gamee[i].type == 'image' then
        idk = nil
        for e = 1,#game.storage do
          if game.storage[e].name == gamee[i].image and fs.extension(game.storage[e].path) == '.pic' then
            idk = game.storage[e].path
          end
        end
        if idk == nil then idk = '/MineOS/Icons/Script.pic' end
        screen:addChild(GUI.image(tonumber(gamee[i].x),tonumber(gamee[i].y),image.load(idk)))
      end
    end
  end
end

local tmp = win:addChild(GUI.filesystemChooser(14, 1, 10, 1, cr1, cr2, cr1, cr2, nil, lc.save, lc.close, lc.name, "/"))
tmp:setMode(GUI.IO_MODE_SAVE, GUI.IO_MODE_FILE)
tmp.onSubmit = function(path)
  if fs.exists(path) then GUI.alert(lc.YNEF) return end
  fs.makeDirectory(path..'.proj')
  fs.writeTable(path..'.proj/Game.dat',game)
  for i = 1,#game.storage do
    fs.copy(game.storage[i].path,path..'.proj/'..fs.name(game.storage[i].path))
  end
  for i = 1,#game.scripts do
    fs.copy(game.scripts[i].path,path..'.proj/'..game.scripts[i].name..'.lua')
  end
  draw()
  drawtree()
end
local tmp = win:addChild(GUI.filesystemChooser(28, 1, 10, 1, cr1, cr2, cr1, cr2, nil, lc.open, lc.close, lc.name, "/"))
tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_DIRECTORY)
tmp.onSubmit = function(path)
  if not fs.exists(path..'/Game.dat') then GUI.alert(lc.UFP) end
  game = fs.readTable(path..'/Game.dat')
  idk = fs.list(path)
  for i = 1,#idk do
    for e = 1, #game.storage do
      if game.storage[e].name == string.gsub(idk[i],fs.extension(idk[i]) or '','') then
        game.storage[e].path = path..idk[i]
      end
    end
    if fs.extension(idk[i]) == '.lua' then
      for e = 1, #game.scripts do
        if game.scripts[e].name == string.gsub(idk[i],'.lua','') then
          game.scripts[e].path = path..idk[i]
        end
      end
    end
  end
  draw()
  drawtree()
end
local filesystemChooser = win:addChild(GUI.filesystemChooser(50, 1, 10, 1, cr1, cr2, cr1, cr2, nil, lc.export, lc.close, lc.name, "/"))
filesystemChooser:setMode(GUI.IO_MODE_SAVE, GUI.IO_MODE_FILE)
filesystemChooser.onSubmit = function(path)
  if fs.exists(path) then GUI.alert(lc.EF) return end
  fs.makeDirectory(path..'.app')
  local towrite = ''
  towrite = towrite .. 'image = require("Image")\nfs = require("filesystem")\nevent = require("event")\nGUI = require("GUI")\n system = require("System")\nrequire("opengames")\nscriptpath = string.gsub(system.getCurrentScript(),"/Main.lua","")\ngame = fs.readTable(scriptpath.."/Game.dat")\ngame.localization=system.getCurrentScriptLocalization()\nwk,win,menu = system.addWindow(GUI.filledWindow(1,1,game.window.width,game.window.heigth,0x989898))\n'
  fs.makeDirectory(path..'.app/Scripts')
  fs.makeDirectory(path..'.app/Assests')
  fs.makeDirectory(path..'.app/Localizations')
  for i = 1,#game.storage do
    if fs.extension(game.storage[i].path) == '.lang' then 
      fs.copy(game.storage[i].path,path..'.app/Localizations/'..fs.name(game.storage[i].path)) 
    else
      fs.copy(game.storage[i].path,path..'.app/Assests/'..fs.name(game.storage[i].path))
    end
  end
  for i = 1,#game.scripts do
    fs.copy(game.scripts[i].path,path..'.app/Scripts/'..game.scripts[i].name..'.lua')
  end
  for i = 1, #game.storage do
    game.storage[i].path = path..'.app/Assests/'..fs.name(game.storage[i].path)
  end
  for i = 1, #game.scripts do
    game.scripts[i].path = path..'.app/Scripts/'..game.scripts[i].name..'.lua'
  end
  fs.writeTable(path..'.app/Game.dat',game)
  towrite = towrite .. 'draw()\n for i = 1,#game.scripts do\n if game.scripts[i].autoload == true then\n system.execute(game.scripts[i].path)\n end\n end\n'
  fs.write(path..'.app/Main.lua',towrite)
  idk = nil
  for e = 1,#game.storage do
    if game.storage[e].name == 'Icon' then
      idk = game.storage[e].path
    end
  end
  if idk == nil then idk = '/MineOS/Icons/Script.pic' end
  fs.copy(idk,path..'.app/Icon.pic')
end
draw()
drawtree()
drawparams()
 
