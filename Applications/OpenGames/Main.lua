local GUI = require('gui')
local paths = require('paths')
local system = require('system')
local event = require('event')
local image = require('image')
local fs = require('filesystem')
local OE = require('opengames')
local compressor = require('compressor')
local lc = system.getCurrentScriptLocalization()
local userSettings = system.getUserSettings()
if not userSettings.opengames then
		userSettings.opengames = {}
		system.saveUserSettings()
end
gamepath = ''
local cr1, cr2,cr3,cr4 = userSettings.opengames.cr1 or 0x989898, userSettings.opengames.cr2 or 0x505050,userSettings.opengames.cr3 or 0x000000,userSettings.opengames.cr4 or 0x757575
treemode = 'screen'
game = {scripts = {},window = {abn = userSettings.opengames.windowABN or true,type = 'window',width=userSettings.opengames.windowWidth or 80,height= userSettings.opengames.windowHeight or 40,title = userSettings.opengames.windowTitle or 'Title',color = userSettings.opengames.windowColor or cr4,titleColor = userSettings.opengames.windowTitleColor or cr2},screen = {buffer = {window={}}},storage={}}

wk,win,menu = system.addWindow(GUI.filledWindow(0,0,160,50,0x8E8E8E))
local function changePosition(idk,fromposition,toposition)
		if idk == true then
  		game.screen[fromposition].raw:moveForward()
 	else
  		game.screen[fromposition].raw:moveBackward()
 	end
