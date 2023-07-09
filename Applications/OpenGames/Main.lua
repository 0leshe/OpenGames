local GUI = require('GUI')
local paths = require('Paths')
local system = require('System')
local event = require('Event')
local image = require('Image')
local uni = require('Unicode')
local fs = require('Filesystem')
local compressor = require('Compressor')
local editorPath = string.gsub(system.getCurrentScript(),"/Main.lua","")
local lc = system.getCurrentScriptLocalization()
local userSettings = system.getUserSettings()
local wk,win,menu = system.addWindow(GUI.filledWindow(0,0,160,50,0x8E8E8E))
lc.x = 'X'
lc.y = 'Y'
local what
local paramsPath = editorPath..'/OpenGames_Editor_Data/Edit_Params/'
if not userSettings.opengames then
		userSettings.opengames = {}
		system.saveUserSettings()
end
local OE = require('opengames')
local gamepath = '/Autosave'
local cr1, cr2,cr3,cr4 = userSettings.opengames.cr1 or 0x989898, userSettings.opengames.cr2 or 0x505050,userSettings.opengames.cr3 or 0x000000,userSettings.opengames.cr4 or 0x757575
local treemode = 'screen'
local scenes = {{name='MainMenu',game = {scripts = {},window = {abn = userSettings.opengames.windowABN or true,type = 'window',width=userSettings.opengames.windowWidth or 80,height= userSettings.opengames.windowHeight or 40, title = userSettings.opengames.windowTitle or 'Title',buffer={},color = userSettings.opengames.windowColor or cr4,titleColor = userSettings.opengames.windowTitleColor or cr2},screen = {buffer = {}},storage={buffer={}}}}}
local game = OE.find(scenes,'MainMenu').game
		if require'imageAtlas' then
		  imageAtlas = require'imageAtlas'
		  isImageAtlas = true
		end
local function Wlen(...)
  return uni.len(...)
end
local function whereFunction(where)
  for i = 1,#where do
    if type(where[i]) == 'function' then
      print('yes yes yes')
    elseif type(where[i]) == 'table' then
      whereFunction(where)
    end
  end
