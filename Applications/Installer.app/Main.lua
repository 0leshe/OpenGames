local GUI = require('GUI')
local fs = require('filesystem')
local system = require('System')
local compressor = require('Compressor')
local paths = {library = '/Libraries/',application='/Applications/'}
local fileMatch = {library = '/data_00',application='/data_01'}
local lc = system.getCurrentScriptLocalization()
local apppath = string.gsub(system.getCurrentScript(),"/Main.lua","/")
local wk,win,menu = system.addWindow(GUI.filledWindow(1,1,75,22,0x989898))
win:addChild(GUI.text(3,4,0x505050,lc.library))
local input01 = win:addChild(GUI.input(3,6,60,3,0x757575,0x505050,0x2D2D2D,0x505050,0x757575,'/Libraries/',lc.libraryph))
input01.onInputFinished = function(_,input01)
  if input01.text == '' then
    input01.text = paths.library
  else
    paths.library = input01.text
  end
end
local browse01 = win:addChild(GUI.roundedButton(65,6,8,3,0x757575,0x505050,0x505050,0x757575,lc.browse))
browse01.onTouch = function()
  local tmp = GUI.addFilesystemDialog(wk,true,50, 30, lc.open,lc.close,lc.path,'/')
  tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_DIRECTORY)
  tmp.onSubmit = function(path)
    paths.library = path
    input01.text = path
  end
  tmp:show()
end
win:addChild(GUI.text(3,10,0x505050,lc.application))
local input02 = win:addChild(GUI.input(3,12,60,3,0x757575,0x505050,0x2D2D2D,0x505050,0x757575,'/Applications/',lc.applicationph))
input02.onInputFinished = function()
  if input02.text == '' then
    input02.text = paths.application
  else
    paths.application = input02.text
  end
end
local browse02 = win:addChild(GUI.roundedButton(65,12,8,3,0x757575,0x505050,0x505050,0x757575,lc.browse))
browse02.onTouch = function()
  local tmp = GUI.addFilesystemDialog(wk,true,50, 30, lc.open,lc.close,lc.path,'/')
  tmp:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_DIRECTORY)
  tmp.onSubmit = function(path)
    paths.application = path
    input02.text = path
  end
  tmp:show()
end
local install = win:addChild(GUI.roundedButton(3,18,71,3,0x757575,0x505050,0x505050,0x757575,lc.install))
install.onTouch = function()
  compressor.unpack(apppath..fileMatch.library,paths.library)
  compressor.unpack(apppath..fileMatch.application,paths.application)
  fs.makeDirectory(paths.application .. '/Editor.app')
  fs.makeDirectory(paths.application .. '/Editor.app/Localizations')
  fs.copy(paths.application..'/Main.lua',paths.application..'/Editor.app/Main.lua')
  fs.copy(paths.application..'/Icon.pic',paths.application..'/Editor.app/Icon.pic')
  fs.copy(paths.application..'/Russian.lang',paths.application..'/Editor.app/Localizations/Russian.lang')
  fs.copy(paths.application..'/English.lang',paths.application..'/Editor.app/Localizations/English.lang')
  fs.copy(paths.application..'/Ukrainian.lang',paths.application..'/Editor.app/Localizations/Ukrainian.lang')
  fs.remove(paths.application..'/Main.lua')
  fs.remove(paths.application..'/Icon.pic')
  fs.remove(paths.application..'/English.lang')
  fs.remove(paths.application..'/Russian.lang')
  fs.remove(paths.application..'/Ukrainian.lang')
  win:removeChildren()
  win:addChild(GUI.panel(1,1,75,22,0x989898))
  win:addChild(GUI.text(28,11,0x505050,lc.done))
  win:addChild(GUI.roundedButton(20,13,45,3,0x757575,0x505050,0x505050,0x757575,lc.exit)).onTouch = function()
    win:remove()
  end
end