end
local title = win:addChild(GUI.text(1,1,cr2,'Editor 1.3'))
local screen = win:addChild(GUI.container(2,3,160,50))
BG = screen:addChild(GUI.panel(1,1,game.window.width,game.window.heigth,game.window.color))
TITLE = screen:addChild(GUI.text(math.floor(game.window.width/2-#game.window.title/2),1,game.window.titleColor,game.window.title))
local params = win:addChild(GUI.filledWindow(102,24,40,23,cr1))
local obj = win:addChild(GUI.filledWindow(102,2,36,20,cr1))
OE.init({editor = true,game = game,container = screen})

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
function del() 
  for i = 1,#game.screen do
    if what == game.screen[i] then
    game.screen[i].raw:remove()
    table.remove(game.screen,i) 
    table.remove(game.screen.buffer,i) 
    break 
    end 
  end 
		draw() 
		drawtree() 
		drawparams(game.screen[1]) 
end
function drawparams(whatt)
  what = whatt
  params:removeChildren()
  if not what then 
    params:addChild(GUI.panel(1,1,40,27,cr1))
    return 
  end
 	if lc.close == 'Закрыть' or lc.close == 'Закрити' then
  		divide = 2
 	else
  		divide = 1
 	end
  params:addChild(GUI.panel(1,1,40,25,cr1))
  tt(3,2,cr2,'Params')
  if what.type == 'text' then
    tt(3,3,cr2,lc.type..' | '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.text)
    tt(3,8,cr2,lc.color)
    tt(3,9,cr2,lc.visible)
    tt(3,10,cr2,lc.delete)
    tt(3,11,cr2,lc.up)
    tt(3,12,cr2,lc.down)
    local tmp = bn(17,11,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,12,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,10,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 9, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2)
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
    local xx = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    xx.onInputFinished = function()
    		if xx.text ~= '' then
      		what.x = tonumber(xx.text)
     	 	draw()
     	end
    end
    local yy = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    yy.onInputFinished = function()
    		if yy.text ~= '' then
      what.y = tonumber(yy.text)
      draw()
      end
    end
    local Text = it(17, 7, 20, 1, cr1, cr2, cr3, cr1, cr2, what.text, "T")
    Text.onInputFinished = function()
       what.text = Text.text
       draw()
    end
    local color = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.color), "C")
    color.onInputFinished = function()
    		if color.text ~= '' then
      what.color = tonumber(color.text)
      draw()
      end
    end
    local name = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    name.onInputFinished = function()
      what.name = name.text
      drawtree()
    end
  elseif what.type == 'button' then
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.heigth)
    tt(3,8,cr2,lc.width)
    tt(3,9,cr2,lc.text)
    tt(3,10,cr2,lc.colorbg)
    tt(3,11,cr2,lc.colorbgp)
    tt(3,12,cr2,lc.colorfg)
    tt(3,13,cr2,lc.colorfgp)
    tt(3,14,cr2,lc.onTouch)
    tt(3,15,cr2,lc.mode)
    tt(3,16,cr2,lc.animated)
    tt(3,17,cr2,lc.switchMode)
    tt(3,18,cr2,lc.disabled)
    tt(3,19,cr2,lc.visible)
    tt(3,20,cr2,lc.delete)
    tt(3,21,cr2,lc.up)
    tt(3,22,cr2,lc.down)
    local tmp = bx(17, 15, 15, 1, cr1, cr2, cr1, cr2)
    if what.mode == 'default' then
    		tmp:addItem(lc.default).onTouch = function()
    		  what.mode = 'default'
    		  draw()
    		  drawparams(what)
    		end
    		if what.prevMode == 'framedButton' then
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'framedButton'
    		  draw()
    		  drawparams(what)
    		end
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'roundedButton'
    		  draw()
    		  drawparams(what)
    		end
    		else
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'roundedButton'
    		  draw()
    		  drawparams(what)
    		end
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'framedButton'
    		  draw()
    		  drawparams(what)
    		end
    		end
    elseif what.mode == 'framedButton' then
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.mode = 'framedButton'
    		  draw()
    		  drawparams(what)
    		end
    		if what.prevMode == 'default' then
    		tmp:addItem(lc.default).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'default'
    		  draw()
    		  drawparams(what)
    		end
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'roundedButton'
    		  draw()
    		  drawparams(what)
    		end
    	else
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'roundedButton'
    		  draw()
    		  drawparams(what)
    		end
    		tmp:addItem(lc.default).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'default'
    		  draw()
    		  drawparams(what)
    		end
    		end
    elseif what.mode == 'roundedButton' then
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.mode = 'roundedButton'
    		  draw()
    		  drawparams(what)
    		end
    		if what.prevMode == 'default' then
    		tmp:addItem(lc.default).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'default'
    		  draw()
    		  drawparams(what)
    		end
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'framedButton'
    		  draw()
    		  drawparams(what)
    		end
     else
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'framedButton'
    		  draw()
    		  drawparams(what)
    		end
    		tmp:addItem(lc.default).onTouch = function()
    		  what.prevMode = what.mode
    		  what.mode = 'default'
    		  draw()
    		  drawparams(what)
    		end
    		end
    end
    local tmp = bx(17, 16, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2)
    if what.animated == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.animated = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.animated = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.animated = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.animated = true
        draw()
      end
    end
    local tmp = bx(17, 18, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2)
    if what.disabled == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.disabled = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.disabled = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.disabled = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.disabled = true
        draw()
      end
    end
    local tmp = bx(17, 17, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2)
    if what.switchMode == true then
      tmp:addItem(lc.truee).onTouch = function()
        what.switchMode = true
        draw()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        what.switchMode = false
        draw()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        what.switchMode = false
        draw()
      end
     tmp:addItem(lc.truee).onTouch = function()
        what.switchMode = true
        draw()
      end
    end
    local tmp = bn(17,21,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,22,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,20,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 19, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2)
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
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x =tmp.text
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tmp.text
      draw()
      end
    end
    local tmp = it(17, 9, 20, 1, cr1, cr2, cr3, cr1, cr2, what.text, "T")
    tmp.onInputFinished = function()
       what.text = tmp.text
       draw()
    end
    local tmp = it(17, 10, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorbg), "BG")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorbg = tonumber(tmp.text)
      draw()
      elseif tmp.text == '{tarns}' or tmp.text == '{transparent}' then
        what.colorbg = nil
        draw()
      end
    end
    local tmp = it(17, 11, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorbgp), "BGP")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorbgp = tonumber(tmp.text)
      draw()
      elseif tmp.text == '{tarns}' or tmp.text == '{transparent}' then
        what.colorbgp = nil
        draw()
      end
    end
    local tmp = it(17, 13, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorfgp), "FGP")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorfgp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 12, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorfg), "FG")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorfg = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 7, 20,1,cr1, cr2, cr3, cr1, cr2, what.height, "H")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.height = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 14, 20,1, cr1, cr2, cr3, cr1, cr2, string.gsub(what.onTouch,'.lua',''), "oT")
    tmp.onInputFinished = function()
      what.onTouch = tmp.text .. '.lua'
    end
    local tmp = it(17, 4, 20,1,cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
  elseif what.type == 'script' then
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,lc.path)
    tt(3,6,cr2,lc.autoload)
    tt(3,7,cr2,lc.delete)
    tt(3,8,cr2,lc.up)
    tt(3,9,cr2,lc.down)
    local tmp = bn(17,8,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,9,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,7,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = function() for i = 1,#game.scripts do if what == game.scripts[i] then table.remove(game.scripts,i) break end end draw() drawtree() drawparams(game.scripts[1]) end
    local tmp = bx(17, 6, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2)
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
    local tmp  = bn(17,5,#what.path,1,cr1,cr2,cr1,cr2,what.path)
    tmp.onTouch = function()
      system.execute(paths.system.applicationMineCodeIDE, what.path)
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local codeView = params:addChild(GUI.codeView(3, 11, 36, 10, 1, 1, 1, {}, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))
local counter = 1
for line in fs.lines(what.path) do
	line = line:gsub("\t", "  "):gsub("\r\n", "\n")
	codeView.maximumLineLength = math.max(codeView.maximumLineLength, unicode.len(line))
	table.insert(codeView.lines, line)
	counter = counter + 1
	if counter > codeView.height then
		break
	end
end
  elseif what.type == 'image' then
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.image)
    tt(3,8,cr2,lc.visible)
    tt(3,9,cr2,lc.delete)
    tt(3,10,cr2,lc.up)
    tt(3,11,cr2,lc.down)
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.image, "I")
    tmp.onInputFinished = function()
      what.image = tmp.text
      draw()
    end
    local tmp = bn(17,10,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,11,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,9,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 8, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2)
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
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x =tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tonumber(tmp.text)
      draw()
      end
    end
  elseif what.type == 'input' then
    tt(3,3,cr2,lc.type..': | '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.heigth)
    tt(3,8,cr2,lc.width)
    tt(3,9,cr2,lc.text)
    tt(3,10,cr2,lc.ph)
    tt(3,11,cr2,lc.colorbg)
    tt(3,12,cr2,lc.colorbgp)
    tt(3,13,cr2,lc.colorfg)
    tt(3,14,cr2,lc.colorfgp)
    tt(3,15,cr2,lc.colorph)
    tt(3,16,cr2,lc.path)
    tt(3,17,cr2,lc.delete)
    tt(3,18,cr2,lc.visible)
    tt(3,19,cr2,lc.up)
    tt(3,20,cr2,lc.down)
    local tmp = bn(17,19,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,20,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,17,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(16, 18, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2)
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
    local tmp = it(17, 15, 20, 1, cr1, cr2, cr3, cr1, cr2, hts(what.colorph), "PH")
    tmp.onInputFinished = function()
      what.colorph =tonumber(tmp.text)
      draw()
    end
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x =tmp.text
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tmp.text
      draw()
      end
    end
    local tmp = it(17, 9, 20, 1, cr1, cr2, cr3, cr1, cr2, what.text, "T")
    tmp.onInputFinished = function()
       what.text = tmp.text
       draw()
    end
    local tmp = it(17, 10, 20, 1, cr1, cr2, cr3, cr1, cr2, what.textph, "T")
    tmp.onInputFinished = function()
       what.textph = tmp.text
       draw()
    end
    local tmp = it(17, 11, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorbg), "BG")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorbg = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 12, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorbgp), "BGP")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorbgp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 14, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorfgp), "FGP")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorfgp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 13, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorfg), "FG")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorfg = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.height, "H")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.height = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 16, 20,1, cr1, cr2, cr3, cr1, cr2, string.gsub(what.onInputEnded,'.lua',''), "oT")
    tmp.onInputFinished = function()
      what.onInputEnded = tmp.text .. '.lua'
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
  elseif what.type == 'switch' then
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.width)
    tt(3,8,cr2,lc.colorp)
    tt(3,9,cr2,lc.colors)
    tt(3,10,cr2,lc.colorpp)
    tt(3,11,cr2,lc.path)
    tt(3,12,cr2,lc.state)
    tt(3,13,cr2,lc.visible)
    tt(3,14,cr2,lc.delete)
    tt(3,15,cr2,lc.up)
    tt(3,16,cr2,lc.down)
    local tmp = bn(17,15,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,16,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(17, 4, 5,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(17,14,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 13, #lc.falsee/divide+2+4, 1,cr1, cr2, cr1, cr2)
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
    local tmp = it(17, 11, 20,1, cr1, cr2, cr3, cr1, cr2, string.gsub(what.onStateChanged,'.lua',''), "oSC")
    tmp.onInputFinished = function()
      what.onStateChanged = tmp.text .. '.lua'
      draw()
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorp), "P")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 9, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colors), "S")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colors = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 10, 20,1, cr1, cr2, cr3, cr1, cr2, hts(what.colorpp), "PP")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorpp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = bx(17, 12, #lc.falsee/divide+2+4, 1,cr1, cr2, cr1,cr2)
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
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x =tmp.text
      draw()
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tmp.text
      draw()
      end
    end
  elseif what.type == 'window' then
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.width)
    tt(3,5,cr2,lc.heigth)
    tt(3,6,cr2,lc.title)
    tt(3,7,cr2,lc.titleColor)
    tt(3,8,cr2,lc.color)
    tt(3,9,cr2,lc.actionbuttons)
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
          drawtree()
          end
    end
    local tmp = it(17, 5, 20,1, cr1, cr2, cr3, cr1, cr2, what.height, "H")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.height = tonumber(tmp.text)
      draw()
          drawtree()
          end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.color), "C")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.color = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.titleColor), "CT")
    tmp.onInputFinished = function()
      what.titleColor = tonumber(tmp.text)
      draw()
    end
    local tmp = it(17, 6, 20,1, cr1, cr2, cr3, cr1, cr2,  what.title, "T")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.title = tmp.text
      draw()
      end
    end
    local tmp = bx(17, 9, #lc.falsee/divide+2+4, 1,cr1, cr2, cr1, cr2)
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
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.width)
    tt(3,8,cr2,lc.heigth)
    tt(3,9,cr2,lc.color)
    tt(3,10,cr2,lc.text)
    tt(3,11,cr2,lc.path)
    tt(3,12,cr2,lc.visible)
    tt(3,13,cr2,lc.delete)
    tt(3,14,cr2,lc.up)
    tt(3,15,cr2,lc.down)
    local tmp = bn(17,14,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,15,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(17, 11, 20,1, cr1, cr2, cr3, cr1, cr2, what.path, "P")
    tmp.onInputFinished = function()
      what.path = tmp.text .. '.lua'
      draw()
    end
    local tmp = it(17, 10, 20,1, cr1, cr2, cr3, cr1, cr2, what.text, "T")
    tmp.onInputFinished = function()
      what.text = tmp.text
      draw()
    end
    local tmp = it(17, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.color), "C")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.color = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2, what.height, "H")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.height = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x =tmp.text
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tmp.text
      draw()
      end
    end
    local tmp = bn(17,13,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17,12, #lc.falsee/divide+2+4, 1,cr1, cr2, cr1, cr2)
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
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.width)
    tt(3,8,cr2,lc.colorp)
    tt(3,9,cr2,lc.colors)
    tt(3,10,cr2,lc.colorv)
    tt(3,11,cr2,lc.value)
    tt(3,12,cr2,lc.visible)
    tt(3,13,cr2,lc.delete)
    tt(3,14,cr2,lc.up)
    tt(3,15,cr2,lc.down)
    local tmp = bn(17,14,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,15,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(17, 11, 20,1, cr1, cr2, cr3, cr1, cr2, what.value, "V")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.value = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorp), "P")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colors), "S")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colors = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 10, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorv), "V")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorv = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x =tmp.text
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tmp.text
      draw()
      end
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(17,13,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 12, #lc.falsee/divide+2+4, 1,cr1, cr2, cr1, cr2)
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
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.width)
    tt(3,8,cr2,lc.elh)
    tt(3,9,cr2,lc.colorbg)
    tt(3,10,cr2,lc.colort)
    tt(3,11,cr2,lc.colorabg)
    tt(3,12,cr2,lc.colorat)
    tt(3,13,cr2,lc.items)
    tt(3,14,cr2,lc.visible)
    tt(3,15,cr2,lc.delete)
    tt(3,16,cr2,lc.up)
    tt(3,17,cr2,lc.down)
    local tmp = bn(17,16,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,17,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,13, 4,1, cr1, cr2, cr1, cr2, lc.show)
    tmp.onTouch = function()
      choosed = what.items[1]
      local choose = win:addChild(GUI.filledWindow(1,1,45,12,cr1))
      local function update()
      local tmp1 = choose:addChild(GUI.comboBox(2,2,20,3,cr4,cr1,cr4,cr1))
	    	if lc.close == 'Закрыть' or lc.close == 'Закрити' then
	    			divide = 2
	    	else
  		  		divide = 1
	    	end
      local tmp = choose:addChild(GUI.input(2,6, 20,1, cr1, cr2, cr3, cr1, cr2,  choosed.name, "N")) 
      tmp.onInputFinished = function()
        choosed.name = tmp.text
        draw()
      end
      local tmp = choose:addChild(GUI.comboBox(2, 10, #lc.falsee/divide+2, 1,cr4, cr1, cr4, cr1))
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
      local tmp = choose:addChild(GUI.button(30,8,#lc.close/divide,1,cr1,cr2,cr1,cr2,lc.close))
      tmp.onTouch = function()
       choose:remove()
       draw()
      end
      local tmp = choose:addChild(GUI.input(2,8, 20, 1,cr1, cr2, cr3, cr1, cr2,  choosed.path, "P")) 
      tmp.onInputFinished = function()
        choosed.path = tmp.text
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
      local tmp = choose:addChild(GUI.button(30,2,#lc.add/divide,1,cr1,cr2,cr1,cr2,lc.add))
      tmp.onTouch = function()
        table.insert(what.items,{name='Item',path='',active=false})
        choosed = what.items[#what.items]
        update()
      end
      local tmp = choose:addChild(GUI.button(30,4,#lc.remove/divide,1,cr1,cr2,cr1,cr2,lc.remove))
      tmp.onTouch = function()
        for i = 1,#what.items do 
        if what.items[i] == choosed then
          table.remove(what.items,i)
        end end
        choosed = what.items[#what.items]
        update()
      end
    end  update() end
    local tmp = it(17, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorbg), "BG")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorbg = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 10, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colort), "T")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colort = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 11, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorabg), "ABG")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorabg = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 12, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorat), "AT")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorat = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2, what.elh, "ELH")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.elh = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x =tmp.text
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tmp.text
      draw()
      end
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(17,15,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 14, #lc.falsee/divide+2, 1,cr1, cr2, cr1, cr2)
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
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.width)
    tt(3,8,cr2,lc.colorp)
    tt(3,9,cr2,lc.colorpp)
    tt(3,10,cr2,lc.colorv)
    tt(3,11,cr2,lc.minv)
    tt(3,12,cr2,lc.maxv)
    tt(3,13,cr2,lc.value)
    tt(3,14,cr2,lc.path)
    tt(3,15,cr2,lc.visible)
    tt(3,16,cr2,lc.delete)
    tt(3,17,cr2,lc.up)
    tt(3,18,cr2,lc.down)
    local tmp = bn(17,17,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,18,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(17, 14, 20,1, cr1, cr2, cr3, cr1, cr2, what.path, "P")
    tmp.onInputFinished = function()
      what.path = tmp.text .. '.lua'
      draw()
    end
    local tmp = it(17, 11, 20,1, cr1, cr2, cr3, cr1, cr2, what.minv, "MINV")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.minv = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 12, 20,1, cr1, cr2, cr3, cr1, cr2, what.maxv, "MAXV")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.maxv = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 13, 20,1, cr1, cr2, cr3, cr1, cr2, what.value, "V")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.value = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorp), "P")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorpp), "PP")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorpp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 10, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorv), "V")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorv = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tmp.text
      draw()
      end
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(17,16,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 15, #lc.falsee/divide+2+4, 1,cr1, cr2, cr1, cr2)
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
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.colorpa)
    tt(3,8,cr2,lc.colorp)
    tt(3,9,cr2,lc.colors)
    tt(3,10,cr2,lc.visible)
    tt(3,11,cr2,lc.delete)
    tt(3,12,cr2,lc.up)
    tt(3,13,cr2,lc.down)
    local tmp = bn(17,12,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,13,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorpa), "PA")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorpa = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colorp), "P")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colorp = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.colors), "S")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.colors = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = bn(17,11,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 10, #lc.falsee/divide+2+4, 1,cr1, cr2, cr1, cr2)
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
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,'X')
    tt(3,6,cr2,'Y')
    tt(3,7,cr2,lc.width)
    tt(3,8,cr2,lc.heigth)
    tt(3,9,cr2,lc.color)
    tt(3,10,cr2,lc.visible)
    tt(3,11,cr2,lc.delete)
    tt(3,12,cr2,lc.up)
    tt(3,13,cr2,lc.down)
    local tmp = it(17, 9, 20,1, cr1, cr2, cr3, cr1, cr2,  hts(what.color), "S")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.color = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 7, 20,1, cr1, cr2, cr3, cr1, cr2, what.width, "W")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.width = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 8, 20,1, cr1, cr2, cr3, cr1, cr2, what.height, "H")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.height = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = bn(17,12,6,1,cr1,cr2,cr1,cr2,lc.up)
    tmp.onTouch = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(true,i,i-1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = bn(17,13,6,1,cr1,cr2,cr1,cr2,lc.down)
    tmp.onTouch  = function()
      for i = 1,#game.screen do
        if game.screen[i] == what then
          changePosition(false,i,i+1)
          draw()
          drawtree()
          break
        end
      end
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
    end
    local tmp = it(17, 5, 5, 1, cr1, cr2, cr3, cr1, cr2, what.x, "X")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.x = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = it(17, 6, 5, 1, cr1, cr2, cr3, cr1, cr2, what.y, "Y")
    tmp.onInputFinished = function()
    		if tmp.text ~= '' then
      what.y = tonumber(tmp.text)
      draw()
      end
    end
    local tmp = bn(17,11,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = del
    local tmp = bx(17, 10, 5, 1,cr1, cr2, cr1, cr2)
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
    tt(3,3,cr2,lc.type..': '..what.type)
    tt(3,4,cr2,lc.name)
    tt(3,5,cr2,lc.path)
    tt(3,6,cr2,lc.delete)
    local tmp = params:addChild(GUI.filesystemChooser(17, 5, 20, 1,cr1, cr2, cr1, cr2, nil, lc.open, lc.close, string.gsub(what.path,fs.extension(what.path) or '',''), "/"))
    tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
    tmp.onSubmit = function(path)
      what.path = path
      drawtree()
      drawparams(what)
      local tmp = find(game.screen.buffer,what.name)
      if tmp then
      		tmp.buffer.visible = false
      end
      draw()
    end
    local tmp = it(17, 4, 20,1, cr1, cr2, cr3, cr1, cr2, what.name, "N")
    tmp.onInputFinished = function()
      what.name = tmp.text
      drawtree()
      draw()
    end
    if fs.extension(what.path) == '.pic' then
    		local tmp = params:addChild(GUI.container(3,8,36,13))
    		tmp:addChild(GUI.panel(1,1,36,14,0x808080))
    		tmp:addChild(GUI.image(1,1,image.load(what.path)))
    end
    local tmp = bn(17,6,6,1,cr1,cr2,cr1,cr2,lc.delete)
    tmp.onTouch = function () for i = 1,#game.storage do if what == game.storage[i] then table.remove(game.storage,i) break end end draw() drawtree() drawparams(game.storage[1]) end
  else
    tt(1,1,cr2,lc.WYC)
  end
end
function objectmenu()
		if lc.close == 'Закрыть' or lc.close == 'Закрити' then
				divide = 2
		else
				divide = 1
		end
  choose = win:addChild(GUI.filledWindow(55,20,50,20,cr1))
  choose.actionButtons.close.onTouch = function() choose:remove() end
  if treemode == 'screen' then
  local tmp = choose:addChild(GUI.button(6,14,#lc.panel/divide,1,cr1,cr2,cr1,cr2,lc.panel))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'panel',x=userSettings.opengames.panelX or 1,y=userSettings.opengames.panelY or 1,color=userSettings.opengames.color or cr1,width = userSettings.opengames.panelWidth or 10,height=  userSettings.opengames.panelHeigth or 10,name = userSettings.opengames.panelName or 'Panel'})
  end
  local tmp = choose:addChild(GUI.button(6,4,#lc.text/divide,1,cr1,cr2,cr1,cr2,lc.text))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible =true,type = 'text',x=userSettings.opengames.textX or 1,y=userSettings.opengames.textY or 1,color=userSettings.opengames.textColor or cr2,text=userSettings.opengames.textText or 'Text',name = userSettings.opengames.textName or 'Text'})
  end
  local tmp = choose:addChild(GUI.button(25,6,#lc.progressBar/divide,1,cr1,cr2,cr1,cr2,lc.progressBar))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,width=userSettings.opengames.progressBarWidth or 20,colorp = userSettings.opengames.progressBarColorP or cr1,colors=userSettings.opengames.progressBarColorS or cr2,colorv=userSettings.opengames.progressBarColorV or cr2,type = 'progressBar',x=userSettings.opengames.progessBarX or 1,y=userSettings.opengames.progressBarY or 1,color= userSettings.opengames.progressBarColor or cr1,value=userSettings.opengames.progressBarValue or 50,name = userSettings.opengames.progressBarname or 'ProgressBar'})
  end
  local tmp = choose:addChild(GUI.button(25,8,#lc.comboBox/divide,1,cr1,cr2,cr1,cr2,lc.comboBox))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'comboBox',width=userSettings.opengames.comboBoxWidth or 20,x=userSettings.opengames.comboBoxX or 1,y=userSettings.opengames.comboBoxY or 1,elh=userSettings.opengames.comboBoxELH or 3,items={{name=userSettings.opengames.comboBoxItemsName or 'Item',active = false,type='itemComboBox',path=''}},colorbg=userSettings.opengames.comboBoxColorBG or cr1,colort=userSettings.opengames.comboBoxColorT or cr2,colorabg=userSettings.opengames.comboBoxColorABG or cr1,colorat=userSettings.opengames.comboBoxColorAT or cr2,name = userSettings.opengames.comboBoxName or 'ComboBox'})
  end
  local tmp = choose:addChild(GUI.button(7,18,#lc.slider/divide,1,cr1,cr2,cr1,cr2,lc.slider))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'slider',x=userSettings.opengames.sliderX or 1,y=userSettings.opengames.sliderY or 1,width=userSettings.opengames.sliderWidth or 20,colorp=userSettings.sliderColorP or cr1,colors=userSettings.opengames.sliderColorS or cr2,colorpp=userSettings.opengames.sliderColorPP or cr1,colorv=userSettings.opengames.sliderColorV or cr2,minv=userSettings.opengames.sliderMinv or 1,maxv=userSettings.opengames.sliderMaxv or 100,value=userSettings.opengames.sliderValue or 50,text=userSettings.opengames.sliderText or 'Slider',name = userSettings.opengames.sliderName or 'Slider'})
  end
  local tmp = choose:addChild(GUI.button(25,4,#lc.progressIndicator/divide,1,cr1,cr2,cr1,cr2,lc.progressIndicator))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,type = 'progressIndicator',x=userSettings.opengames.piX or 1,y=userSettings.opengames.piY or 1,active=userSettings.opengames.piActive or false,rollStage=userSettings.opengames.piRollStage or 1,colorp= userSettings.opengames.piColorP or cr1,colors=userSettings.opengames.piColorS or cr2,colorpa=userSettings.opengames.piColorPA or cr3,name = userSettings.opengames.piName or 'pI'})
  end
  local tmp = choose:addChild(GUI.button(7,16,#lc.collorSelector/divide,1,cr1,cr2,cr1,cr2,lc.collorSelector))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,path='',type = 'colorSelector',color=userSettings.opengames.csColor or 0xFF00FF,x=userSettings.opengames.csX or 1,y=userSettings.opengames.csY or 1,width=userSettings.opengames.csWidth or 20,height=userSettings.opengames.csHeight or 3,text=userSettings.opengames.csText or 'Color Selector',name = userSettings.opengames.csName or 'ColorSelector'})
  end
  local tmp = choose:addChild(GUI.button(6,10,#lc.input/divide,1,cr1,cr2,cr1,cr2,lc.input))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,onInputEnded = '',width=userSettings.opengames.inputWidth or 20,height=userSettings.opengames.inputHeight or 3,colorbg = userSettings.opengames.inputColorBG or cr1,colorfg = userSettings.opengames.inputColorFG or cr2,colorfgp = userSettings.opengames.inputColorFGP or cr1,colorbgp = userSettings.opengames.inputColorBGP or cr4,colorph=userSettings.opengames.inputColorPH or 0x2D2D2D,type = 'input',x=userSettings.opengames.inputX or 1,y=userSettings.opengames.inputY or 1,name = userSettings.opengames.inputName or 'Input',text = userSettings.opengames.inputText or 'Input',textph = userSettings.opengames.inputTextPH or 'Text'})
  end
  local tmp = choose:addChild(GUI.button(6,12,#lc.switch/divide,1,cr1,cr2,cr1,cr2,lc.switch))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{onStateChanged = userSettings.opengames.switchOnStateChanged or '', visible =userSettings.opengames.switchVisible or true,state=userSettings.opengames.switchState or false,type = 'switch',x=userSettings.opengames.switchX or 1,y=userSettings.opengames.switchY or 1,width=userSettings.switchWidth or 8,colorp= userSettings.opengames.switchColorP or cr2, colors=userSettings.opengames.switchColorS or cr2,colorpp=userSettings.opengames.switchColorPP or cr1,name = userSettings.opengames.switchName or 'Switch'})
  end
  local tmp = choose:addChild(GUI.button(6,8,#lc.image/divide,1,cr1,cr2,cr1,cr2,lc.image))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true, type = 'image',x=userSettings.opengames.imageX or 1,y=userSettings.opengames.imageY or 1,image=userSettings.opengames.imageImage or 'StorageEl',name = userSettings.opengames.imageName or 'image',path = userSettings.opengames.imagePath or 'Script'})
  end
  local tmp = choose:addChild(GUI.button(6,6,#lc.button/divide,1,cr1,cr2,cr1,cr2,lc.button))
  tmp.onTouch = function()
    choose:remove()
    new(game.screen,{visible = true,onTouch = userSettings.opengames.buttonOnTouch or '', height = userSettings.opengames.buttonHeight or 3,width = userSettings.opengames.buttonWidth or 20, animated = userSettings.opengames.buttonAnimated or true, disabled = userSettings.opengames.buttonDisabled or false, prevMode = userSettings.opengames.buttonsPrevMode or 'roundedButton', switchMode = userSettings.opengames.buttonSwitchMode or false, mode = userSettings.opengames.buttonMode or 'default', type = 'button',x= userSettings.opengames.buttonX or 1,y=userSettings.opengames.buttonY or 1,name = userSettings.opengames.buttonName or 'button',colorbg= userSettings.opengames.buttonColorBG or cr1,colorfg = userSettings.opengames.buttonColorFG or cr2,colorbgp = userSettings.opengames.buttonColorBGP or cr2,colorfgp= userSettings.opengames.buttonColorFGP or cr1,text=userSettings.opengames.buttonText or 'Button'})
  end
  elseif treemode == 'script' then
    local tmp = choose:addChild(GUI.button(6,4,#lc.script/divide,1,cr1,cr2,cr1,cr2,lc.script))
    tmp.onTouch = function()
      choose:remove()
      fs.write('/Temporary/'..tostring(#game.scripts+1)..'.lua',lc.DFtS)
      new(game.scripts,{autoload = userSettings.opengames.scriptAutoload or false,path = '/Temporary/'..tostring(#game.scripts+1)..'.lua',name = userSettings.opengames.scriptName or 'script',type = 'script'})
    end
    local tmp = choose:addChild(GUI.filesystemChooser(5, 6, 10, 1, cr1, cr2, cr1, cr2, nil, lc.open, lc.close, lc.choose, "/"))
    tmp.onSubmit = function(path)
    		if fs.extension(path) == '' or fs.extension(path) == '.lua' then
     		 choose:remove()
       	new(game.scripts,{autoload = userSettings.opengames.scriptAutoload or false,path = path,name = userSettings.opengames.scriptName or 'Script',type = 'script'})
      end
    end
  elseif treemode == 'storage' then
local tmp = choose:addChild(GUI.filesystemChooser(6, 4, #lc.path/divide+3, 1, cr1, cr2, cr1, cr2, nil, lc.open, lc.close, lc.path, "/"))
tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
tmp.onSubmit = function(path)
choose:remove()
    new(game.storage,{path = path,name = userSettings.opengames.storageName or 'StorageEl',type = 'file'})
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
  obj:addChild(GUI.panel(1,1,36,20,cr1))
		if lc.close == 'Закрыть' or lc.close == 'Закрити' then
				divide = 2
		else
				divide = 1
		end
		local elements = obj:addChild(GUI.container(4,4,33,17))
		local modesButtons = obj:addChild(GUI.container(1,1,36,20))
		local bg = modesButtons:addChild(GUI.panel(1,1,36,3,cr1))
  local screenmode = modesButtons:addChild(GUI.button(3,2,#lc.screen/divide,1,cr1,cr2,cr1,cr2,lc.screen))
  screenmode.onTouch = function()
    treemode = 'screen'
    drawparams(game.screen[1])
    drawtree()
  end
  local storagemode = modesButtons:addChild(GUI.button(5+#lc.screen/divide+#lc.scripts/divide,2,#lc.storage/divide,1,cr1,cr2,cr1,cr2,lc.storage))
  storagemode.onTouch = function()
    treemode = 'storage'
    drawparams(game.storage[1])
    drawtree()
  end
  local scriptmode = modesButtons:addChild(GUI.button(4+#lc.screen/divide,2,#lc.scripts/divide,1,cr1,cr2,cr1,cr2,lc.scripts))
  scriptmode.onTouch = function()
    treemode = 'script'
    drawparams(game.scripts[1])
    drawtree()
  end
  if treemode == 'screen' then
    local tmp = modesButtons:addChild(GUI.button(3,3,#lc.screen/divide,1,cr1,cr2,cr1,cr2,lc.screen))
    tmp.onTouch = function()
       drawparams(game.window)
    end
    local addScreen = modesButtons:addChild(GUI.button(#lc.screen/divide+4,3,1,1,cr1,cr2,cr1,cr2,'+'))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 1
    for i = 1,#game.screen do
      tmp = elements:addChild(GUI.button(1,y,#game.screen[i].name,1,cr1,cr2,cr1,cr2, game.screen[i].name))
      tmp.onTouch = function()
        drawparams(game.screen[i])
      end
      y = y + 1
    end
  elseif treemode == 'script' then
   modesButtons:addChild(GUI.text(3,3,cr2,lc.scripts))
   local addScreen = modesButtons:addChild(GUI.button(#lc.scripts/divide+4,3,1,1,cr1,cr2,cr1,cr2,'+'))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 1
    for i = 1,#game.scripts do
      tmp = elements:addChild(GUI.button(1,y,#game.scripts[i].name,1,cr1,cr2,cr1,cr2, game.scripts[i].name))
      tmp.onTouch = function()
        drawparams(game.scripts[i])
      end
      y = y + 1
    end
  elseif treemode == 'storage' then
   modesButtons:addChild(GUI.text(3,3,cr2,lc.storage))
   local addScreen = modesButtons:addChild(GUI.button(#lc.storage/divide+4,3,1,1,cr1,cr2,cr1,cr2,'+'))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 1
    for i = 1,#game.storage do
      tmp = elements:addChild(GUI.button(1,y,#game.storage[i].name,1,cr1,cr2,cr1,cr2, game.storage[i].name))
      tmp.onTouch = function()
        drawparams(game.storage[i])
      end
      y = y + 1
    end
  end
end
local function save(path)
		gamepath = path
  fs.makeDirectory('/Temporary/ProjectSave')
  local idk = {}
		  local tmpgame = table.copy(game)
		  for i = 1,#tmpgame.screen do
		  		tmpgame.screen[i].raw = nil
		  		tmpgame.screen.buffer[i].raw = nil
		  		tmpgame.screen.buffer[i].visible = false
		  end
    fs.writeTable('/Temporary/ProjectSave/Game.dat',tmpgame)
		  tmpgame = nil
  for i = 1,#game.storage do
  		table.insert(idk,'/Temporary/ProjectSave/' ..fs.name(game.storage[i].path))
    fs.copy(game.storage[i].path,'/Temporary/ProjectSave/' ..fs.name(game.storage[i].path))
  end
  for i = 1,#game.scripts do
  		table.insert(idk,'/Temporary/ProjectSave/' ..fs.name(game.scripts[i].path))
    fs.copy(game.scripts[i].path,'/Temporary/ProjectSave/'..fs.name(game.scripts[i].path))
  end
  compressor.pack(path..'.pkg',idk)
end
local function saveAsWindow ()
		local tmp = GUI.addFilesystemDialog(wk,true,50, 30, lc.save,lc.cancel,lc.name,'/')
	 tmp:setMode(GUI.IO_MODE_SAVE, GUI.IO_MODE_FILE)
		tmp.onSubmit = function(path)
		  if fs.exists(path..'.pkg') then 
		  		local winerr = win:addChild(GUI.container(60,20,60,5))
			  	if lc.close == 'Закрыть' or lc.close == 'Закрити' then
				  		divide = 2
			  	else
				  		divide = 1
			  	end
		  		winerr:addChild(GUI.panel(1,1,#lc.YNEF,5,0xAAAAAA))
		  		winerr:addChild(GUI.text(2,2,cr1,lc.YNEF))
		  		winerr:addChild(GUI.button(2,4,2+#lc.save/divide,1,cr1,cr2,cr1,cr2,lc.save)).onTouch = function()
		 				 save(path)
		 				 winerr:remove()
		    end
		  		winerr:addChild(GUI.button(4+#lc.YNEF/divide-#lc.cancel/divide-3,4,#lc.cancel/divide+3,1,cr1,cr2,cr1,cr2,lc.close)).onTouch = function()
		 				  winerr:remove()
		 				  return 
		 				  end
		  else
		  		save(path)
		  end
		  draw()
		  drawtree()
		end
	tmp:show()
end
local function new()
		treemode = 'screen'
		for i = 1,#game.screen do
				game.screen[i].raw:remove()
		end
		game = {scripts = {},window = {abn = userSettings.opengames.windowABN or true,type = 'window',width=userSettings.opengames.windowWidth or 80,heigth= userSettings.opengames.windowHeight or 40,title = userSettings.opengames.windowTitle or 'Title',color = userSettings.opengames.windowColor or cr4,titleColor = userSettings.opengames.windowTitleColor or cr2},screen = {},storage={}}
		draw()
		drawtree()
		drawparams()
end
local function saveOrPass(onEnd,arg1)
		 	if lc.close == 'Закрыть' or lc.close == 'Закрити' then
		  		divide = 2
		 	else
		  		divide = 1
		 	end
				local winerr = win:addChild(GUI.container(60,20,#lc.saveToPath/divide+5+4+#lc.close/divide+3+4+#lc.save/divide+2+#lc.withoutSave/divide+4,5))
				winerr:addChild(GUI.panel(1,1,#lc.saveToPath/divide+5+4+#lc.close/divide+3+4+#lc.save/divide+2+#lc.withoutSave/divide+4,5,0xAAAAAA))
				winerr:addChild(GUI.text(2,2,cr1,lc.NF))
				winerr:addChild(GUI.button(2,4,#lc.saveToPath/divide+5,1,cr1,cr2,cr1,cr2,lc.saveToPath)).onTouch = function()
					 saveAsWindow()
					 winerr:remove()
					 onEnd(arg1)
		  end
		  if gamepath ~= '' then
						winerr:addChild(GUI.button(#lc.saveToPath/divide+5+4,4,2+#lc.save/divide,1,cr1,cr2,cr1,cr2,lc.save)).onTouch = function()
							 save(gamepath)
							 winerr:remove()
							 onEnd(arg1)
				  end
		  end
				winerr:addChild(GUI.button(#lc.saveToPath/divide+5+4+#lc.save/divide+4,4,#lc.close/divide+3,1,cr1,cr2,cr1,cr2,lc.close)).onTouch = function()
				  winerr:remove()
		  end
				winerr:addChild(GUI.button(#lc.saveToPath/divide+5+4+#lc.close/divide+3+4+#lc.save/divide+2,4,#lc.withoutSave/divide+5,1,cr1,cr2,cr1,cr2,lc.withoutSave)).onTouch = function()
				  winerr:remove()
				  onEnd(arg1)
		  end
end
local contextMenu = menu:addContextMenuItem(lc.file)
contextMenu:addItem(lc.new,false).onTouch = function()
		if game.screen[1] == nil and game.storage[1] == nil and game.scripts[1] == nil then
				new()
		else
				saveOrPass(new)
		end
end
contextMenu:addSeparator()
contextMenu:addItem(lc.save,false).onTouch = saveAsWindow
local function open(path)
				gamepath = path
		  compressor.unpack(path,'/Temporary/')
		  path = '/Temporary/ProjectSave/'
		  if not fs.exists(path..'/Game.dat') then GUI.alert(lc.UFP) return end
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
		  for i = 1, #game.screen do
		  		if game.screen[i].type == 'button' then
		  				if not game.screen[i].animated then game.screen[i].animated = userSettings.buttonAnimated or true end
		  				if not game.screen[i].disable then game.screen[i].disable = userSettings.buttonDisable or false end
		  				if not game.screen[i].switchMode then game.screen[i].switchMode = userSettings.buttonSwitchMode or false end
		  				if not game.screen[i].mode then game.screen[i].mode = userSettings.buttonMode or 'default' end
		  				if not game.screen[i].prevMode then game.screen[i].prevMode = userSettings.buttonPrevMode or 'roundedButton' end
		  		end
		  end
		  OE = nil
		  local OE = require('opengames')
		  for i = 1,#game.screen.buffer do
		  		game.screen.buffer[i].visible = false
		  end
		  OE.init({editor = true,game = game,container = screen})
		  draw()
		  drawtree()
end
contextMenu:addItem(lc.open,false).onTouch = function()
		local tmp = GUI.addFilesystemDialog(wk,true,50, 30, lc.open,lc.cancel,lc.name,'/')
		tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
		tmp.onSubmit = function(path)
				saveOrPass(open,path)
		end
	tmp:show()
end
contextMenu:addSeparator()
contextMenu:addItem(lc.export,false).onTouch = function()
				local tmp = GUI.addFilesystemDialog(wk,true,50, 30, lc.export,lc.cancel,lc.name,'/')
		tmp:setMode(GUI.IO_MODE_SAVE, GUI.IO_MODE_FILE)
		local function export(path)
		  local towrite = ''
		  towrite = towrite .. 'local image = require("Image")\nlocal fs = require("filesystem")\nlocal event = require("event")\nlocal GUI = require("GUI")\nlocal system = require("System")\nlocal OE = require("opengames")\nlocal gamepath = string.gsub(system.getCurrentScript(),"/Main.lua","")\ngame = fs.readTable(gamepath.."/Game.dat")\ngame.localization=system.getCurrentScriptLocalization()\nlocal wk,win,menu = system.addWindow(GUI.filledWindow(1,1,game.window.width,game.window.height,0x989898))\nwin:removeChildren()\nlocal BG = win:addChild(GUI.panel(1,1,game.window.width,game.window.height,game.window.color)) \nlocal TITLE = win:addChild(GUI.text(math.floor(game.window.width/2-#game.window.title/2),1,game.window.titleColor,game.window.title))\nOE.init({gamePath = gamepath, editor = false,game = game, container = win})\n'
		  fs.makeDirectory(path..'.app/Scripts')
		  fs.makeDirectory(path..'.app/Assets')
		  fs.makeDirectory(path..'.app/Localizations')
		  for i = 1,#game.storage do
		    if fs.extension(game.storage[i].path) == '.lang' then 
		      fs.copy(game.storage[i].path,path..'.app/Localizations/'..fs.name(game.storage[i].path)) 
		    else
		      fs.copy(game.storage[i].path,path..'.app/Assets/'..fs.name(game.storage[i].path))
		    end
		  end
		  for i = 1,#game.scripts do
		    fs.copy(game.scripts[i].path,path..'.app/Scripts/'..game.scripts[i].name..'.lua')
		  end
		  for i = 1, #game.storage do
		    if fs.extension(game.storage[i].path) == '.lang' then 
		   		 game.storage[i].path = path..'.app/Localizations/'..fs.name(game.storage[i].path)
		    else
		   		 game.storage[i].path = path..'.app/Assets/'..fs.name(game.storage[i].path)
		    end
		  end
		  for i = 1, #game.scripts do
		    game.scripts[i].path = path..'.app/Scripts/'..game.scripts[i].name..'.lua'
		  end
		  idk = nil
		  for e = 1,#game.storage do
		    if game.storage[e].name == 'Icon' and fs.extension(game.storage[e].path) == '.pic' then
		      idk = game.storage[e].path
		    end
		  end
		  if idk == nil then idk = '/Icons/Application.pic' end
		  local tmpgame = table.copy(game)
		  for i = 1,#tmpgame.screen do
		  		tmpgame.screen[i].raw = nil
		  		tmpgame.screen.buffer[i].raw = nil
		  		tmpgame.screen.buffer[i].visible = false
		  end
		  towrite = towrite .. 'draw()\n for i = 1,#game.scripts do\n if game.scripts[i].autoload == true then\n system.execute(game.scripts[i].path)\n end\n end\n'
		  fs.write(path..'.app/Main.lua',towrite)
		  fs.writeTable(path..'.app/Game.dat',tmpgame)
		  fs.copy(idk,path..'.app/Icon.pic')
		  tmpgame = nil
		end
		tmp.onSubmit = function(path)
		  if fs.exists(path..'.app') then
		  		local winerr = win:addChild(GUI.container(60,20,50,5))
			  	if lc.close == 'Закрыть' or lc.close == 'Закрити' then
			  			divide = 2
				  else
				  		divide = 1
			  	end
		  		winerr:addChild(GUI.panel(1,1,4+#lc.EF,5,0xAAAAAA))
		  		winerr:addChild(GUI.text(2,2,cr1,lc.EF))
		  		winerr:addChild(GUI.button(2,4,#lc.export/divide+2,1,cr1,cr2,cr1,cr2,lc.export)).onTouch = function()
		 				 export(path)
		 				 winerr:remove()
		    end
		  		winerr:addChild(GUI.button(4+#lc.EF/divide-#lc.cancel/divide-3,4,#lc.cancel/divide+3,1,cr1,cr2,cr1,cr2,lc.close)).onTouch = function()
		 				  winerr:remove()
		 				  return 
		 				  end
		  else
		    fs.makeDirectory(path..'.app')
		  		export(path)
		  end
		end
	tmp:show()
end
local usualParams = menu:addContextMenuItem(lc.sampleParams)
local function colorItem(localization,param,tmp)
		tmp:addItem(localization).onTouch = function()
			  local container = GUI.addBackgroundContainer(wk, true, true)
			  if userSettings.opengames[param] == nil then userSettings.opengames[param] = cr1 end
			  local tmpp = container.layout:addChild(GUI.colorSelector(1, 1, 30, 3, userSettings.opengames[param] or cr1, hts(userSettings.opengames[param]) or hts(cr1)))
			  tmpp.onColorSelected = function()
			    userSettings.opengames[param] = tonumber(tmpp.color)
					 	system.saveUserSettings()
			  end
			end
end
local function standartItem(localization,param,tmp)
		tmp:addItem(localization).onTouch = function()
			  local container = GUI.addBackgroundContainer(wk, true, true)
			  local tmpp = container.layout:addChild(GUI.input(1,1,30,3,cr1,cr2,cr3,cr1,cr2,tostring(userSettings.opengames[param])))
			  tmpp.onInputFinished = function()
			   userSettings.opengames[param] = tmpp.text
						system.saveUserSettings()
			  end
		end
end
local function numberItem(localization,param,tmp)
		tmp:addItem(localization).onTouch = function()
			  local container = GUI.addBackgroundContainer(wk, true, true)
			  local tmpp = container.layout:addChild(GUI.input(1,1,30,3,cr1,cr2,cr3,cr1,cr2,tostring(userSettings.opengames[param])))
			  tmpp.onInputFinished = function()
			   userSettings.opengames[param] = tonumber(tmpp.text)
						system.saveUserSettings()
			  end
			end
end
local function chooseItem(localization,param,tmp)
		tmp:addItem(localization).onTouch = function()
			  local container = GUI.addBackgroundContainer(wk, true, true)
    local tmp = container.layout:addChild(GUI.comboBox(1, 1, #lc.falsee/divide+2+4, 1, cr1, cr2, cr1, cr2))
    if userSettings.opengames[param] == nil then userSettings.opengames[param] = true end
    if userSettings.opengames[param] == true then
      tmp:addItem(lc.truee).onTouch = function()
        userSettings.opengames[param] = true
						system.saveUserSettings()
      end
      tmp:addItem(lc.falsee).onTouch = function()
        userSettings.opengames[param] = false
						system.saveUserSettings()
      end
    else
      tmp:addItem(lc.falsee).onTouch = function()
        userSettings.opengames[param] = false
						system.saveUserSettings()
      end
     tmp:addItem(lc.truee).onTouch = function()
        userSettings.opengames[param] = true
						system.saveUserSettings()
      end
    end
		end
end
local function sampleParams()
		local tmp = usualParams:addSubMenuItem(lc.overall)
		colorItem(lc.cr1,'cr1',tmp)
		colorItem(lc.cr2,'cr2',tmp)
		colorItem(lc.cr3,'cr3',tmp)
		colorItem(lc.cr4,'cr4',tmp)
		colorItem(lc.windowColor,'windowColor',tmp)
		colorItem(lc.windowTitleColor,'windowTitleColor',tmp)
		standartItem(lc.windowTitle,'windowTitle',tmp)
		numberItem(lc.windowWidth,'windowWidth',tmp)
		numberItem(lc.windowHeight,'windowHeight',tmp)
		chooseItem(lc.windowABN,'windowABN',tmp)
		tmp:addItem(lc.reset).onTouch = function()
				userSettings.opengames = nil
				system.saveUserSettings()
				userSettings.opengames = {}
				system.saveUserSettings()
		end
		local tmp = usualParams:addSubMenuItem(lc.text)
		numberItem('X','textX',tmp)
		numberItem('Y','textY',tmp)
		standartItem(lc.name,'textName',tmp)
		colorItem(lc.color,'textColor',tmp)
		standartItem(lc.text,'textText',tmp)
		local tmp = usualParams:addSubMenuItem(lc.button)
		standartItem(lc.name,'buttonName',tmp)
		numberItem('X','buttonX',tmp)
		numberItem('Y','buttonY',tmp)
		numberItem(lc.width,'buttonWidth',tmp)
		numberItem(lc.heigth,'buttonHeight',tmp)
		standartItem(lc.onTouch,'buttonOnTouch',tmp)
		standartItem(lc.text,'buttonText',tmp)
		colorItem(lc.colorbg,'buttonColorBG',tmp)
		colorItem(lc.colorfg,'buttonColorFG',tmp)
		colorItem(lc.colorbgp,'buttonColorBGP',tmp)
		colorItem(lc.colorfgp,'buttonColorFGP',tmp)
		chooseItem(lc.animated,'buttonAnimated',tmp)
		chooseItem(lc.disabled,'buttonDisabled',tmp)
		chooseItem(lc.switch,'buttonSwitchMode',tmp)
		tmp:addItem(lc.mode).onTouch = function()
			 local container = GUI.addBackgroundContainer(wk, true, true)
    local tmp = container.layout:addChild(GUI.comboBox(17, 15, 15, 1, cr1, cr2, cr1, cr2))
    if userSettings.opengames.buttonMode == nil then userSettings.opengames.buttonMode = 'default' end
    if userSettings.opengames.buttonPrevMode == nil then userSettings.opengames.buttonPrevMode = 'roundedButton' end
    what = userSettings.opengames
    if what.buttonMode== 'default' then
    		tmp:addItem(lc.default).onTouch = function()
    		  what.buttonMode = 'default'
						system.saveUserSettings()
    		end
    		if what.buttonPrevMode == 'framedButton' then
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'framedButton'
						system.saveUserSettings()
    		end
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'roundedButton'
						system.saveUserSettings()
    		end
    		else
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'roundedButton'
						system.saveUserSettings()
    		end
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'framedButton'
						system.saveUserSettings()
    		end
    		end
    elseif what.buttonMode == 'framedButton' then
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.buttonMode = 'framedButton'
						system.saveUserSettings()
    		end
    		if what.buttonPrevMode == 'default' then
    		tmp:addItem(lc.default).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'default'
						system.saveUserSettings()
    		end
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'roundedButton'
						system.saveUserSettings()
    		end
    	else
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'roundedButton'
						system.saveUserSettings()
    		end
    		tmp:addItem(lc.default).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'default'
						system.saveUserSettings()
    		end
    		end
    elseif what.buttonMode == 'roundedButton' then
    		tmp:addItem(lc.roundedButton).onTouch = function()
    		  what.buttonMode = 'roundedButton'
						system.saveUserSettings()
    		end
    		if what.buttonPrevMode == 'default' then
    		tmp:addItem(lc.default).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'default'
						system.saveUserSettings()
    		end
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'framedButton'
						system.saveUserSettings()
    		end
     else
    		tmp:addItem(lc.framedButton).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'framedButton'
						system.saveUserSettings()
    		end
    		tmp:addItem(lc.default).onTouch = function()
    		  what.buttonPrevMode = what.buttonMode
    		  what.buttonMode = 'default'
						system.saveUserSettings()
    		end
    		end
    end
		end
		local tmp = usualParams:addSubMenuItem(lc.image)
		standartItem(lc.name,'imageName',tmp)
		numberItem('X','imageX',tmp)
		numberItem('Y','imageY',tmp)
		standartItem(lc.image,'imageImage',tmp)
		local tmp = usualParams:addSubMenuItem(lc.input)
		standartItem(lc.name,'inputName',tmp)
		numberItem('X','inputX',tmp)
		numberItem('Y','inputY',tmp)
		numberItem(lc.width,'inputWidth',tmp)
		numberItem(lc.heigth,'inputHeight',tmp)
		colorItem(lc.colorbg,'inputColorBG',tmp)
		colorItem(lc.colorfg,'inputColorFG',tmp)
		colorItem(lc.colorph,'inputColorPH',tmp)
		colorItem(lc.colorbgp,'inputColorBGP',tmp)
		colorItem(lc.colorfgp,'inputColorFGP',tmp)
		standartItem(lc.text,'inputText',tmp)
		standartItem(lc.ph,'inputTextPH',tmp)
		local tmp = usualParams:addSubMenuItem(lc.switch)
		standartItem(lc.name,'switchName',tmp)
		numberItem('X','switchX',tmp)
		numberItem('Y','switchY',tmp)
		numberItem(lc.width,'switchWidth',tmp)
		chooseItem(lc.state,'switchState',tmp)
		colorItem(lc.colorp,'switchColorP',tmp)
		colorItem(lc.colors,'switchColorS',tmp)
		colorItem(lc.colort,'switchColorT',tmp)
		local tmp = usualParams:addSubMenuItem(lc.panel)
		standartItem(lc.name,'panelName',tmp)
		numberItem('X','panelX',tmp)
		numberItem('Y','panelY',tmp)
		numberItem(lc.width,'panelWidth',tmp)
		numberItem(lc.heigth,'panelHeight',tmp)
		colorItem(lc.color,'panelColor',tmp)
		local tmp = usualParams:addSubMenuItem(lc.collorSelector)
		standartItem(lc.name,'csName',tmp)
		numberItem('X','csX',tmp)
		numberItem('Y','csY',tmp)
		numberItem(lc.width,'csWidth',tmp)
		numberItem(lc.heigth,'csHeight',tmp)
		colorItem(lc.color,'csColor',tmp)
		standartItem(lc.text,'scText',tmp)
		local tmp = usualParams:addSubMenuItem(lc.slider)
		standartItem(lc.name,'sliderName',tmp)
		numberItem('X','sliderX',tmp)
		numberItem('Y','sliderY',tmp)
		numberItem(lc.width,'sliderWidth',tmp)
		colorItem(lc.colorp,'sliderColorP',tmp)
		colorItem(lc.colorpp,'sliderColorPP',tmp)
		colorItem(lc.colorv,'sliderColorV',tmp)
		numberItem(lc.minv,'sliderMinV',tmp)
		numberItem(lc.maxv,'sliderMaxV',tmp)
		numberItem(lc.value,'sliderValue',tmp)
		local tmp = usualParams:addSubMenuItem(lc.progressIndicator)
		standartItem(lc.name,'piName',tmp)
		numberItem('X','piX',tmp)
		numberItem('Y','piY',tmp)
		colorItem(lc.colorp,'piColorP',tmp)
		colorItem(lc.colorpa,'piColorPA',tmp)
		colorItem(lc.colorv,'piColorV',tmp)
		local tmp = usualParams:addSubMenuItem(lc.progressBar)
		standartItem(lc.name,'progressBarName',tmp)
		numberItem('X','progressBarX',tmp)
		numberItem('Y','progressBarY',tmp)
		numberItem(lc.width,'progressBarWidth',tmp)
		colorItem(lc.colorp,'progressBarColorP',tmp)
		colorItem(lc.colors,'progressBarColorS',tmp)
		colorItem(lc.colorv,'progressBarColorV',tmp)
		numberItem(lc.value,'progressBarValue',tmp)
		local tmp = usualParams:addSubMenuItem(lc.comboBox)
		standartItem(lc.name,'comboBoxName',tmp)
		numberItem('X','comboBoxX',tmp)
		numberItem('Y','comboBoxY',tmp)
		numberItem(lc.width,'comboBoxWidth',tmp)
		numberItem(lc.elh,'comboBoxELH',tmp)
		colorItem(lc.colort,'comboBoxColorT',tmp)
		colorItem(lc.colorat,'comboBoxColorAT',tmp)
		colorItem(lc.colorabg,'comboBoxColorABG',tmp)
		colorItem(lc.colorbg,'comboBoxColorBG',tmp)
		local tmp = usualParams:addSubMenuItem(lc.script)
		standartItem(lc.name,'scriptName',tmp)
		chooseItem(lc.autoload,'scriptAutoload',tmp)
		local tmp = usualParams:addSubMenuItem(lc.storage)
		standartItem(lc.name,'storageName',tmp)
end
sampleParams()
draw()
drawtree()
drawparams()
 