end
local title = win:addChild(GUI.text(1,1,cr2,'Editor 1.6'))
local screen = win:addChild(GUI.container(2,3,160,50))
local params = win:addChild(GUI.filledWindow(102,24,40,23,cr1))
local obj = win:addChild(GUI.filledWindow(102,2,36,20,cr1))
local BG = screen:addChild(GUI.panel(1,1,game.window.width,game.window.height,game.window.color))
local TITLE = screen:addChild(GUI.text(math.floor(game.window.width/2-#game.window.title/2),1,game.window.titleColor,game.window.title)) 
OE.init({allScenes = scenes, wk = wk, imageAtlas = isImageAtlas, editor = true,bg=BG,title=TITLE,container = screen,startScene = 'MainMenu'})
game = OE.game
OE.gamepath = gamepath

local function changePosition(obj,fromposition,toposition)

end

function hts(...) -- HEX to string
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
  OE.Instance.remove(what)
	drawtree() 
	drawparams(game.screen[1])
end
local function endOfParams(lastIndex, objectType)
  local tmp01 = tt(3,lastIndex,cr2,lc.delete)
  local count = 1
  local tmp = bn(17,lastIndex,#lc.delete/divide,1,cr1,cr2,cr1,cr2,lc.delete)
  if objectType == 'script' then
   tmp.onTouch = function() for i = 1,#game.scripts do if what == game.scripts[i] then table.remove(game.scripts,i) break end end OE.draw() drawtree() drawparams(game.scripts[1]) end
  elseif objectType == 'window' then
    tmp:remove()
    tmp01:remove()
  elseif objectType == 'file' then
    tmp.onTouch = function () for i = 1,#game.storage do if what == game.storage[i] then table.remove(game.storage,i) break end end OE.draw() drawtree() drawparams(game.storage[1]) end
  else
   count = 5
   tmp.onTouch = del
  tt(3,lastIndex,cr2,lc.visible)
  local tmp = bx(17, lastIndex, #lc.falsee/divide, 1, cr1, cr2, cr1, cr2)
  if what.visible == true then
    tmp:addItem(lc.truee).onTouch = function()
      what.visible = true
      OE.draw()
    end
    tmp:addItem(lc.falsee).onTouch = function()
      what.visible = false
      OE.draw()
    end
  else
    tmp:addItem(lc.falsee).onTouch = function()
      what.visible = false
      OE.draw()
    end
   tmp:addItem(lc.truee).onTouch = function()
      what.visible = true
      OE.draw()
    end
  end
  tt(3,lastIndex,cr2,lc.up)
  tt(3,lastIndex,cr2,lc.down)
  local tmp = bn(17,lastIndex,#lc.up/divide,1,cr1,cr2,cr1,cr2,lc.up)
  tmp.onTouch = function()
    for i = 1,#game.screen do
      if game.screen[i] == what then
        changePosition(true,i,i-1)
        OE.draw()
        drawtree()
        break
      end
    end
  end
  local tmp = bn(17,lastIndex,#lc.down/divide,1,cr1,cr2,cr1,cr2,lc.down)
  tmp.onTouch  = function()
    for i = 1,#game.screen do
      if game.screen[i] == what then
        changePosition(false,i,i)
        OE.draw()
        drawtree()
        break
      end
    end
  end
  end
  return count+lastIndex
end
function drawParamsInParams(objectType, useEnd)
  if not fs.exists(paramsPath..objectType..'.cfg') then
   return GUI.alert('Cant find file of object parameters: '..string.upper(objectType))
  end
  local paramsTable = fs.readTable(paramsPath..objectType..'.cfg')
  local e
  local indexOfParam = 3
  if paramsTable == nil then
    GUI.alert('What bro choose ð£ð£')
    return
  end
  for i = 1, #paramsTable do
   if paramsTable[i].type == 'comboBox' and type(what[paramsTable[i].param]) == 'boolean' then
    local color
    if what[paramsTable[i].param] then
      color = 0x00FF40
    else
      color = 0xFF0000
    end
    params:addChild(GUI.panel(38,indexOfParam,1,1,color))
    tt(3,indexOfParam,cr2,lc[paramsTable[i].param])
   else
   tt(3,indexOfParam,cr2,lc[paramsTable[i].param])
    end
   if paramsTable[i].type == 'input' then
     local tmp = it(17, indexOfParam, 20, 1, cr1, cr2, cr3, cr1, cr2, what[paramsTable[i].param], string.upper(paramsTable[i].param))
     tmp.onInputFinished = function()
   		if tmp.text ~= '' then
   		 local value
   		 if paramsTable[i].data == 'int' then
   		   value = tonumber(tmp.text)
   		 else
   		   value = tmp.text
   		 end
      	what[paramsTable[i].param] = value
      	OE.draw()
    	end
     end
   elseif paramsTable[i].type == 'colorInput' or  paramsTable[i].type == 'inputColor' then
     local tmp = params:addChild(GUI.colorSelector(17, indexOfParam, 20, 1, what[paramsTable[i].param], hts(what[paramsTable[i].param])))
    tmp.onColorSelected = function()
      	what[paramsTable[i].param] = tmp.color
        tmp.text = hts(tmp.color)
      	OE.draw()
   		end
    elseif paramsTable[i].type == 'inputFile' then
    local tmp = params:addChild(GUI.filesystemChooser(17, indexOfParam, 20, 1, cr1, cr2, cr1, cr2, nil, lc.open, lc.close, lc.choose, '/'))
    tmp.onSubmit = function(path)
      what[paramsTable[i].param] = path
      if paramsTable[i].callBack then
        paramsTable[i].callBack(what,OE,lc,path)
      end
      drawtree()
      OE.draw()
      drawparams(what)
    end
    elseif paramsTable[i].type == 'button' then
    local towrite
    if type(what[paramsTable[i].param]) == 'string' and not paramsTable[i].loc then
      towrite = what[paramsTable[i].param]
    else
      towrite = lc[paramsTable[i].param]
    end
    if paramsTable[i].loc then
      towrite = lc[paramsTable[i].loc]
    end
    local tmp = params:addChild(GUI.button(17,indexOfParam,Wlen(towrite),1,cr1,cr2,cr2,cr1,towrite))
    tmp.onTouch = function(_,object)
      paramsTable[i].callBack(what,OE,lc,object)
    end
   elseif paramsTable[i].type == 'comboBox' then
    local tmp = bx(17, indexOfParam, 15, 1, cr1, cr2, cr1, cr2)
    if paramsTable[i].vars then
      for e = 1,#paramsTable[i].vars do
		     tmp:addItem(lc[paramsTable[i].vars[e]]).onTouch = function()
		       what[paramsTable[i].param] = paramsTable[i].vars[e]
		       OE.draw()
		     end
		     end
    else
     tmp:addItem(lc.truee).onTouch = function()
       what[paramsTable[i].param] = true
       OE.draw()
    		  drawparams(what)
     end
     tmp:addItem(lc.falsee).onTouch = function()
       what[paramsTable[i].param] = false
       OE.draw()
    		  drawparams(what)
     end
    end
   end
   e = i
  end
  local toEnd
  if not useEnd then
    toEnd =  endOfParams(e詷廄檶, objectType)
  else
    toEnd = e  indexOfParam
  end
  return toEnd
end
function drawparams(whatt)
  what = whatt -- Line 15, make what local
  params:removeChildren()
  if not what then 
    if treemode == 'screen' then
      what = game.window
    else
      params:addChild(GUI.panel(1,1,40,25,cr1))
      return false
    end
  end
 	if lc.close == 'ÐÐ°ÐºÑÑÑÑ' or lc.close == 'ÐÐ°ÐºÑÐ¸ÑÐ¸' then
  		divide = 2
 	else
  		divide = 1
 	end
  params:addChild(GUI.panel(1,1,40,25,cr1))
  tt(3,2,cr2,'Params')
  if what.type == 'text' then
    tt(3,3,cr2,lc.type..' | '..what.type)
    drawParamsInParams('text')
  elseif what.type == 'button' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('button')
  elseif what.type == 'script' then
    tt(3,3,cr2,lc.type..': '..what.type)
   local tmp =endOfParams(drawParamsInParams('script',true), 'script')  1
    local codeView = params:addChild(GUI.codeView(3, tmp, 36, 23 - tmp, 1, 1, 1, {}, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))
local counter = 1
for line in fs.lines(what.path) do
	line = line:gsub("\t", "  "):gsub("\r\n", "\n")
	codeView.maximumLineLength = math.max(codeView.maximumLineLength, unicode.len(line))
	table.insert(codeView.lines, line)
	counter = counter  1
	if counter > codeView.height then
		break
	end
end
  elseif what.type == 'image' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('image')
  elseif what.type == 'input' then
    tt(3,3,cr2,lc.type..': | '..what.type)
    drawParamsInParams('input')
  elseif what.type == 'switch' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('switch')
  elseif what.type == 'window' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('window')
  elseif what.type == 'colorSelector' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('colorSelector')
  elseif what.type == 'progressBar' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('progressBar')
  elseif what.type == 'comboBox' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('comboBox')
  elseif what.type == 'slider' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('slider')
  elseif what.type == 'progressIndicator' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('progressIndicator')
  elseif what.type == 'panel' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('panel')
  elseif what.type == 'animation' then
    tt(3,3,cr2,lc.type..': '..what.type)
    drawParamsInParams('animation')
  elseif what.type == 'file' then
    tt(3,3,cr2,lc.type..': '..what.type)
    local tmp01 = drawParamsInParams('file')
    if fs.extension(what.path) == '.pic' then
    		local tmp = params:addChild(GUI.container(3,tmp01,36,23-tmp01))
    		tmp:addChild(GUI.panel(1,1,36,23-tmp01,0x808080))
    		tmp:addChild(GUI.image(1,1,image.load(what.path)))
    end
  else
    tt(1,1,cr2,lc.WYC)
  end
end
function objectmenu()
		if lc.close == 'ÐÐ°ÐºÑÑÑÑ' or lc.close == 'ÐÐ°ÐºÑÐ¸ÑÐ¸' then
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
    OE.Instance.new('panel',userSettings.opengames.panelName or 'Panel',userSettings.opengames.panelX or 1,userSettings.opengames.panelY or 1,userSettings.opengames.panelWidth or 10, userSettings.opengames.panelHeigth or 5,userSettings.opengames.color or cr1,true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(6,4,#lc.text/divide,1,cr1,cr2,cr1,cr2,lc.text))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('text',userSettings.opengames.textName or 'Text',userSettings.opengames.textX or 1,userSettings.opengames.textY or 1,userSettings.opengames.textColor or cr2,userSettings.opengames.textText or 'Hello World!',true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(25,6,#lc.progressBar/divide,1,cr1,cr2,cr1,cr2,lc.progressBar))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('progressBar',userSettings.opengames.progressBarname or 'ProgressBar',userSettings.opengames.progessBarX or 1,userSettings.opengames.progressBarY or 1,userSettings.opengames.progressBarWidth or 20,userSettings.opengames.progressBarColorP or cr1,userSettings.opengames.progressBarColorS or cr2,userSettings.opengames.progressBarColorV or cr2,userSettings.opengames.progressBarValue or 50,true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(25,8,#lc.comboBox/divide,1,cr1,cr2,cr1,cr2,lc.comboBox))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('comboBox',userSettings.opengames.comboBoxName or 'ComboBox',userSettings.opengames.comboBoxX or 1,userSettings.opengames.comboBoxY or 1,userSettings.opengames.comboBoxWidth or 20,userSettings.opengames.comboBoxELH or 3,userSettings.opengames.comboBoxColorBG or cr1,userSettings.opengames.comboBoxColorT or cr2,userSettings.opengames.comboBoxColorABG or cr1,userSettings.opengames.comboBoxColorAT or cr2,true,{{name=userSettings.opengames.comboBoxItemsName or 'Item',active = false,type='itemComboBox',path=''}})
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(7,18,#lc.slider/divide,1,cr1,cr2,cr1,cr2,lc.slider))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('slider',userSettings.opengames.sliderName or 'Slider',userSettings.opengames.sliderX or 1,userSettings.opengames.sliderY or 1,userSettings.opengames.sliderWidth or 20,userSettings.sliderColorP or cr1,userSettings.opengames.sliderColorPP or cr1,userSettings.opengames.sliderColorV or cr2,userSettings.opengames.sliderMinv or 0,userSettings.opengames.sliderMaxv or 100,userSettings.opengames.sliderValue or 50,'',true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(25,4,#lc.progressIndicator/divide,1,cr1,cr2,cr1,cr2,lc.progressIndicator))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('progressIndicator',userSettings.opengames.piName or 'ProgressIndicator',userSettings.opengames.piX or 1,userSettings.opengames.piY or 1,userSettings.opengames.piColorPA or cr3,userSettings.opengames.piColorP or cr1,userSettings.opengames.piColorS or cr2,true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
 local tmp = choose:addChild(GUI.button(7,16,#lc.collorSelector/divide,1,cr1,cr2,cr1,cr2,lc.collorSelector))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('colorSelector',userSettings.opengames.csName or 'ColorSelector',userSettings.opengames.csX or 1,userSettings.opengames.csY or 1,userSettings.opengames.csWidth or 20,userSettings.opengames.csHeight or 3,userSettings.opengames.csColor or 0xFF00FF,userSettings.opengames.csText or 'Hello world!','',true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(6,10,#lc.input/divide,1,cr1,cr2,cr1,cr2,lc.input))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('input',userSettings.opengames.inputName or 'Input',userSettings.opengames.inputX or 1,userSettings.opengames.inputY or 1,userSettings.opengames.inputWidth or 20,userSettings.opengames.inputHeight or 3,userSettings.opengames.inputText or 'Hello world!',userSettings.opengames.inputTextPH or 'Place holder',userSettings.opengames.inputColorBG or cr1,userSettings.opengames.inputColorFG or cr2,userSettings.opengames.inputColorBGP or cr2,userSettings.opengames.inputColorFGP or cr1,userSettings.opengames.inputColorPH or 0x2D2D2D,'',true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(6,12,#lc.switch/divide,1,cr1,cr2,cr1,cr2,lc.switch))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('switch',userSettings.opengames.switchName or 'Switch',userSettings.opengames.switchX or 1,userSettings.opengames.switchY or 1,userSettings.switchWidth or 8,userSettings.opengames.switchColorP or cr2,userSettings.opengames.switchColorS or cr2,userSettings.opengames.switchColorPP or cr1,userSettings.opengames.switchOnStateChanged or '',userSettings.opengames.switchState or false,true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(6,8,#lc.image/divide,1,cr1,cr2,cr1,cr2,lc.image))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('image',userSettings.opengames.imageName or 'Image',userSettings.opengames.imageX or 1,userSettings.opengames.imageY or 1,userSettings.opengames.imageImage or 'StorageEl',true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  local tmp = choose:addChild(GUI.button(6,6,#lc.button/divide,1,cr1,cr2,cr1,cr2,lc.button))
  tmp.onTouch = function()
    choose:remove()
    OE.Instance.new('button',userSettings.opengames.buttonName or 'Button',userSettings.opengames.buttonX or 1,userSettings.opengames.buttonY or 1,userSettings.opengames.buttonWidth or 20,userSettings.opengames.buttonHeight or 3,userSettings.opengames.buttonText or 'Hello world!',userSettings.opengames.buttonColorBG or cr1,userSettings.opengames.buttonColorFG or cr2,userSettings.opengames.buttonColorBGP or cr2,userSettings.opengames.buttonColorFGP or cr1,userSettings.opengames.buttonOnTouch or '', userSettings.opengames.buttonMode or 'default',userSettings.opengames.buttonAnimated or true, userSettings.opengames.buttonSwitchMode or false,userSettings.opengames.buttonDisabled or false,true)
    OE.draw()
    drawtree()
    drawparams(game.screen[#game.screen])
  end
  if OE.imageAtlas then
    local tmp = choose:addChild(GUI.filesystemChooser(23, 10, #lc.animation/divide, 1, cr1, cr2, cr1, cr2, nil, lc.open, lc.close, lc.animation, "/"))
    tmp.onSubmit = function(path)
      choose:remove()
      OE.Instance.new('animation','Animation Object',1,1,path,string.gsub(string.gsub(path,'Atlas.pic','Config.cfg'),'atlas.pic','config.cfg'),true)
      OE.draw()
      drawtree()
      drawparams(game.screen[#game.screen])
   end
  end
  elseif treemode == 'script' then
    local tmp = choose:addChild(GUI.button(6,4,#lc.script/divide,1,cr1,cr2,cr1,cr2,lc.script))
    tmp.onTouch = function()
      choose:remove()
      fs.write('/Temporary/'..tostring(#game.scripts)..'.lua',lc.DFtS)
      table.insert(game.scripts,{autoload = userSettings.opengames.scriptAutoload or false,path = '/Temporary/'..tostring(#game.scripts)..'.lua',name = userSettings.opengames.scriptName or 'Script',type = 'script'})
    drawtree()
    drawparams(game.scripts[#game.scripts])
    end
    local tmp = choose:addChild(GUI.filesystemChooser(5, 6, 10, 1, cr1, cr2, cr1, cr2, nil, lc.open, lc.close, lc.choose, "/"))
    tmp.onSubmit = function(path)
    		if fs.extension(path) == '' or fs.extension(path) == '.lua' then
     		 choose:remove()
       	table.insert(game.scripts,{autoload = userSettings.opengames.scriptAutoload or false,path = path,name = userSettings.opengames.scriptName or 'Script',type = 'script'})
      end
    drawtree()
    drawparams(game.scripts[#game.scripts])
    end
    local tmp = choose:addChild(GUI.button(6,8,#lc.scriptUI/divide,1,cr1,cr2,cr1,cr2,lc.scriptUI))
    tmp.onTouch = function()
      choose:remove()
      fs.write('/Temporary/'..tostring(#game.scripts)..'.lua',lc.DFtS..'\n\nlocal args = {...}\nlocal indexOfObject = args[1]\nlocal OE = args[2]\nlocal object = OE.game.screen[indexOfObject]\n\n')
      table.insert(game.scripts,{autoload = userSettings.opengames.scriptAutoload or false,path = '/Temporary/'..tostring(#game.scripts)..'.lua',name = userSettings.opengames.scriptName or 'Script',type = 'script'})
    drawtree()
    drawparams(game.scripts[#game.scripts])
    end
    local tmp = choose:addChild(GUI.button(6,10,#lc.scriptAutoload/divide,1,cr1,cr2,cr1,cr2,lc.scriptAutoload))
    tmp.onTouch = function()
      choose:remove()
      fs.write('/Temporary/'..tostring(#game.scripts)..'.lua',lc.DFtS..'\n\nlocal args = {...}\nlocal OE = args[2]\n\n')
      table.insert(game.scripts,{autoload = userSettings.opengames.scriptAutoload or false,path = '/Temporary/'..tostring(#game.scripts)..'.lua',name = userSettings.opengames.scriptName or 'Script',type = 'script'})
    drawtree()
    drawparams(game.scripts[#game.scripts])
    end
    local tmp = choose:addChild(GUI.button(6,12,#lc.scriptThread/divide,1,cr1,cr2,cr1,cr2,lc.scriptThread))
    tmp.onTouch = function()
      choose:remove()
      fs.write('/Temporary/'..tostring(#game.scripts)..'.lua',lc.DFtS..'\n\nlocal args = {...}\nlocal events = args[1]\nlocal OE = args[2]\nlocal indexOfCalledScript= args[3]\nlocal objectThatCall = args[4]\nlocal scriptHandle = objectThatCall.scripts[indexOfCalledScript]\n\n')
      table.insert(game.scripts,{autoload = userSettings.opengames.scriptAutoload or false,path = '/Temporary/'..tostring(#game.scripts)..'.lua',name = userSettings.opengames.scriptName or 'Script',type = 'script'})
    drawtree()
    drawparams(game.scripts[#game.scripts])
    end
  elseif treemode == 'storage' then
local tmp = choose:addChild(GUI.filesystemChooser(6, 4, #lc.path/divide, 1, cr1, cr2, cr1, cr2, nil, lc.open, lc.close, lc.path, "/"))
tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
tmp.onSubmit = function(path)
choose:remove()
    table.insert(game.storage,{path = path,name = userSettings.opengames.storageName or 'StorageEl',type = 'file'})
    table.insert(game.storage.buffer,{})
  OE.draw()
  drawtree()
  drawparams(game.storage[#game.storage])
end
  end
end

function drawtree()
  obj:removeChildren()
  obj:addChild(GUI.panel(1,1,36,20,cr1))
		if lc.close == 'ÐÐ°ÐºÑÑÑÑ' or lc.close == 'ÐÐ°ÐºÑÐ¸ÑÐ¸' then
				divide = 2
		else
				divide = 1
		end
    local visibleEl = obj:addChild(GUI.container(4,4,33,16))
		local modesButtons = obj:addChild(GUI.container(1,1,36,20))
		local bg = modesButtons:addChild(GUI.panel(1,1,36,3,cr1))
  local screenmode = modesButtons:addChild(GUI.button(3,2,#lc.screen/divide,1,cr1,cr2,cr1,cr2,lc.screen))
  screenmode.onTouch = function()
    treemode = 'screen'
    drawparams(game.screen[1])
    drawtree()
  end
  local storagemode = modesButtons:addChild(GUI.button(5#lc.screen/divide#lc.scripts/divide,2,#lc.storage/divide,1,cr1,cr2,cr1,cr2,lc.storage))
  storagemode.onTouch = function()
    treemode = 'storage'
    drawparams(game.storage[1])
    drawtree()
  end
  local scriptmode = modesButtons:addChild(GUI.button(4#lc.screen/divide,2,#lc.scripts/divide,1,cr1,cr2,cr1,cr2,lc.scripts))
  scriptmode.onTouch = function()
    treemode = 'script'
    drawparams(game.scripts[1])
    drawtree()
  end
  if treemode == 'screen' then
		local elements = visibleEl:addChild(GUI.container(1,1,33,#game.screen))
    if #game.screen > 15 then
      obj:addChild(GUI.scrollBar(33, 2, 1, 18, 0x444444, 0x888888, 1, #game.screen, 1, 2, 1,true)).onTouch = function(_,obj)
        elements.localY = -1*obj.value
      end
    end
    modesButtons:addChild(GUI.button(3,3,#lc.screen/divide,1,cr1,cr2,cr1,cr2,lc.screen)).onTouch = function()
       drawparams(game.window)
    end
    local addScreen = modesButtons:addChild(GUI.button(#lc.screen/divide,3,1,1,cr1,cr2,cr1,cr2,''))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 1
    for i = 1,#game.screen do
      tmp = elements:addChild(GUI.button(1,y,#game.screen[i].name,1,cr1,cr2,cr1,cr2, game.screen[i].name))
      tmp.onTouch = function()
        drawparams(game.screen[i])
      end
      y = y  1
    end
  elseif treemode == 'script' then
		local elements = visibleEl:addChild(GUI.container(1,1,33,#game.scripts))
    if #game.scripts > 15 then
      obj:addChild(GUI.scrollBar(33, 2, 1, 18, 0x444444, 0x888888, 1, #game.scripts, 1,2, 1,true)).onTouch = function(_,obj)
        elements.localY = -1*obj.value
      end
    end
   modesButtons:addChild(GUI.text(3,3,cr2,lc.scripts))
   local addScreen = modesButtons:addChild(GUI.button(#lc.scripts/divide,3,1,1,cr1,cr2,cr1,cr2,''))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 1
    for i = 1,#game.scripts do
      tmp = elements:addChild(GUI.button(1,y,#game.scripts[i].name,1,cr1,cr2,cr1,cr2, game.scripts[i].name))
      tmp.onTouch = function()
        drawparams(game.scripts[i])
      end
      y = y  1
    end
  elseif treemode == 'storage' then
		local elements = visibleEl:addChild(GUI.container(1,1,33,#game.storage))
    if #game.storage > 15 then
      obj:addChild(GUI.scrollBar(33, 2, 1, 18, 0x444444, 0x888888, 1, #game.storage, 1, 2, 1,true)).onTouch = function(_,obj)
        elements.localY = -1*obj.value
      end
    end
   modesButtons:addChild(GUI.text(3,3,cr2,lc.storage))
   local addScreen = modesButtons:addChild(GUI.button(#lc.storage/divide,3,1,1,cr1,cr2,cr1,cr2,''))
    addScreen.onTouch = function()
      objectmenu()
    end
    y = 1
    for i = 1,#game.storage do
      tmp = elements:addChild(GUI.button(1,y,#game.storage[i].name,1,cr1,cr2,cr1,cr2, game.storage[i].name))
      tmp.onTouch = function()
        drawparams(game.storage[i])
      end
      y = y  1
    end
  end
end
local function adapting()
  for e= 1,#scenes do
    local game = scenes[e].game
   for i = 1,#game.screen do
 	  if game.screen[i].type == 'animation' then
 	   OE.fixAtlas(game.screen[i])
    end
 	 end
  end
end
local function save(path)
		gamepath = path
	  OE.gamepath = gamepath
    if not path then return false end
     fs.makeDirectory('/Temporary/ProjectSave')
     local idk = {}
    for e = 1,#scenes do
      local game = scenes[e].game
      local idk1 ={}
      for i = 1,#game.storage do
      		table.insert(idk1,'/Temporary/ProjectSave/' ..fs.name(game.storage[i].path))
        fs.copy(game.storage[i].path,'/Temporary/ProjectSave/' ..fs.name(game.storage[i].path))
      end
      for i = 1,#game.scripts do
      		table.insert(idk1,'/Temporary/ProjectSave/' ..fs.name(game.scripts[i].path))
        fs.copy(game.scripts[i].path,'/Temporary/ProjectSave/'..fs.name(game.scripts[i].path))
      end
      table.remove(OE.ABN)
		  for i = 1,#game.screen do
	  		  table.remove(game.screen[i].raw)
          OE.cleanBuffers()
		  		if game.screen[i].type == 'animation' then
  		  		table.remove(game.screen[i].tick)
  		  		table.remove(game.screen[i].atlas)
  		  		table.remove(game.screen[i].checkNext)
		  		end
		  end
      table.insert(idk,string.gsub('/Temporary/ProjectSave/'..scenes[e].name,'.part','')..'.part')
      compressor.pack(string.gsub('/Temporary/ProjectSave/'..scenes[e].name,'.part','')..'.part',idk1)
    end
  print(game.screen[1].raw)
  --fs.writeTable('/Temporary/ProjectSave/Game.dat',scenes)
  compressor.pack(string.gsub(path,'.proj','')..'.proj',idk)
  adapting()
  OE.draw()
end
local function saveAsWindow ()
		local tmp = GUI.addFilesystemDialog(wk,true,50, 30, lc.save,lc.cancel,lc.name,'/')
	 tmp:setMode(GUI.IO_MODE_SAVE, GUI.IO_MODE_FILE)
		tmp.onSubmit = function(path)
		  if fs.exists(path..'.pkg') then 
			  	if lc.close == 'ÐÐ°ÐºÑÑÑÑ' or lc.close == 'ÐÐ°ÐºÑÐ¸ÑÐ¸' then
				  		divide = 2
			  	else
				  		divide = 1
			  	end
		  		local winerr = win:addChild(GUI.filledWindow(60,20,Wlen(lc.YNEF),7,0xAAAAAA))
          winerr.actionButtons.close.onTouch = function()
            winerr:remove()
          end
		  		winerr:addChild(GUI.text(2,4,cr2,lc.YNEF))
		  		winerr:addChild(GUI.button(2,6,2#lc.save/divide,1,cr1,cr2,cr1,cr2,lc.save)).onTouch = function()
		 				 save(path)
		 				 winerr:remove()
		    end
		  		winerr:addChild(GUI.button(4#lc.YNEF/divide-#lc.cancel/divide-3,6,#lc.cancel/divide,1,cr1,cr2,cr1,cr2,lc.close)).onTouch = function()
		 				  winerr:remove()
		 				  return 
		 				  end
		  else
		  		save(path)
		  end
		  OE.draw()
		  drawtree()
		end
	tmp:show()
end
local function new()
		OE.scenes = {{name='MainMenu',game = {scripts = {},window = {abn = userSettings.opengames.windowABN or true,type = 'window',width=userSettings.opengames.windowWidth or 80,height= userSettings.opengames.windowHeight or 40, title = userSettings.opengames.windowTitle or 'Title',buffer={},color = userSettings.opengames.windowColor or cr4,titleColor = userSettings.opengames.windowTitleColor or cr2},screen = {buffer = {}},storage={buffer={}}}}}
		OE.loadScene('MainMenu')
    scenes = OE.scenes
    game = OE.game
		drawtree()
		drawparams()
end
local function saveOrPass(onEnd,arg1)
		 	if lc.close == 'ÐÐ°ÐºÑÑÑÑ' or lc.close == 'ÐÐ°ÐºÑÐ¸ÑÐ¸' then
		  		divide = 2
		 	else
		  		divide = 1
		 	end
		    local winerr = win:addChild(GUI.filledWindow(60,20,Wlen(lc.saveToPath)흏隕(lc.withoutSave),7,0xAAAAAA))
        winerr.actionButtons.close.onTouch = function()
          winerr:remove()
        end
				winerr:addChild(GUI.text(2,4,cr2,lc.NF))
				winerr:addChild(GUI.button(2,6,Wlen(lc.saveToPath),1,cr1,cr2,cr1,cr2,lc.saveToPath)).onTouch = function()
					 saveAsWindow()
					 winerr:remove()
					 onEnd(arg1)
		  end
				winerr:addChild(GUI.button(Wlen(lc.saveToPath),6,Wlen(lc.withoutSave),1,cr1,cr2,cr1,cr2,lc.withoutSave)).onTouch = function()
				  winerr:remove()
				  onEnd(arg1)
		  end
end
local contextMenu = menu:addContextMenuItem(lc.file)
contextMenu:addItem(lc.new,false).onTouch = function()
		saveOrPass(new)
end
contextMenu:addSeparator()
contextMenu:addItem(lc.save,false).onTouch = saveAsWindow
local function open(path)
				gamepath = path
		  compressor.unpack(path,'/Temporary/')
		  path = '/Temporary/ProjectSave/'
		  if not fs.exists(path..'/Game.dat') then GUI.alert(lc.UFP) return end
		  OE.scenes = fs.readTable(path..'/Game.dat')
      scenes = OE.scenes
		  idk = fs.list(path)
		  for i = 1,#idk do
        for j = 1,#scenes do
        local game = scenes[j].game
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
		    end end
		  end
		  for i = 1,#game.screen.buffer do
		  		game.screen.buffer[i].visible = false
 		  end
      OE.loadScene(scenes[1].name)
      game = OE.game
			OE.gamepath = gamepath
			adapting()
		  drawparams(game.screen[1])
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
OE.editorSave = save
OE.gamepath = gamepath
OE.regScript(function(...)
  local args = {...}
  local OE = args[2]
  local objectIndex = args[3]
  local object = args[4]
  if OE.gamepath ~= '' or not OE.gamepath then
    --OE.editorSave(OE.gamepath)
  end
end,'function',userSettings.autoSaveTime or 30,-1,'Auto Save OpenGames Editor Service')
contextMenu:addSeparator()
contextMenu:addItem(lc.export,false).onTouch = function()
				local tmp = GUI.addFilesystemDialog(wk,true,50, 30, lc.export,lc.cancel,lc.name,'/')
		tmp:setMode(GUI.IO_MODE_SAVE, GUI.IO_MODE_FILE)
		local function export(path)
		  local towrite = ''
		  towrite = towrite .. 'local image = require("Image")\nlocal fs = require("filesystem")\nlocal event = require("event")\nlocal GUI = require("GUI")\nlocal system = require("System")\nlocal OE = require("opengames")\nlocal gamepath = string.gsub(system.getCurrentScript(),"/Main.lua","")\n'
		  fs.makeDirectory(path..'.app/Scripts')
		  fs.makeDirectory(path..'.app/Assets')
		  fs.makeDirectory(path..'.app/Localizations')
		  fs.makeDirectory(path..'.app/Animation_data')
      local chooseSceneWin = wk:addChild(GUI.filledWindow(60,20,#lc.CFSE/divide,9,0xAAAAAA))
      chooseSceneWin:addChild(GUI.text(2,4,cr2,lc.CFSE))
      local tmp = chooseSceneWin:addChild(GUI.comboBox(2,6,20,3,cr1,cr2,cr1,cr2))
      local choosed
      for i = 1,#scenes do
        tmp:addItem(scenes[i].name).onTouch = function()
          choosed = scenes[i].name
		  towrite = towrite .. '\nlocal scenes = fs.readTable(gamepath.."/Game.dat")\nlocal game = OE.find(scenes,"'..choosed..'").game \nlocal wk,win,menu = system.addWindow(GUI.filledWindow(1,1,game.window.width,game.window.height,0x989898))\nwin:removeChildren()\nOE.init({win = win, gamePath = gamepath, win=win,startScene="'..choosed..'",editor = false,allScenes = scenes, container = win})\ngame.localization=system.getCurrentScriptLocalization()for i = 1,#game.screen do\n if game.screen[i].type == "animation" then\n game.screen[i].tick = function(anim)     anim.stage = anim.stage  1    if anim.atlas:getImage(tostring(anim.stage)) then       anim.raw.image = anim.atlas:getImage(tostring(anim.stage))      return true, "next"    else       anim.stage = 1      anim.raw.image = anim.atlas:getImage(tostring(anim.stage))       return true, "new"    end    end    game.screen[i].checkNext = function(anim)     local tmp = anim.stage  1    if anim.atlas:getImage(tostring(tmp)) then      return "next"    else      return "new"    end		 end\n local path = gamepath.."/Animation_data/"..game.screen[i].name.."/Atlas.pic"\ngame.screen[i].atlas = require("imageAtlas").init(path,string.gsub(path,"Atlas.pic","Config.cfg"))\nend\nend\n for i = 1,#game.scripts do\n if game.scripts[i].autoload == true then\n OE.execute(game.scripts[i].name)\n end\n end'
		  fs.write(path..'.app/Main.lua',towrite)
      chooseSceneWin:remove()
      for e = 1,#scenes do
      local game = scenes[e].game
		  for i = 1, #game.screen do
		  		if game.screen[i].type == 'animation' then
						  fs.makeDirectory(path..'.app/Animation_data/'..game.screen[i].name)
						  game.screen[i].atlas:save(path..'.app/Animation_data/'..game.screen[i].name..'/')
		  		end
		  end
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
		    if game.storage[e].name == '{AppIcon}' and fs.extension(game.storage[e].path) == '.pic' then
		      idk = game.storage[e].path
		    end
		  end
		  for i = 1,#game.screen do
          if game.screen[i].raw then
  		  		table.remove(game.screen[i].raw)
          end
          OE.cleanBuffers()
		  		if game.screen[i].type == 'animtion' then
  		  		table.remove(game.screen[i].tick)
  		  		table.remove(game.screen[i].atlas)
  		  		table.remove(game.screen[i].checkNext)
		  		end
		  end
		  game.window.buffer.abn = false
      end
		  fs.writeTable(path..'.app/Game.dat',scenes)
		  if idk == nil then idk = '/Icons/Application.pic' end
		  fs.copy(idk,path..'.app/Icon.pic')
      adapting()
        end
      end
		end
		tmp.onSubmit = function(path)
		  if fs.exists(path..'.app') then
		  		local winerr = win:addChild(GUI.filledWindow(60,20,Wlen(lc.EF),7,0xAAAAAA))
          winerr.actionButtons.close.onTouch = function()
            winerr:remove()
          end
			  	if lc.close == 'ÐÐ°ÐºÑÑÑÑ' or lc.close == 'ÐÐ°ÐºÑÐ¸ÑÐ¸' then
			  			divide = 2
				  else
				  		divide = 1
			  	end
		  		winerr:addChild(GUI.text(2,4,cr2,lc.EF))
		  		winerr:addChild(GUI.button(2,6,#lc.export/divide,1,cr1,cr2,cr1,cr2,lc.export)).onTouch = function()
		 				 export(path)
		 				 winerr:remove()
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
    local tmp = container.layout:addChild(GUI.comboBox(1, 1, #lc.falsee/divide, 1, cr1, cr2, cr1, cr2))
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
		colorItem(lc.autoSave,'autoSaveTime',tmp)
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
local scenesMenu = menu:addContextMenuItem(lc.scenes)
scenesMenu:addItem(lc.newScene).onTouch = function()
  table.insert(scenes,{name='Scene #'..tostring(#scenes),game={scripts = {},window = {abn = userSettings.opengames.windowABN or true,type = 'window',width=userSettings.opengames.windowWidth or 80,height= userSettings.opengames.windowHeight or 40, title = userSettings.opengames.windowTitle or 'Title',buffer={},color = userSettings.opengames.windowColor or cr4,titleColor = userSettings.opengames.windowTitleColor or cr2},screen = {buffer = {}},storage={buffer={}}}})
end
scenesMenu:addItem(lc.removeScene).onTouch = function()
	local container = GUI.addBackgroundContainer(wk, true, true)
  local tmp = container.layout:addChild(GUI.comboBox(1, 1, 30, 3, cr1, cr2, cr1, cr2))
  local show
  for i = 1,#scenes do
    tmp:addItem(scenes[i].name).onTouch = function(_,object)
      if #scenes > 1 then
        table.remove(scenes,i)
        object:remove()
      else
        if not show then
          container.layout:addChild(GUI.text(1,2,cr1,lc.MbOS))
        end
      end
    end
  end
end
scenesMenu:addSeparator()
scenesMenu:addItem(lc.loadScene).onTouch = function()
	local container = GUI.addBackgroundContainer(wk, true, true)
  local tmp = container.layout:addChild(GUI.comboBox(1, 1, 30, 3, cr1, cr2, cr1, cr2))
  for i = 1,#scenes do
    tmp:addItem(scenes[i].name).onTouch = function()
      OE.loadScene(scenes[i].name)
      game = OE.game
      drawtree()
      drawparams(game.screen[1])
    end
  end
end
scenesMenu:addItem(lc.edit).onTouch = function()
	local container = GUI.addBackgroundContainer(wk, true, true)
  local tmp = container.layout:addChild(GUI.comboBox(1, 1, 30, 3, cr1, cr2, cr1, cr2))
  local tmp01 =container.layout:addChild(GUI.input(1,2,30,3,cr1,cr2,0x0,cr2,cr1,lc.sceneName,lc.SMN))
  for i = 1,#scenes do
    tmp:addItem(scenes[i].name).onTouch = function(_,object)
      tmp01.text = scenes[i].name
      tmp01.choosedItem = object
      tmp01.choosed = i
    end
  end
  tmp01.onInputFinished = function(_,object)
    if scenes[object.choosed] then
      scenes[object.choosed].name = tmp01.text
      object.choosedItem.text = tmp01.text
    end
  end
end
sampleParams()
OE.draw()
drawtree()
drawparams()
 
