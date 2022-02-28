local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local vRPclient = Tunnel.getInterface("vRP")
local heyy = {}
Tunnel.bindInterface("heyy_vipcode",heyy)

local cooldown = {}

function heyy.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, "manager.permissao") then
		if cooldown[user_id] and os.time() - cooldown[user_id] < 600 then
			TriggerClientEvent("Notify",source,"negado","Você precisa aguardar <b>" .. segundos .. " segundos</b> para utilizar isto novamente.")
		end
		return true
	end
	TriggerClientEvent("Notify",source,"negado","Você não tem permissão para executar este comando!<br/>Você pode <b>adquirir este acesso</b> através do site")
	return false
end

function heyy.selectSkin(selectedSkin)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, "manager.permissao") then
		if selectedSkin then
			local contagem = {}
			local skin
			for _, skinData in pairs(skins) do
				if skinData.model == selectedSkin then
					skin = skinData
					break
				end
			end

			if not skin then
				DropPlayer(source, "Você selecionou uma skin que não está disponível no menu")
				vRP.setBanned(user_id, true)
				sendInvalidSelectionLog(user_id, selectedSkin)
				return 403
			end
			sendSkinSelectedLog(user_id, skin)
			return 200
		end
	end
	return 403
end

function sendSkinSelectedLog(user_id, skinData)
	local embed = {
		{
			["title"] = "Skin selecionada",
			["description"] = 
				"**Usuário**: " .. user_id .. 
				"\n**Skin selecionada:** " .. skinData.name .. " (`" .. skinData.model .. "`)",
			["image"] = {
				url = tostring(skinData.image)
			},
		}
	}
	PerformHttpRequest('https://canary.discord.com/api/webhooks/947924251283959818/TTg2hMfeeyRcB6fAj3m0IyNOWix-PqAAWX02Jdo1LV4_MeVxYpnbZAyk0OdX776hmjkA', function(err, text, headers) end, 'POST', json.encode({ embeds = embed}), { ['Content-Type'] = 'application/json' })
end
function sendInvalidSelectionLog(user_id, skinName)
	local embed = {
		{
			["color"] = 16734296,
			["title"] = "Skin inválida selecionada",
			["description"] = 
			"**Usuário**: " .. user_id .. 
			"\n**Skin selecionada:** " .. skinName,
		}
	}
	PerformHttpRequest('https://canary.discord.com/api/webhooks/947924251283959818/TTg2hMfeeyRcB6fAj3m0IyNOWix-PqAAWX02Jdo1LV4_MeVxYpnbZAyk0OdX776hmjkA', function(err, text, headers) end, 'POST', json.encode({ embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
	print("^2[heyy_skinselector] ^7Sistema iniciado com sucesso!")
end)