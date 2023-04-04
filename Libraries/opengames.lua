local opengames = {}
local GUI = require('GUI')
local image = require('Image')
local system = require('System')
local fs = require('filesystem')

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
						ABN = screen:addChild(GUI.actionButtons(1,1,false))
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
							if game.screen[i].text == '{loc}' and game.localization[game.screen[i].name..'_ph'] and opengames.isEditor == false  or game.screen[i].text == '{localization}' and game.localization[game.screen[i].name] and opengames.isEditor == false then
									text = game.localization[game.screen[i].name]
							else
									text = game.screen[i].text
							end
					end
					if game.screen[i].textph then
							if game.screen[i].textph == '{loc}' and game.localization[game.screen[i].name..'_ph'] and opengames.isEditor == false  or game.screen[i].textph == '{localization}' and game.localization[game.screen[i].name..'_ph'] and opengames.isEditor == false then
									textph = game.localization[game.screen[i].name..'_ph']
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
