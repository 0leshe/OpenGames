local opengames = {Instance={}}
local GUI = require('GUI')
local image = require('Image')
local system = require('System')
local fs = require('filesystem')
local computer = require("computer")
local paths = require('Paths')
local eventObject

local pathApp = '/Users/' .. system.getUser() .. '/Application data/'
if not fs.exists(pathApp .. '/OpenTech/') then
  fs.makeDirectory(pathApp..'/OpenTech/')
  if not fs.exists(pathApp .. '/OpenTech/OpenGames/') then
    fs.makeDirectory(pathApp..'/OpenTech/OpenGames/')
    if not fs.exists(pathApp .. '/OpenTech/OpenGames/Logs/') then
      fs.makeDirectory(pathApp..'/OpenTech/OpenGames/Logs/')
    end
  end
end
function opengames.getTime()
  return os.date("%d_%b_%Y_%H_%M_%S", system.getTime())
end
local startTime = opengames.getTime()
local pathApp = '/Users/' .. system.getUser() .. '/Application data/OpenTech/OpenGames/'

local function execute(path,...)
  opengames.log('[LOG] {'..opengames.getTime()..'} Execute script: '..path..' with params: '.. ...)
	local gamepath = opengames.gamepath
  if opengames.cashe.scripts[path] then
    return system.call(load(opengames.cashe.scripts[path]), ... ,opengames)
  else
		if fs.exists(gamepath..'/Scripts/'..path..'.lua') then
      opengames.cashe.scripts[path] = fs.read(gamepath..'/Scripts/'..path..'.lua')
    else
      return false, 'Required file does not exists.'
    end
    return system.call(load(opengames.cashe.scripts[path]), ... ,opengames)
  end
end
local function loadImage(path)
  opengames.log('[LOG] {'..opengames.getTime()..'} Load image in storage object: '..path)
  if not opengames.cashe.images[path] then
    local game = opengames.game
    idk = nil
    for e = 1,#game.storage do
      if game.storage[e].name == path and fs.extension(game.storage[e].path) == '.pic' then
        idk = game.storage[e].path
      end
    end
    if idk == nil then return image.load('/Icons/Script.pic') end
    opengames.cashe.images[path] = image.load(idk)
  end
  if opengames.useImages == true then
    return opengames.cashe.images[path]
  else
    return image.load('/Icons/Script.pic')
  end
end

local logsList = fs.list(pathApp..'/Logs/')
if #logsList > 5 then
  for i = 1,#logsList do
    if #logsList - i > 5 then
      fs.remove(pathApp..'/Logs/'..logsList[i])
    else
      break
    end
  end
end


local params = {
  minv = 'minimumValue',
  maxv = 'maximumValue',
  x = 'localX',
  y = 'localY'
}

function opengames.exit()
  opengames.mainContainer:remove()
  opengames.log('[LOG] {'..opengames.getTime()..'} Exit application')
  opengames.scenes = nil
end

function opengames.log(str)
  if opengames.logAllowed then
    fs.append(pathApp..'/Logs/Log_'..startTime..'.txt',str..'\n')
  end
end

function opengames.debugLog(str)
  if opengames.debugAllowed then
    opengames.log('[DEBUG] {'..opengames.getTime()..'} '..str)
  end
end

