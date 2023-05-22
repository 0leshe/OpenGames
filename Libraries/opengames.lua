local opengames = {Instance={}}
local GUI = require('GUI')
local image = require('Image')
local system = require('System')
local fs = require('filesystem')
local userSettings = system.getUserSettings()
local function new(where,what)
  table.insert(where,what)
  for i = 1,#where do
    if where[i].name == what.name and where[i].type == what.type and where[i].x == what.x and where[i].y == what.y then
      drawparams(where[i])
    end
  end
  drawtree()
  draw()
end
function opengames.init(params)
		opengames.isEditor = params.editor or false
		opengames.useImages = params.useImages or true
		if not params.game then
				system.error('Init MUST contain game table.')
		end
		if not params.container then
				system.error('Init MUST contain window or container.')
		end
		if not opengames.isEditor then
				if not params.gamePath then
						system.error('Init MUST contain game path.')
				end
		end
		opengames.gamepath = params.gamePath
		opengames.game = params.game
		opengames.container = params.container
end
function opengames.Instance.new(...)
   local args = {...}
  if args[1] == 'panel' then
    new(game.screen,{visible = args[8],type = 'panel',x=args[3],y= args[4],color= args[7],width = args[5],height= args[6],name =  args[2]})
  elseif args[1] == 'text' then
    new(game.screen,{visible =args[7],type = 'text',x= args[3],y=args[4],color=args[5],text=args[6],name = args[2]})
  elseif args[1] == 'progressBar' then
    new(game.screen,{visible = args[9],width= args[4],colorp = args[5],colors=args[6],colorv=args[7],type = 'progressBar',x=args[3],y=args[4],color= cr1,value=args[8],name = args[2]})
  elseif args[1] == 'comboBox' then
    new(game.screen,{visible = true,type = 'comboBox',width=userSettings.opengames.comboBoxWidth or 20,x=userSettings.opengames.comboBoxX or 1,y=userSettings.opengames.comboBoxY or 1,elh=userSettings.opengames.comboBoxELH or 3,items={{name=userSettings.opengames.comboBoxItemsName or 'Item',active = false,type='itemComboBox',path=''}},colorbg=userSettings.opengames.comboBoxColorBG or cr1,colort=userSettings.opengames.comboBoxColorT or cr2,colorabg=userSettings.opengames.comboBoxColorABG or cr1,colorat=userSettings.opengames.comboBoxColorAT or cr2,name = userSettings.opengames.comboBoxName or 'ComboBox'})
  elseif args[1] == 'slider' then
    new(game.screen,{visible = true,type = 'slider',x=userSettings.opengames.sliderX or 1,y=userSettings.opengames.sliderY or 1,width=userSettings.opengames.sliderWidth or 20,colorp=userSettings.sliderColorP or cr1,colors=userSettings.opengames.sliderColorS or cr2,colorpp=userSettings.opengames.sliderColorPP or cr1,colorv=userSettings.opengames.sliderColorV or cr2,minv=userSettings.opengames.sliderMinv or 1,maxv=userSettings.opengames.sliderMaxv or 100,value=userSettings.opengames.sliderValue or 50,text=userSettings.opengames.sliderText or 'Slider',name = userSettings.opengames.sliderName or 'Slider'})
  elseif args[1] == 'progressIndicator' then
    new(game.screen,{visible = true,type = 'progressIndicator',x=userSettings.opengames.piX or 1,y=userSettings.opengames.piY or 1,active=userSettings.opengames.piActive or false,rollStage=userSettings.opengames.piRollStage or 1,colorp= userSettings.opengames.piColorP or cr1,colors=userSettings.opengames.piColorS or cr2,colorpa=userSettings.opengames.piColorPA or cr3,name = userSettings.opengames.piName or 'pI'})
  elseif args[1] == 'colorSelector' then
    new(game.screen,{visible = true,path='',type = 'colorSelector',color=userSettings.opengames.csColor or 0xFF00FF,x=userSettings.opengames.csX or 1,y=userSettings.opengames.csY or 1,width=userSettings.opengames.csWidth or 20,height=userSettings.opengames.csHeight or 3,text=userSettings.opengames.csText or 'Color Selector',name = userSettings.opengames.csName or 'ColorSelector'})
  elseif args[1] == 'input' then
    new(game.screen,{visible = true,onInputEnded = '',width=userSettings.opengames.inputWidth or 20,height=userSettings.opengames.inputHeight or 3,colorbg = userSettings.opengames.inputColorBG or cr1,colorfg = userSettings.opengames.inputColorFG or cr2,colorfgp = userSettings.opengames.inputColorFGP or cr1,colorbgp = userSettings.opengames.inputColorBGP or cr4,colorph=userSettings.opengames.inputColorPH or 0x2D2D2D,type = 'input',x=userSettings.opengames.inputX or 1,y=userSettings.opengames.inputY or 1,name = userSettings.opengames.inputName or 'Input',text = userSettings.opengames.inputText or 'Input',textph = userSettings.opengames.inputTextPH or 'Text'})
  elseif args[1] == 'switch' then
    new(game.screen,{onStateChanged = userSettings.opengames.switchOnStateChanged or '', visible =userSettings.opengames.switchVisible or true,state=userSettings.opengames.switchState or false,type = 'switch',x=userSettings.opengames.switchX or 1,y=userSettings.opengames.switchY or 1,width=userSettings.switchWidth or 8,colorp= userSettings.opengames.switchColorP or cr2, colors=userSettings.opengames.switchColorS or cr2,colorpp=userSettings.opengames.switchColorPP or cr1,name = userSettings.opengames.switchName or 'Switch'})
  elseif args[1] == 'button' then
    new(game.screen,{visible = args[17],onTouch = args[12], height = args[6],width = args[5], animated = args[14] or true, disabled = args[16] or false, prevMode = 'roundedButton', switchMode = args[15] or false, mode = args[13] or 'default', type = 'button',x= args[3],y=args[4],name = args[2],colorbg= args[8],colorfg = args[9],colorbgp = args[10],colorfgp= args[11],text=args[7]})
  elseif args[1] == 'image' then
    new(game.screen,{visible = true, type = 'image',x=userSettings.opengames.imageX or 1,y=userSettings.opengames.imageY or 1,image=userSettings.opengames.imageImage or 'StorageEl',name = userSettings.opengames.imageName or 'image',path = userSettings.opengames.imagePath or '/MineOS/Icons/HDD.pic'})
  end
