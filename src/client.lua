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
	local skin = data.skin
	local code = heyyServer.selectSkin(skin)
	if code == 200 then
		local health = GetEntityHealth(PlayerPedId())

		RequestModel(skin)
        while not HasModelLoaded(skin) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), skin)
		Wait(1000)
		SetEntityMaxHealth(PlayerPedId(), 400)
		SetEntityHealth(PlayerPedId(), health)
		TriggerEvent("Notify","sucesso","Skin definida com sucesso!")
	end
	cb(code)
end)

RegisterNUICallback("notify", function(data, cb)
	TriggerEvent("Notify",data.type,data.message)
end)

RegisterNUICallback("getAvailableSkins", function(data, cb)
	cb({skins = Config.skins})
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

Citizen.CreateThread(function()
	print("Sistema iniciado com sucesso!")
end)