function opengames.init(params)
	opengames.isEditor = params.editor or false
	opengames.useImages = params.useImages or true
	if not params.allScenes then
			system.error('Init MUST contain scenes.')
	end
	if not params.container then
			system.error('Init MUST contain window or container.')
	end
	if not opengames.isEditor then
			if not params.gamePath then
					system.error('Init MUST contain game path.')
			end
	end
  -- Init params
	opengames.gamepath = params.gamePath
  opengames.scenes = params.allScenes
	opengames.cashe = {scripts={},images={}}
	opengames.editor = {WK = params.wk}
  opengames.BG=params.bg
  opengames.TITLE=params.title
	opengames.imageAtlas = params.imageAtlas
  opengames.mainContainer = params.container
	opengames.container = opengames.mainContainer:addChild(GUI.container(1,1,160,50))
  opengames.logAllowed = params.logAllowed
  opengames.debugAllowed = params.debugAllowed
  if opengames.logAllowed then
    fs.write(pathApp..'/Logs/Log_'..startTime..'.txt','Start log. Good luck to understand.\n')
  end
  opengames.loadScene(params.startScene)
  local game = opengames.game
  local window = game.window
  local screen = opengames.mainContainer
  opengames.TITLE.text = window.title
  screen.width = window.width
  opengames.BG.width = window.width
  screen.height = window.height
  opengames.BG.height = window.height
  opengames.BG.colors.background = window.color
  opengames.TITLE.color = window.titleColor
  opengames.ABN = nil
	-- Init scripts module
	eventObject = opengames.mainContainer:addChild(GUI.object(1,1,1,1))
	eventObject.scripts = {} -- [n] = {time_started, prev_call, time_end, interval, callback}
	eventObject.opengames = opengames
	eventObject.eventHandler = function(_,object,...)
	  local computer = require('computer')
	  for i = 1, #object.scripts do
	    if computer.uptime() > object.scripts[i].prev_call+object.scripts[i].interval then
	      object.scripts[i].prev_call = computer.uptime()
	      object.scripts[i].callback({...},object.opengames,i,object)
	    end
	    if computer.uptime()-object.scripts[i].time_end < computer.uptime() then
	      if object.scripts[i].time_end > 0 then
	        object.scripts[i] = nil
	      end
	    end
	  end
	end
  opengames.log('[LOG] {'..opengames.getTime()..'} Init completed')
end
function opengames.fixAtlas(object)
  opengames.log('[LOG] {'..opengames.getTime()..'} Fixing atlas')
  if object.type == 'animation' then
   local image = image.copy(object.atlas.atlas.image)
   local config = table.copy(object.atlas.config)
   object.atlas = require('ImageAtlas').init(1,1)
   object.atlas.atlas.image = image
   object.atlas.config = config
		 object.tick = function(anim) 
		   anim.stage = anim.stage + 1
		   if anim.atlas:getImage(tostring(anim.stage)) then 
		     anim.raw.image = anim.atlas:getImage(tostring(anim.stage))
		     return true, 'next'
		   else 
		     anim.stage = 1
		     anim.raw.image = anim.atlas:getImage(tostring(anim.stage)) 
		     return true, 'new'
		   end
		 end
		 object.checkNext = function(anim)
		   if anim.atlas:getImage(tostring(anim.stage + 1)) then
		     return 'next'
		   else
		     return 'new'
		   end
     end
    object.loadAnimation = function(aninm,atlas,config)
      anim.atlas = atlas
      anim.config = config
    end
  else
    return false
  end
end
function opengames.breakAtlas(object)
  opengames.log('[LOG] {'..opengames.getTime()..'} Break atlas')
  if object.type == 'animation' then
    object.loadAnimation = nil
    object.checkNext = nil
    object.tick = nil
    local function removeFunctions(t)
      for i = 1,#t do
        if type(t[i]) == 'function' then
          t[i] = nil
        end
      end
    end
    removeFunctions(object.atlas)
  else
    return false
  end
