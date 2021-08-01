

local charPed = nil

Citizen.CreateThread(function() 
    while QBCore == nil do
            
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('qb-multicharacter:client:chooseChar')
			return
		end
	end
end)

Config = {
    PedCoords = vector4(-812.99, 173.29, 76.74, -7.5), 
    HiddenCoords = vector4(-812.23, 182.54, 76.74, 156.5), 
    CamCoords = vector4(-814.02, 179.56, 76.74, 198.5), 
}

--- CODE

local choosingCharacter = false
local cam = nil

function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    choosingCharacter = bool
    skyCam(bool)
end

RegisterNUICallback('closeUI', function()
    openCharMenu(false)
end)

RegisterNUICallback('disconnectButton', function()
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('qb-multicharacter:server:disconnect')
end)

RegisterNUICallback('selectCharacter', function(data)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
end)

RegisterNUICallback('asdasdasdsa', function(data)
    local cData = data.cData
    DeleteEntity(charPed)
end)

RegisterNetEvent('qb-multicharacter:client:closeNUI')
AddEventHandler('qb-multicharacter:client:closeNUI', function()
    SetNuiFocus(false, false)
end)

local Countdown = 1

RegisterNetEvent('qb-multicharacter:client:chooseChar')
AddEventHandler('qb-multicharacter:client:chooseChar', function()
    DeleteEntity(charPed)
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(0.0)
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(GetPlayerPed(-1), 1, 1)
    end
    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScreen()
        disableshit(true)
    end
    ClearScreen()
    Citizen.Wait(0)
    SetEntityCoords(GetPlayerPed(-1), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    local timer = GetGameTimer()
    ShutdownLoadingScreenNui()
	FreezeEntityPosition(GetPlayerPed(-1), true)
    SetEntityVisible(GetPlayerPed(-1), false, false)
    Citizen.CreateThread(function()
        RequestCollisionAtCoord(-812.23, 182.54, 76.74, 156.5)
        while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
            print('Carregando colisão do interior.')
            Wait(0)
        end
    end)
    Citizen.Wait(3500)

    while true do
        ClearScreen()
        Citizen.Wait(0)
        if GetGameTimer() - timer > 5000 then
            SwitchInPlayer(GetPlayerPed(-1))
            ClearScreen()
            CreateThread(function()
                Wait(4000)
            end)

            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
                ClearScreen()
            end
            
            break
        end
    end
    NetworkSetTalkerProximity(0.0)
    openCharMenu(true)
end)

function ClearScreen()
    SetCloudHatOpacity(cloudOpacity)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

function disableshit(bool)
    if bool then
        print('a')
        TriggerEvent('close:ui:hud')
        openCharMenu(false)
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
    else
        TriggerEvent('open:ui:hud')
        openCharMenu(true)
    end
end

function selectChar()
    openCharMenu(true)
end

RegisterNUICallback('cDataPed', function(data)
    local cData = data.cData  
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)

    if cData ~= nil then
        QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
            model = model ~= nil and tonumber(model) or false
            if model ~= nil then
                Citizen.CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    data = json.decode(data)
                    TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)
					TaskGoStraightToCoord(charPed, -813.8,176.14,76.74, 1.0, -1, 1.0, 786603, 1.0)
					Wait(5000)
                    TaskPlayAnim(charPed,"misscarsteal4@aliens","rehearsal_base_idle_director",1.0,-1.0, -1, 1, 1, true, true, true)
                    FreezeEntityPosition(charPed, true)
                end)
            else
                Citizen.CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
        end, cData.citizenid)
    else
        Citizen.CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
    end
end)

RegisterNUICallback('setupCharacters', function()
    QBCore.Functions.TriggerCallback("test:yeet", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
    end)
end)

RegisterNUICallback('removeBlur', function()
    SetTimecycleModifier('default')
end)

RegisterNUICallback('createNewCharacter', function(data)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "Homem" then
        cData.gender = 0
    elseif cData.gender == "Mulher" then
        cData.gender = 1
    elseif cData.gender == "Não-binário" then
        cData.gender = 1
    end

    TriggerServerEvent('qb-multicharacter:server:createCharacter', cData)
    TriggerServerEvent('qb-multicharacter:server:GiveStarterItems')
    Citizen.Wait(500)
end)

RegisterNUICallback('removeCharacter', function(data)
    TriggerServerEvent('qb-multicharacter:server:deleteCharacter', data.citizenid)
    TriggerEvent('qb-multicharacter:client:chooseChar')
end)

function skyCam(bool)
    SetRainLevel(0.0)
    TriggerEvent('qb-weathersync:client:DisableSync')
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(12, 0, 0)

    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -813.46, 178.95, 76.85, 0.0 ,0.0, 174.5, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	ShutdownLoadingScreenNui()
	choosingCharacter = true
    	SetCanAttackFriendly(GetPlayerPed(-1), true, false)
    	NetworkSetFriendlyFireOption(true)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    choosingCharacter = false
    TriggerEvent('qb-multicharacter:client:chooseChar')
end)


-- Logout Function --
RegisterNetEvent('multichar:logout')
AddEventHandler('multichar:logout', function(data)
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(0.0)
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 1, 1)
    end
    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScreen()
        disableshit(true)
    end
    ClearScreen()
    Citizen.Wait(0)
    SetEntityCoords(GetPlayerPed(-1), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    local timer = GetGameTimer()
    ShutdownLoadingScreenNui()
	FreezeEntityPosition(GetPlayerPed(-1), true)
    SetEntityVisible(GetPlayerPed(-1), false, false)
    Citizen.CreateThread(function()
        RequestCollisionAtCoord(-1453.29, -551.6, 72.84)
        while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
            print('[Liq-multicharacter] Loading spawn collision.')
            Wait(0)
        end
    end)
    Citizen.Wait(3500)

    while true do
        ClearScreen()
        Citizen.Wait(0)
        if GetGameTimer() - timer > 5000 then
            SwitchInPlayer(PlayerPedId())
            ClearScreen()
            CreateThread(function()
                Wait(4000)
            end)

            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
                ClearScreen()
            end
            
            break
        end
    end
    NetworkSetTalkerProximity(0.0)
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "logout",
            toggle = true,
        })
        choosingCharacter = true
        skyCam(true)
end)