end
function table.copy (originalTable)
 local copyTable = {}
  for k,v in pairs(originalTable) do
    copyTable[k] = v
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
		return game.screen.buffer.window[name]
end
function draw()
		local game = opengames.game
		local screen = opengames.container
		local gamepath = opengames.gamepath
		if game.window.width ~= getBW('width') then
				BG.width = game.window.width
		end
		if game.window.height ~= getBW('height') then
				BG.height = game.window.height
		end
		if game.window.color ~= getBW('color') then
				BG.colors.background = game.window.color
		end
		if game.window.title ~= getBW('title') then
				TITLE.text = game.window.title
				TITLE.localX = math.floor(game.window.width/2-#game.window.title/2)
		end
		if game.window.titleColor ~= getBW('titleColor') then
				TITLE.color = game.window.titleColor
		end
		if game.window.abn ~= getBW('abn') then
				if game.window.abn == true then
						ABN = screen:addChild(GUI.actionButtons(2,2,false))
						ABN.close.onTouch = function()
								screen:remove()
						end
						ABN.minimize.onTouch = function()
								screen:minimize()
						end
				else
						ABN:remove()
				end
		end
		if not game.localization then
				game.localization = {}
		end
		for i = 1, #game.screen do
					if game.screen.buffer[i] == nil then
							game.screen.buffer[i] = {visible = false}
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
											game.screen[i].raw:remove()
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
							if getS(i,'visible') ~= getB(i,'visible') then
								function create(i)
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
															if fs.exists(gamepath..'/Scripts/'..game.screen[tmp.index].onTouch) then
							  								system.execute(gamepath..'/Scripts/'..game.screen[tmp.index].onTouch,tmp.index)
															end
													end
											end
								end
									if getS(i,'visible') == true then
											create(i)
									else
											getR(i):remove()
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
			        idk = nil
			        for e = 1,#game.storage do
			          if game.storage[e].name == getS(i,'image') and fs.extension(game.storage[e].path) == '.pic' then
			            idk = game.storage[e].path
			          end
			        end
			        if idk == nil then idk = '/Icons/Script.pic' end
											local tmp = screen:addChild(GUI.image(getS(i,'x'),getS(i,'y'),image.load(idk)))
											game.screen[i].raw = tmp
									else
											getR(i):remove()
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
							if getS(i,'y') ~= getB(i,'y') then
		  				getR(i).localY = getS(i,'y')
							end
							if getS(i,'image') ~= getB(i,'image') then
	        idk = nil
	        for e = 1,#game.storage do
	          if game.storage[e].name == getS(i,'image') and fs.extension(game.storage[e].path) == '.pic' then
	            idk = game.storage[e].path
	          end
	        end
			      if idk == nil then idk = '/Icons/Script.pic' end
	        getR(i).image = image.load(idk)
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
															if fs.exists(gamepath..'/Scripts/'..game.screen[tmp.index].onInputEnded) then
							  								system.execute(gamepath..'/Scripts/'..game.screen[tmp.index].onInputEnded,tmp.index)
															end
													end
											end
									else
											getR(i):remove()
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
															if fs.exists(gamepath..'/Scripts/'..game.screen[tmp.index].onStateChanged) then
							  								system.execute(gamepath..'/Scripts/'..game.screen[tmp.index].onStateChanged,tmp.index)
															end
													end
											end
									else
											getR(i):remove()
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
											getR(i):remove()
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
													if opengames.isEditor == false then
															if fs.exists(gamepath..'/Scripts/'..game.screen[tmp.index].path) then
							  								system.execute(gamepath..'/Scripts/'..game.screen[tmp.index].path,tmp.index)
															end
											  end
											end
									else
											getR(i):remove()
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
															if fs.exists(gamepath..'/Scripts/'..game.screen[tmp.index].path) then
																	system.execute(gamepath..'/Scripts/'..game.screen[tmp.index].path,tmp.index)
															end
											  end
											end
									else
											getR(i):remove()
									end
							end
							if getS(i,'x') ~= getB(i,'x') then
		  				getR(i).localX = getS(i,'x')
							end
		  		if getS(i,'path') ~= getB(i,'path') then
		  				if opengames.isEditor == false then
										opengames[i].script = fs.read(gamepath..'/Scripts/'..game.screen[i].path,tmp.index)
								end
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
											getR(i):remove()
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
											getR(i):remove()
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
											getR(i):remove()
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
													if fs.exists(gamepath..'/Scripts/'..game.screen[i].items[tmp01.index].path) then
															system.execute(gamepath..'/Scripts/'..game.screen[i].items[tmp01.index].path,tmp.index,tmp01.index)
													end
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
		game.screen.buffer = {}
		game.screen.buffer.window = table.copy(game.window)
		for i = 1, #game.screen do
				game.screen.buffer[i] = table.copy(game.screen[i])
		end
end
function find(where,what)
		for i = 1, #where do
				if where[i].name == what then
						return where[i], i
				end
		end
end

return opengames
