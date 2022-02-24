local engineRunning = false
local isInVehicle = false
local currentVehicle = nil

RegisterCommand(Config.Command, function()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local engineStatus = GetIsVehicleEngineRunning(vehicle)

	engineRunning = not engineStatus

	SetVehicleEngineOn(vehicle, engineRunning, Config.Instantly, Config.DisableAutoStart)
end, false)
RegisterKeyMapping(Config.Command, Config.Control.Name, "keyboard", Config.Control.Key)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()

		if not isInVehicle and IsPedInAnyVehicle(playerPed, true) then
			isInVehicle = true
			currentVehicle = GetVehiclePedIsEntering(playerPed)
			engineRunning = GetIsVehicleEngineRunning(currentVehicle)

			if Config.DisableStartAfter.Entering then
				SetVehicleEngineOn(currentVehicle, engineRunning, Config.Instantly, Config.DisableAutoStart)
			end
		elseif isInVehicle and not IsPedInAnyVehicle(playerPed, true) then
			isInVehicle = false

			SetVehicleEngineOn(currentVehicle, engineRunning, Config.Instantly, Config.DisableAutoStart)
		end

		if Config.DisableStartAfter.PressingW and isInVehicle and not engineRunning then
			DisableControlAction(0, 71, true)
		end
	end
end)

RegisterNetEvent("engine:client:state", function(vehicle, state)
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, true) then
		local _vehicle = vehicle and vehicle or GetVehiclePedIsIn(playerPed, false)

		if currentVehicle == _vehicle then
			engineRunning = state

			SetVehicleEngineOn(currentVehicle, engineRunning, Config.Instantly, Config.DisableAutoStart)
		else
			SetVehicleEngineOn(_vehicle, state, Config.Instantly, Config.DisableAutoStart)
		end
	end
end)
