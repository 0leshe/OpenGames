local opengames = {Instance={}}
local GUI = require('GUI')
local image = require('Image')
local system = require('System')
local fs = require('filesystem')
local computer = require("computer")
local paths = require('Paths')
local eventObject
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
    opengames.win = params.container
    opengames.scenes = params.allScenes
		opengames.cashe = {scripts={},images={}}
		opengames.editor = {WK = params.wk}
    opengames.BG=params.bg
    opengames.TITLE=params.title
		opengames.imageAtlas = params.imageAtlas
		opengames.container = params.container
    opengames.loadScene(params.startScene)
		-- Init scripts module
		eventObject = opengames.container:addChild(GUI.object(1,1,1,1))
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
end
function opengames.fixAtlas(object)
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
   local game = opengames.game
  if args[1] == 'panel' then
    table.insert(game.screen,{visible = args[8],type = 'panel',x=args[3],y= args[4],color= args[7],width = args[5],height= args[6],name =  args[2]})
  elseif args[1] == 'text' then
    table.insert(game.screen,{visible =args[7],type = 'text',x= args[3],y=args[4],color=args[5],text=args[6],name = args[2]})
  elseif args[1] == 'progressBar' then
    table.insert(game.screen,{visible = args[10],width= args[5],colorp = args[6],colors=args[7],colorv=args[8],type = 'progressBar',x=args[3],y=args[4],color=args[6],value=args[9],name = args[2]})
  elseif args[1] == 'comboBox' then
    table.insert(game.screen,{visible = args[11],type = 'comboBox',width=args[5],x=args[3],y=args[4] or 1,elh=args[6],items=args[12] or {},colorbg=args[7],colort=args[8],colorabg=args[9],colorat=args[10],name=args[2]})
  elseif args[1] == 'slider' then
    table.insert(game.screen,{visible = args[13],type = 'slider',path=args[12],x=args[3],y=args[4],width=args[5],colorp=args[6],colorpp=args[7],colorv=args[8],minv=args[9],maxv=args[10],value=args[11], name = args[2]})
  elseif args[1] == 'progressIndicator' then
    table.insert(game.screen,{visible = args[8],type = 'progressIndicator',x=args[3],y=args[4],active= false,rollStage= 1,colorp= args[6],colors=args[7],colorpa=args[5],name = args[2]})
  elseif args[1] == 'colorSelector' then
    table.insert(game.screen,{visible = args[10],path=args[9],type = 'colorSelector',color=args[7],x=args[3],y=args[4],width=args[5],height=args[6],text=args[8],name = args[2]})
  elseif args[1] == 'input' then
    table.insert(game.screen,{visible = args[15],onInputEnded = args[14],width=args[5],height=args[6],colorbg = args[9],colorfg = args[10],colorfgp = args[12],colorbgp = args[11],colorph=args[13],type = 'input',x=args[3],y=args[4],name = args[2],text = args[7],textph = args[8]})
  elseif args[1] == 'switch' then
    table.insert(game.screen,{onStateChanged = args[9], visible =args[11],state=args[10],type = 'switch',x=args[3],y=args[4],width=args[5],colorp=args[6], colors=args[7],colorpp=args[8],name = args[2]})
  elseif args[1] == 'button' then
    table.insert(game.screen,{visible = args[17],onTouch = args[12], height = args[6],width = args[5], animated = args[14] or true, disabled = args[16] or false, switchMode = args[15] or false, type = 'button',x= args[3],y=args[4],name = args[2],colorbg= args[8],mode=args[13],colorfg = args[9],colorbgp = args[10],colorfgp= args[11],text=args[7]})
  elseif args[1] == 'image' then
    table.insert(game.screen,{visible = args[6], type = 'image',x=args[3],y=args[4],image=args[5],name = args[2]})
  elseif args[1] == 'animation' then
    table.insert(game.screen,{visible = args[7],stage=0,type='animation',x=args[3],y=args[4],name=args[2],atlas=require('imageAtlas').init(args[5],args[6])})
    opengames.fixAtlas(game.screen[#game.screen])
  end
end
function opengames.Instance.remove(thing)
	if type(thing) == 'number' then
	  if not opengames.game.screen[thing] then return false end
	elseif type(thing) == 'string' then
			_,thing = opengames.find(opengames.game.screen,thing)
	  if not opengames.game.screen[thing] then return false end
	elseif type(thing) == 'table' then
	  thing = opengames.find(opengames.game.screen,thing)
	  if not opengames.game.screen[thing] then return false end
	end
  opengames.game.screen[thing].visible = false
  opengames.draw()
  table.remove(opengames.game.screen,thing)
  opengames.cleanBuffers()
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
local function cp(ind,n) -- Changing params, not club penguin
		local game = opengames.game
		game.screen[ind].raw[n] = game.screen[ind][n]
end
local function getS(ind,n)
		local game = opengames.game
		return game.screen[ind][n]
end
local function getB(ind,n)
		local game = opengames.game
		local tmp = game.screen.buffer[ind][n]
		if not tmp then
				return nil
		else
				return tmp
		end
end
local function getR(ind)
		local game = opengames.game
		return game.screen[ind].raw
end
local function getBW(name)
		local game = opengames.game
		return game.window.buffer[name]
end
local function execute(path,...)
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
function opengames.draw(fromZero)
		local game = opengames.game
		local screen = opengames.container
    local ABN = opengames.ABN
		local gamepath = opengames.gamepath
    if fromZero then
      if opengames.win then
        opengames.win:removeChildren()
      end
     opengames.ABN = false
     opengames.BG = opengames.container:addChild(GUI.panel(1,1,game.window.width,game.window.height,game.window.color))
     opengames.TITLE = opengames.container:addChild(GUI.text(math.floor(game.window.width/2-#game.window.title/2),1,game.window.titleColor,game.window.title))
    end
		local BG = opengames.BG
		local TITLE = opengames.TITLE
		if game.window.width ~= getBW('width') then
				BG.width = game.window.width
				TITLE.localX = math.floor(game.window.width/2-string.len(game.window.title)/1.5/2)
		end
		if game.window.height ~= getBW('height') then
				BG.height = game.window.height
		end
		if game.window.color ~= getBW('color') then
				BG.colors.background = game.window.color
		end
		if game.window.title ~= getBW('title') then
				TITLE.text = game.window.title
				TITLE.localX = math.floor(game.window.width/2-string.len(game.window.title)/1.5/2)
		end
		if game.window.titleColor ~= getBW('titleColor') then
				TITLE.color = game.window.titleColor
		end
		if game.window.abn ~= getBW('abn') then
				if game.window.abn == true then
            if not opengames.ABN then
  						opengames.ABN = opengames.container:addChild(GUI.actionButtons(2,2,false))
              if not opengames.isEditor then
    						opengames.ABN.close.onTouch = function()
    								opengames.win:remove()
    						end
    						opengames.ABN.minimize.onTouch = function()
    								opengames.win:minimize()
    						end
              end
            end
				else
						opengames.ABN:remove()
            opengames.ABN = false
				end
		end
		if not game.localization then
				game.localization = {}
		end
    print(game.screen)
		for i = 1, #game.screen do
					if game.screen.buffer[i] == nil then
							game.screen.buffer[i] = {visible = false}
					end
					if game.storage.buffer[i] == nil then
							game.storage.buffer[i] = {}
					end
					if game.screen[i].text then
							local tbl = {}
							for part in string.gmatch(game.screen[i].text,"[^ ]+") do
							  table.insert(tbl, part)
							end
							if tbl[1] == '{loc}' or tbl[1] == '{localization}' then
									text = game.localization[tbl[2]]
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
									textph = game.localization[tbl[2]]
							else
									textph = game.screen[i].textph
							end
					end
					if getS(i,'type') == 'text' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.text(getS(i,'x'),getS(i,'y'),getS(i,'color'),text))
											game.screen[i].raw = tmp
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'text') ~= getB(i,'text') then
					 		cp(i,'text')
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'color') ~= getB(i,'color') then
	  					cp(1,'color')
							end
					end
					if getS(i,'type') == 'button' then
								local function create(i)
											if getS(i,'mode') == 'default' then
													tmp = screen:addChild(GUI.button(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'height'),getS(i,'colorbg'),getS(i,'colorfg'),getS(i,'colorbgp'),getS(i,'colorfgp'),text))
											elseif getS(i,'mode') == 'framedButton' then
													tmp = screen:addChild(GUI.framedButton(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'height'),getS(i,'colorbg'),getS(i,'colorfg'),getS(i,'colorbgp'),getS(i,'colorfgp'),text))
											elseif getS(i,'mode') == 'roundedButton' then
													tmp = screen:addChild(GUI.roundedButton(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'height'),getS(i,'colorbg'),getS(i,'colorfg'),getS(i,'colorbgp'),getS(i,'colorfgp'),text))
											end
											game.screen[i].raw = tmp
											getR(i).index = i
											getR(i).disabled = getS(i,'disabled')
											getR(i).animated = getS(i,'animated')
											getR(i).switchMode = getS(i,'switchMode')
											getR(i).animated = false
											if opengames.isEditor == false then
													getR(i).onTouch = function(_,tmp) 
							  						execute(game.screen[tmp.index].onTouch,tmp.index)
													end
											end
								end
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											create(i)
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'mode') ~= getB(i,'mode') then
								getR(i):remove()
					 		create(i)
							end
							if getS(i,'text') ~= getB(i,'text') then
					 		cp(i,'text')
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'disabled') ~= getB(i,'disabled') then
		  				getR(i).disabled = getS(i,'disabled')
							end
							if getS(i,'animated') ~= getB(i,'animated') then
		  				getR(i).animated = getS(i,'animated')
							end
							if getS(i,'switchMode') ~= getB(i,'switchMode') then
		  				getR(i).switchMode = getS(i,'switchMode')
							end
							if getS(i,'height') ~= getB(i,'height') then
	  					getR(i).height = getS(i,'height')
							end
							if getS(i,'width') ~= getB(i,'width') then
	  					getR(i).width = getS(i,'width')
							end
							if getS(i,'colorbg') ~= getB(i,'colorbg') then
	  					getR(i).colors.default.background = getS(i,'colorbg')
							end
							if getS(i,'colorbgp') ~= getB(i,'colorbgp') then
	  					getR(i).colors.pressed.background = getS(i,'colorbgp')
							end
							if getS(i,'colorfg') ~= getB(i,'colorfg') then
	  				 getR(i).colors.default.text = getS(i,'colorfg')
							end
							if getS(i,'colorfgp') ~= getB(i,'colorfgp') then
	  					getR(i).colors.pressed.text = getS(i,'colorfgp')
							end
					end
					if getS(i,'type') == 'image' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											game.screen[i].raw = screen:addChild(GUI.image(getS(i,'x'),getS(i,'y'),loadImage(getS(i,'image'))))
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  			  	getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  			  	getR(i).localY = getS(i,'y')
							end
							if getS(i,'image') ~= getB(i,'image') then
	             getR(i).image = loadImage(getS(i,'image'))
				  	  end
				  	  local idk = nil
       for e = 1,#game.storage do
         if game.storage[e].name == getS(i,'image') then
           if game.storage[e].path == game.storage.buffer[e].path then
             idk = 1
           else
             opengames.clearImageCashe(getR(i,'image'))
           end
         end
       end
       if idk == nil then getR(i).image = loadImage(getS(i,'image')) end
					end
					if getS(i,'type') == 'animation' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
									  game.screen[i].stage = game.screen[i].stage - 1
											game.screen[i].raw = screen:addChild(GUI.image(getS(i,'x'),getS(i,'y'),image.load('/Icons/HDD.pic')))
									  game.screen[i]:tick()
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'atlas') ~= getB(i,'atlas') then
							  game.screen[i].stage = 0
							  game.screen[i]:tick()
				  	end
					end
					if getS(i,'type') == 'input' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.input(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'height'),getS(i,'colorbg'),getS(i,'colorfg'),getS(i,'colorph'),getS(i,'colorbgp'),getS(i,'colorfgp'),text,textph))
											game.screen[i].raw = tmp
											getR(i).index = i
											getR(i).onInputFinished = function(_,tmp)
													game.screen[tmp.index].text = tmp.text
													if opengames.isEditor == true then
															game.screen[tmp.index].text = tmp.text
															drawparams(game.screen[tmp.index])
													else
							  						execute(game.screen[tmp.index].onInputEnded,tmp.index)
													end
											end
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'text') ~= getB(i,'text') then
					 		cp(i,'text')
							end
							if getS(i,'textph') ~= getB(i,'textph') then
					 		getR(i).placeholderText = getS(i,'textph')
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'height') ~= getB(i,'height') then
	  					getR(i).height = getS(i,'height')
							end
							if getS(i,'width') ~= getB(i,'width') then
	  					getR(i).width = getS(i,'width')
							end
							if getS(i,'colorbg') ~= getB(i,'colorbg') then
	  					getR(i).colors.default.background = getS(i,'colorbg')
							end
							if getS(i,'colorbgp') ~= getB(i,'colorbgp') then
	  					getR(i).colors.focused.background = getS(i,'colorbgp')
							end
							if getS(i,'colorfg') ~= getB(i,'colorfg') then
	  				 getR(i).colors.default.text = getS(i,'colorfg')
							end
							if getS(i,'colorfgp') ~= getB(i,'colorfgp') then
	  					getR(i).colors.focused.text = getS(i,'colorfgp')
							end
							if getS(i,'colorph') ~= getB(i,'colorph') then
	  					getR(i).colors.placeholderText = getS(i,'colorph')
							end
					end
					if getS(i,'type') == 'switch' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.switch(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'colorp'),getS(i,'colors'),getS(i,'colorpp'),getS(1,'state')))
											game.screen[i].raw = tmp
											getR(i).index = i
											getR(i).onStateChanged = function(tmp)
										 		game.screen[tmp.index].state = tmp.state
													if opengames.isEditor == true then
										 				game.screen[tmp.index].state = tmp.state
											 			drawparams(game.screen[tmp.index])
													else
										 				game.screen[tmp.index].state = tmp.state
							  						execute(game.screen[tmp.index].onStateChanged,tmp.index)
													end
											end
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'width') ~= getB(i,'width') then
		  				cp(i,'width')
							end
							if getS(i,'colorp') ~= getB(i,'colorp') then
		  				getR(i).colors.active = getS(i,'colorp')
							end
							if getS(i,'colors') ~= getB(i,'colors') then
		  				getR(i).colors.passive = getS(i,'colors')
							end
							if getS(i,'colorpp') ~= getB(i,'colorpp') then
		  				getR(i).colors.pipe = getS(i,'colorpp')
							end
							if getS(i,'state') ~= getB(i,'state') then
		  				getR(i):setState(getS(i,'state'))
							end
					end
					if getS(i,'type') == 'panel' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.panel(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'height'),getS(i,'color')))
											game.screen[i].raw = tmp
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'width') ~= getB(i,'width') then
		  				cp(i,'width')
							end
							if getS(i,'height') ~= getB(i,'height') then
		  				cp(i,'height')
							end
							if getS(i,'color') ~= getB(i,'color') then
		  				getR(i).colors.background = getS(i,'color')
							end
					end
					if getS(i,'type') == 'colorSelector' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.colorSelector(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'height'),getS(i,'color'),text))
											game.screen[i].raw = tmp
											getR(i).index = i
											getR(i).onColorSelected = function(_,tmp)
													game.screen[tmp.index].color = tmp.color
													if opengames.isEditor == false then
							  						execute(gamepath..'/Scripts/'..game.screen[tmp.index].path,tmp.index)
													else
															drawparams(game.screen[tmp.index])
											  end
											end
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'width') ~= getB(i,'width') then
		  				cp(i,'width')
							end
							if getS(i,'height') ~= getB(i,'height') then
		  				cp(i,'height')
							end
							if getS(i,'text') ~= getB(i,'text') then
		  				cp(i,'text')
							end
							if getS(i,'color') ~= getB(i,'color') then
		  				getR(i).color = getS(i,'color')
							end
					end
					if getS(i,'type') == 'slider' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.slider(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'colorp'),getS(i,'colors'),getS(i,'colorpp'),getS(i,'colorv'),getS(i,'minv'),getS(i,'maxv'),getS(i,'value'),true))
											game.screen[i].raw = tmp
											getR(i).index = i
											getR(i).onValueChanged = function(_,tmp)
											  game.screen[tmp.index].value = tmp.value
													if opengames.isEditor == true then
													  game.screen[tmp.index].value = tmp.value
													  drawparams(game.screen[tmp.index])
											  else
															execute(game.screen[tmp.index].path,tmp.index)
											  end
											end
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'minv') ~= getB(i,'minv') then
		  				getR(i).minimumValue = getS(i,'minv')
							end
							if getS(i,'maxv') ~= getB(i,'maxv') then
		  				getR(i).maximumValue = getS(i,'maxv')
							end
							if getS(i,'value') ~= getB(i,'value') then
		  				getR(i).value = getS(i,'value')
							end
							if getS(i,'width') ~= getB(i,'width') then
		  				cp(i,'width')
							end
							if getS(i,'colorp') ~= getB(i,'colorp') then
		  				getR(i).colors.pipe = getS(i,'colorp')
							end
							if getS(i,'colorv') ~= getB(i,'colorv') then
		  				getR(i).colors.value = getS(i,'colorv')
							end
							if getS(i,'colorpp') ~= getB(i,'colorpp') then
		  				getR(i).colors.passive = getS(i,'colorpp')
							end
							if getS(i,'colors') ~= getB(i,'colors') then
		  				getR(i).colors.active = getS(i,'colors')
							end
					end
					if getS(i,'type') == 'progressIndicator' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.progressIndicator(getS(i,'x'),getS(i,'y'),getS(i,'colorpa'),getS(i,'colorp'),getS(i,'colors')))
											game.screen[i].raw = tmp
											game.screen[i].active = false
											game.screen[i].roll = function(self)
													if self.active == true then
															self.raw:roll()
													end
											end
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'active') ~= getB(i,'active') then
		  				game.screen[i].active = getS(i,'active')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'colorp') ~= getB(i,'colorp') then
		  				getR(i).colors.primary = getS(i,'colorp')
							end
							if getS(i,'colorpa') ~= getB(i,'colorpa') then
		  				getR(i).colors.passive = getS(i,'colorpa')
							end
							if getS(i,'colors') ~= getB(i,'colors') then
		  				getR(i).colors.secondary = getS(i,'colors')
							end
					end
					if getS(i,'type') == 'progressBar' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.progressBar(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'colorp'),getS(i,'colors'),getS(i,'colorv'),getS(i,'value'),true))
											game.screen[i].raw = tmp
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'width') ~= getB(i,'width') then
		  				cp(i,'width')
							end
							if getS(i,'value') ~= getB(i,'value') then
		  				cp(i,'value')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'colorp') ~= getB(i,'colorp') then
		  				getR(i).colors.active = getS(i,'colorp')
							end
							if getS(i,'colorv') ~= getB(i,'colorv') then
		  				getR(i).colors.value = getS(i,'colorv')
							end
							if getS(i,'colors') ~= getB(i,'colors') then
		  				getR(i).colors.passive = getS(i,'colors')
							end
					end
					if getS(i,'type') == 'comboBox' then
							if getS(i,'visible') ~= getB(i,'visible') then
									if getS(i,'visible') == true then
											local tmp = screen:addChild(GUI.comboBox(getS(i,'x'),getS(i,'y'),getS(i,'width'),getS(i,'elh'),getS(i,'colorbg'),getS(i,'colort'),getS(i,'colorabg'),getS(i,'colorat')))
											game.screen[i].raw = tmp
											getR(i).index = i
						     for e = 1,#getS(i,'items') do
						       tmp:addItem(getS(i,'items')[e].name,getS(i,'items')[e].active)
						     end
									else
                      if getR(i) then
											  getR(i):remove()
                      end
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'width') ~= getB(i,'width') then
		  				cp(i,'width')
							end
							if getS(i,'elh') ~= getB(i,'elh') then
		  					getR(i).itemHeight = getS(i,'elh')
		  					getR(i).height = getS(i,'elh')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if #getS(i,'items') ~= #getS(i,'items') then
									getR(i):clear()
						   for e = 1,#getS(i,'items') do
						     local tmp = getR(i):addItem(getS(i,'items')[e].name,getS(i,'items')[e].active)
						     tmp.index = e
						     tmp.onTouch = function(tmp,tmp01)
													execute(game.screen[i].items[tmp01.index].path,tmp.index,tmp01.index)
						     end
						   end
							end
							if getS(i,'colort') ~= getB(i,'colort') then
		  				getR(i).colors.default.text = getS(i,'colort')
							end
							if getS(i,'colorbg') ~= getB(i,'colorbg') then
		  				getR(i).colors.default.background = getS(i,'colorbg')
							end
							if getS(i,'colorat') ~= getB(i,'colorat') then
		  				getR(i).colors.arrow.text = getS(i,'colorat')
							end
							if getS(i,'colorabg') ~= getB(i,'colorabg') then
		  				getR(i).colors.arrow.background = getS(i,'colorabg')
							end
					end
		end
    opengames.updateBuffers()
