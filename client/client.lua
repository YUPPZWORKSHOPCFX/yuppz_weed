--===== FiveM Script =========================================
--= weed - YUPPZWORKSHOP CFX (Webhook)
--===== Developed By: ========================================
--= YUPPZWORKSHOP CFX
--= Copyright (C) YUPPZWORKSHOP CFX - All Rights Reserved
--= You are not allowed to sell this script or edit
--============================================================

local spawnedWeeds1 = 0
local spawnedWeeds2 = 0
local weedPlants1 = {}
local weedPlants2 = {}
local isPickingUp1, isPickingUp2, IsProcessing, IsOpenMenu = false, false, false, false
ObjectLists = 0
ObjectArray = {}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
end)


-- Spawn Object
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.Zone1.coords, true) < 50 then
			SpawnWeedPlants1()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end

	end
end)
RegisterNetEvent('yuppz_weed:pickedUpWeed')
AddEventHandler('yuppz_weed:pickedUpWeed', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject1, nearbyID1
	isPickingUp1 = true
	for i=1, #weedPlants1, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants1[i]), false) < 1 then
			nearbyObject1, nearbyID1 = weedPlants1[i], i
		end
	end
	TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
	Citizen.Wait(Config.Time)
	ClearPedTasks(playerPed)
	ESX.Game.DeleteObject(nearbyObject1)
	table.remove(weedPlants1, nearbyID1)
	spawnedWeeds1 = spawnedWeeds1 - 1
	isPickingUp1 = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local letSleep = true
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject1, nearbyID1

		for i=1, #weedPlants1, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants1[i]), false) < 1 then
				nearbyObject1, nearbyID1 = weedPlants1[i], i
			end
		end

		if nearbyObject1 and IsPedOnFoot(playerPed) then
			if not isPickingUp1 then
				letSleep = false
				NOTIFYPREE()
			end
			if IsControlJustReleased(0,38) and not isPickingUp1 then
				progressbar(source)
				if exports.yuppz_check:CheckPolice(Config.Cops) then
					TriggerServerEvent('yuppz_weed:canpickedUp')
				else
					TriggerEvent("pNotify:SendNotification", 
					{text = " ต้องการตำรวจจำนวน "..Config.Cops.." ในเมือง",
					type = "success", timeout = 5000,
					layout = "centerLeft"})
					Wait(5000)
				end
				
			end

		else
			if letSleep then 
				Citizen.Wait(500)
			end
		end

	end

end)

function progressbar(source)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "unique_action_name",
		duration = Config.Time,
		label = Config.Text,
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	})
end


AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants1) do
			ESX.Game.DeleteObject(v)
		end
		for k, v in pairs(weedPlants2) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnWeedPlants1()
	while spawnedWeeds1 < 25 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords1()
		ESX.Game.SpawnLocalObject(Config.Model, vector3(weedCoords.x, weedCoords.y, Config.CircleZones.Zone1.coords.z), function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			table.insert(weedPlants1, obj)
			spawnedWeeds1 = spawnedWeeds1 + 1
		end)
	end
end

function ValidateWeedCoord1(plantCoord)
	if spawnedWeeds1 > 0 then
		local validate = true

		for k, v in pairs(weedPlants1) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.Zone1.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords1()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)

		weedCoordX = Config.CircleZones.Zone1.coords.x + modX
		weedCoordY = Config.CircleZones.Zone1.coords.y + modY

		local coordZ = GetCoordZ(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord1(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0  }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 80
end

