local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local heyyServer = Tunnel.getInterface("heyy_vipcode")
--[[
  _    _                   _____              
 | |  | |                 / ____|             
 | |__| | ___ _   _ _   _| |     _______ _ __ 
 |  __  |/ _ \ | | | | | | |    |_  / _ \ '__|
 | |  | |  __/ |_| | |_| | |____ / /  __/ |   
 |_|  |_|\___|\__, |\__, |\_____/___\___|_|   
               __/ | __/ |                    
              |___/ |___/                     

	    Menu de escolha de skin
]]

local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ action = "abrir" })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ action = "fechar" })
	end
end

RegisterNUICallback("selectSkin", function(data, cb)
	local code = heyyServer.selectSkin(data.skin)
	if code == 200 then
		SetPlayerModel(PlayerId(), GetHashKey(data.skin))
	end
	cb()
end)

RegisterNUICallback("notify", function(data, cb)
	TriggerEvent("Notify",data.type,data.message)
end)

RegisterNUICallback("getAvailableSkins", function(data, cb)
	cb({skins = skins})
end)

-- fechar
RegisterNUICallback("close", function(data)
	ToggleActionMenu()
end)

-- /ativar
RegisterCommand('skin',function(source,args,rawCommand)   
    if heyyServer.checkPermission() then
		ToggleActionMenu()
	end
end)