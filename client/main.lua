local engineRunning = false
local isInVehicle = false
local currentVehicle = nil

RegisterCommand(Config.Command, function()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local engineStatus = GetIsVehicleEngineRunning(vehicle)

	engineRunning = not engineStatus

	SetVehicleEngineOn(vehicle, engineRunning, true, true)
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

			SetVehicleEngineOn(currentVehicle, engineRunning, true, true)
		elseif isInVehicle and not IsPedInAnyVehicle(playerPed, true) then
			isInVehicle = false

			SetVehicleEngineOn(currentVehicle, engineRunning, true, true)
		end
	end
end)