end
function opengames.getObject(index)
		if type(index) == 'number' then
				return opengames.game.screen[index]
		elseif type(index) == 'string' or type(index) == 'table' then
		  object,_ = opengames.find(opengames.game.screen,index)
		  return object
		end
end
function opengames.getScript(index)
		if type(index) == 'number' then
				return opengames.game.scripts[index]
		elseif type(index) == 'string' or type(index) == 'table' then
		  object,_ = opengames.find(opengames.game.scripts,index)
		  return object
		end
end
function opengames.getStorageEl(index)
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
  opengames.cashe = {images={},scripts={}}
end
function opengames.clearImageCashe(imageName)
  opengames.cashe.images[imageName] = nil
end
function opengames.clearScriptCashe(scriptName)
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
  result,_ = opengames.find(eventObject.scripts,name)
  result.time_end = 1
end
function opengames.cleanBuffers()
  local game = opengames.game
  game.screen.buffer = {}
  game.scripts.buffer = {}
  game.storage.buffer = {}
  game.window.buffer = {}
end
function opengames.updateBuffers()
  local game = opengames.game
	game.screen.buffer = table.copy(game.screen)
	game.window.buffer = table.copy(game.window)
	game.storage.buffer = table.copy(game.storage)
end
function opengames.cleanScreenBufferObj(i)
  table.remove(opengames.game.screen.buffer,i)