end
function opengames.Instance.new(...)
   local args = {...}
  local success = false
   opengames.log('[LOG] {'..opengames.getTime()..'} New instanse: '..args[1])
   opengames.debugLog('Args: '..require('text').serialize(args,true))
   local game = opengames.game
  if args[1] == 'panel' then
    table.insert(game.screen,{visible = args[8],type = 'panel',x=args[3],y= args[4],color= args[7],width = args[5],height= args[6],name =  args[2]})
    success = true
  elseif args[1] == 'text' then
    tmp = opengames.container:addChild(GUI.text(args[3],args[4],args[5],args[6]))
  elseif args[1] == 'progressBar' then
    table.insert(game.screen,{visible = args[10],width= args[5],colorp = args[6],colors=args[7],colorv=args[8],type = 'progressBar',x=args[3],y=args[4],color=args[6],value=args[9],name = args[2]})
    success = true
  elseif args[1] == 'comboBox' then
    table.insert(game.screen,{visible = args[11],type = 'comboBox',width=args[5],x=args[3],y=args[4] or 1,elh=args[6],items=args[12] or {},colorbg=args[7],colort=args[8],colorabg=args[9],colorat=args[10],name=args[2]})
    success = true
  elseif args[1] == 'slider' then
    table.insert(game.screen,{visible = args[13],type = 'slider',path=args[12],x=args[3],y=args[4],width=args[5],colorp=args[6],colorpp=args[7],colorv=args[8],minv=args[9],maxv=args[10],value=args[11], name = args[2]})
    success = true
  elseif args[1] == 'progressIndicator' then
    table.insert(game.screen,{visible = args[8],type = 'progressIndicator',x=args[3],y=args[4],active= false,rollStage= 1,colorp= args[6],colors=args[7],colorpa=args[5],name = args[2]})
    success = true
  elseif args[1] == 'colorSelector' then
    table.insert(game.screen,{visible = args[10],path=args[9],type = 'colorSelector',color=args[7],x=args[3],y=args[4],width=args[5],height=args[6],text=args[8],name = args[2]})
    success = true
  elseif args[1] == 'input' then
    table.insert(game.screen,{visible = args[15],onInputEnded = args[14],width=args[5],height=args[6],colorbg = args[9],colorfg = args[10],colorfgp = args[12],colorbgp = args[11],colorph=args[13],type = 'input',x=args[3],y=args[4],name = args[2],text = args[7],textph = args[8]})
    success = true
  elseif args[1] == 'switch' then
    table.insert(game.screen,{onStateChanged = args[9], visible =args[11],state=args[10],type = 'switch',x=args[3],y=args[4],width=args[5],colorp=args[6], colors=args[7],colorpp=args[8],name = args[2]})
    success = true
  elseif args[1] == 'button' then
    table.insert(game.screen,{visible = args[17],onTouch = args[12], height = args[6],width = args[5], animated = args[14] or true, disabled = args[16] or false, switchMode = args[15] or false, type = 'button',x= args[3],y=args[4],name = args[2],colorbg= args[8],mode=args[13],colorfg = args[9],colorbgp = args[10],colorfgp= args[11],text=args[7]})
    success = true
  elseif args[1] == 'image' then
    table.insert(game.screen,{visible = args[6], type = 'image',x=args[3],y=args[4],image=args[5],name = args[2]})
    success = true
  elseif args[1] == 'animation' then
    table.insert(game.screen,{visible = args[7],stage=0,type='animation',x=args[3],y=args[4],name=args[2],atlas=require('imageAtlas').init(args[5],args[6])})
    opengames.fixAtlas(game.screen[#game.screen])
    success = true
  end
  tmp.name = args[2]
  tmp.type = args[1]
  tmp.visible = args[#args]
  tmp.changeColor = function(object,type,color)
    if object.type == 'text' or object.type == 'panel' then
      object.color = color
    elseif object.type == 'button' or object.type == 'input' or object.type == 'switch' or object.type == 'progressIndicator' or object.type == 'slider' or object.type == 'progressBar' or object.type == 'comboBox' then
      object.colors[type] = color
    end
  end
  table.insert(game.screen,tmp)
end
function opengames.Instance.remove(thing)
	if type(thing) == 'string' then
			_,thing = opengames.find(opengames.game.screen,thing)
	elseif type(thing) == 'table' then
	  thing = opengames.find(opengames.game.screen,thing)
	end
	if not opengames.game.screen[thing] then return false end
  opengames.log('[LOG] {'..opengames.getTime()..'} Instanse remove:{\n  name: '..opengames.game.screen[thing].name..'\n  index: '..thing..'\n}')
  opengames.game.screen[thing]:remove()
  table.remove(opengames.game.screen,thing)
end
function table.copy(originalTable) -- Idk how to do it normal
 local copyTable = {}
  for k,v in pairs(originalTable) do
    if k ~= 'buffer' then
      copyTable[k] = v
    end
  end
 return copyTable
end
  local function dodgeParam(what) -- For buffers we need to dont change buffer params when we change main.
    local toreturn = 0
    toreturn = what
    return toreturn
  end
function opengames.changedWindow()
  local game = opengames.game
  local screen = opengames.mainContainer
  local window = game.window
  local windowBuffer = game.window.buffer
  for e,p in pairs(game.window) do
    if e ~= windowBuffer[e] then
      if e == 'title' then
        opengames.TITLE.text = window.title
        opengames.TITLE.localX = math.ceil(window.width/2-math.ceil(unicode.len(window.title)/2))
      elseif e == 'abn' then
        if window[e] == true then
          if not opengames.ABN then
            opengames.ABN = screen:addChild(GUI.actionButtons(2,2,false))
            if not opengames.isEditor then
  						opengames.ABN.close.onTouch = function()
                  opengames.exit()
  						end
  						opengames.ABN.minimize.onTouch = function()
  								opengames.win:minimize()
  						end
            end
          end
        else
          if opengames.ABN then
            opengames.ABN:remove()
            opengames.ABN = nil
          end
        end
      end
      windowBuffer[e] = dodgeParam(window[e])
    end
  end
end
function opengames.draw(obj,args)
  opengames.debugLog('Calling draw')
  if not obj or not args then
    return false, 'Prob. you use draw method in old way.\n\n\n\ncry'
  end
  
end
function opengames.getObject(index)
  opengames.debugLog('Getting screen object by '..index..' index')
	if type(index) == 'number' then
		return opengames.game.screen[index]
	elseif type(index) == 'string' or type(index) == 'table' then
	  object,_ = opengames.find(opengames.game.screen,index)
	  return object
	end
end
function opengames.getScript(index)
  opengames.debugLog('Getting script by '..index..' index')
	if type(index) == 'number' then
	  return opengames.game.scripts[index]
	elseif type(index) == 'string' or type(index) == 'table' then
	  object,_ = opengames.find(opengames.game.scripts,index)
	  return object
	end
end
function opengames.getStorageEl(index)
  opengames.debugLog('Getting storage element by'..index..' index')
	if type(index) == 'number' then
	return opengames.game.storage[index]
	elseif type(index) == 'string' or type(index) == 'table' then
	  object,_ = opengames.find(opengames.game.storage,index)
	  return object
	end
end
function opengames.getStorage()
  return opengames.game.storage
end
function opengames.getScreen()
  return opengames.game.screen
end
function opengames.getScripts()
  return opengames.game.scripts
end
function opengames.clearCashe()
  opengames.debugLog('Clear cashe')
  opengames.cashe = {images={},scripts={}}
end
function opengames.clearImageCashe(imageName)
  opengames.debugLog('Clear '..imageName..' image cashe')
  opengames.cashe.images[imageName] = nil
end
function opengames.clearScriptCashe(scriptName)
  opengames.debugLog('Clear '..scriptName..' script cashe')
  opengames.cashe.script[scriptName] = nil
end
function opengames.getLocalization(index)
  if index then
    return opengames.game.localization[index]
  else
    return opengames.game.localization
  end
end
function opengames.execute(object,...)
  return execute(object,...)
end
function opengames.regScript(script,mode,interval,endtime,name)
  opengames.debugLog('Register script: {\n  '..mode..'\n '..interval..'\n '..endtime..'\n '..name..'\n}')
  local callback
  if mode == 'execute' then
    callback = load(fs.read(gamepath..'/Scripts/'..opengames.getScript(script).path))
  elseif mode == 'string' then
     callback = load(script)
   elseif mode == 'function' then
     callback = script
  end
  if callback then
    table.insert(eventObject.scripts,{time_started = computer.uptime(), prev_call = computer.uptime(), interval = interval,callback = callback, name = name, time_end = endtime})
  else
    return false
  end
  return true
end
function opengames.unregScript(name)
  opengames.debugLog('Unregister '..name..' script')
  result,_ = opengames.find(eventObject.scripts,name)
  result.time_end = 1
end
function opengames.cleanBuffers()
  opengames.log('[LOG] {'..opengames.getTime()..'} Clean buffers')
  local game = opengames.game
  game.screen.buffer = {}
  game.scripts.buffer = {}
  game.storage.buffer = {}
  game.window.buffer = {}
end
function opengames.loadScene(sceneName)
  opengames.log('[LOG] {'..opengames.getTime()..'} Load scene: '..sceneName)
  if opengames.find(opengames.scenes,sceneName) then
    if opengames.game then
      opengames.cleanBuffers()
      if opengames.game == opengames.find(opengames.scenes,sceneName).game then
        return false, 'Alr loaded'
      end
      opengames.clearCashe()

    end
    opengames.game = opengames.find(opengames.scenes,sceneName).game
    if not opengames.isEditor then
      for i = 1,#game.scripts do
        if game.scripts[i].autoload then
          execute(game.scripts[i].name)
        end
      end
    end
		if not opengames.game.localization then
				opengames.game.localization = {}
		end
    opengames.container:removeChildren()
    opengames.cleanBuffers()
    for i = 1,#opengames.game.screen do
      opengames.draw(opengames.game.screen)
    end
    opengames.changedWindow()
  else
    return false, 'Scene does not exists xdd'
  end
  return true
end
function opengames.colide(obj1,obj2)
  if not obj1 and not obj2 then
    return false, 'Wrong objects'
  end
  opengames.debugLog('Is colide screen objects: {\n  '..obj1.name..'\n  '..obj2.name..'\n}\nRESULT:\n')
  if obj1.raw:isPointInside(obj2.raw.x,obj2.raw.y) then
    opengames.debugLog('True')
    return true
  else
    opengames.debugLog('False')
    return false
  end
end
function opengames.colideWW(object) -- colide With Who
  opengames.debugLog('Checking colides with screen object: '..object.name)
  local returnTable = {}
  for i = 1,#opengames.game.screen do
    if opengames.colide(object,opengames.game.screen[i]) then
      table.insert(returnTable,opengames.game.screen[i])
    end
  end
  return returnTable
end
function opengames.playAnimation(object,speed)
  opengames.debugLog('Play animation : {\n  OBJECT_NAME: '..object.name..'\n  SPEED: '..speed)
  if type(object) == 'number' then
    object = opengames.game.screen[object]
  elseif type(object) == 'string' then
    object = find(opengames.game.screen,object)
  end
  if not opengames.find(eventObject.scripts,object.name) then -- Works only if animation for this object dosent started
		  opengames.cashe.eventObject = {[object.name] = {prevStage = object.stage}}
		  object.stage = 0
		  opengames.regScript(function(...) 
		  local args = {...}
		  local object, index = args[2].find(args[2].game.screen,args[4].scripts[args[3]].name) -- finding animation object
		  if object:checkNext() == 'new' then -- check if animation ended ..
		    object.stage = args[2].cashe.eventObject[args[4].scripts[args[3]].name].prevStage - 1
		    object:tick()
		    args[2].unregScript(args[4].scripts[args[3]].name) -- .. if yes killing script ..
		  else
		    object:tick() -- .. else next frame
		  end
		  end,'function',speed,-1,object.name)
  end
end
function opengames.getEventObject()
  return eventObject
end
function opengames.find(where,what)
  opengames.debugLog('Finding function called')
	for i = 1, #where do
		if where[i].name == what and type(what) == 'string' then
			return where[i], i
		elseif where[i] == what and type(what) == 'table' then
		  return i
		end
	end
  if where[what] then
    return where[what]
  end
	return false
end

opengames.log('[LOG] {'..opengames.getTime()..'} Lib called')

return opengames

--[[
Code arhive


		if game.screen[i].text then
  		local tbl = {}
  		for part in string.gmatch(game.screen[i].text,"[^ ]+") do
  		  table.insert(tbl, part)
  		end
  		if tbl[1] == '{loc}' or tbl[1] == '{localization}' then
				text = game.localization[tbl[2] ]
  		else
				text = game.screen[i].text
  		end
		end
		if game.screen[i].textph then
			local tbl = {}
			for part in string.gmatch(game.screen[i].textph,"[^ ]+") do
			  table.insert(tbl, part)
			end
			if tbl[1] == '{loc}' or tbl[1] == '{localization}' then
				textph = game.localization[tbl[2] ]
			else
				textph = game.screen[i].textph
			end
		end

]]