end
function opengames.cleanStorageBufferObj(i)
  table.remove(opengames.game.storage.buffer,i)
end
function opengames.cleanScreenBufferObj(i)
  table.remove(opengames.game.screen.buffer,i)
end
function opengames.cleanScreenBuffer()
  opengames.game.screen.buffer = {}
end
function opengames.cleanStorageBuffer()
  opengames.game.storage.buffer = {}
end
function opengames.cleanScriptsBuffer()
  opengames.game.scripts.buffer = {}
end
function opengames.cleanWindowBuffer()
  opengames.game.window.buffer = {}
end
function opengames.loadScene(sceneName)
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
    opengames.cleanBuffers()
    opengames.draw(true)
    opengames.cleanBuffers()
    opengames.draw()
  else
    return false, 'Scene does not exists xdd'
  end
  return true
end
function opengames.colide(obj1,obj2)
  if not obj1 and obj2 then
    return false
  end
  if obj1.raw:isPointInside(obj2.raw.x,obj2.raw.y) then
    return true
  else
    return false
  end
end
function opengames.colideWW(object) -- colide With Who
  local returnTable = {}
  for i = 1,#opengames.game.screen do
    if opengames.colide(object,opengames.game.screen[i]) then
      table.insert(returnTable,opengames.game.screen[i])
    end
  end
  return returnTable
end
function opengames.playAnimation(object,speed)
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

return opengames
