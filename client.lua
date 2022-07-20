
local entity = nil
local startingCam = nil
local endingCam = nil
local isCameraMoving = false
local selectedSpawn = vector4(453.4804, -651.4335,  28.23122, 341.99298095703)

AddEventHandler("playerSpawned", function()
    local lastLoc = nil -- Using your framework get the player's last location (vector4) 
    TriggerEvent('tb_spawn_selector:turnOnSpawnSelector', lastLoc)
end)

local function SpawnPed(entity, location)
    SetEntityCoords(entity, location.x, location.y, location.z, false, false, false, false)
    SetEntityHeading(entity, location.w)
end

local function closeSpawnSelectorAndSpawnPlayer(entity, location)
    -- Spawning Player
    SpawnPed(entity, location)
    
    DoScreenFadeOut(500)
    Citizen.Wait(3000)

    -- Closing NUI
    SetNuiFocus(false, false)

    SetEntityVisible(entity, true) -- Setting player to be visible
    SetEntityCollision(myPed, true, true) -- Set collision (hide player from others in places like MP interiors)
    NetworkSetEntityInvisibleToNetwork(entity, false) -- Removing invisibility
    SetEntityInvincible(myPed, false) -- Removing invincible

    -- Removing camera
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    RenderScriptCams(false, false, 500, true, true)
    
    -- Displaying back the rader
    DisplayRadar(true)

    DoScreenFadeIn(500)
end

RegisterNetEvent('tb_spawn_selector:turnOnSpawnSelector', function(lastLocation)
    -- Getting player's ped
    entity = PlayerPedId()

    -- Setting player coords
    SpawnPed(entity, Config.selectingSpawnLocation)

    if lastLocation ~= nil then
        Config.spawnLocations["lastLocation"] = {}
        Config.spawnLocations["lastLocation"].coords = lastLocation
        Config.spawnLocations["lastLocation"].label = "Last Location"

    end

    -- Opening NUI
    SendNUIMessage({
        type = 'openSpawnSelector',
        spawnLocations = Config.spawnLocations,
    })

    SetNuiFocus(true, true)
    
    SetEntityVisible(entity, false) -- Setting player to be invisible
    SetEntityCollision(myPed, false, false) -- Set collision (hide player from others in places like MP interiors)
    NetworkSetEntityInvisibleToNetwork(entity, true) -- Setting invisibility
    SetEntityInvincible(myPed, true) -- Set invincible

    -- Creating cameras
    startingCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.spawnSelectorPos.x, Config.spawnSelectorPos.y, Config.spawnSelectorPos.z, 350.00,0.00,175.00, 90.00, false, 0)
    SetCamActive(startingCam, true)
    RenderScriptCams(true, false, 1, true, true)

    -- Hiding Radar
    DisplayRadar(false)
end)

RegisterNUICallback('playerSelectedSpawnLocation', function(data, cb)
    if isCameraMoving == false then
        isCameraMoving = true;
        endingCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.spawnLocations[data.location].coords.x, Config.spawnLocations[data.location].coords.y, Config.spawnLocations[data.location].coords.z + 1500, 350.00,0.00,175.00, 90.00, false, 0)
        PointCamAtCoord(endingCam, Config.spawnLocations[data.location].coords.x, Config.spawnLocations[data.location].coords.y, Config.spawnLocations[data.location].coords.z)
        SetCamActiveWithInterp(endingCam, startingCam, 7000, true, true)

        SpawnPed(entity, Config.spawnLocations[data.location].coords)

        startingCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.spawnLocations[data.location].coords.x, Config.spawnLocations[data.location].coords.y, Config.spawnLocations[data.location].coords.z + 30, 300.00,0.00,0.00, 110.00, false, 0)
        PointCamAtCoord(startingCam, Config.spawnLocations[data.location].coords.x, Config.spawnLocations[data.location].coords.y, Config.spawnLocations[data.location].coords.z)
        SetCamActiveWithInterp(startingCam, endingCam, 10000, true, true)
        selectedSpawn = Config.spawnLocations[data.location]
        Citizen.Wait(10000)
        isCameraMoving = false;
    else
        cb("The camera is currently moving!\nPlease wait until she will stop.")
    end
end)

RegisterNUICallback('spawnPlayer', function (_, cb)
    -- Creating the last camera
    endingCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", selectedSpawn.coords.x, selectedSpawn.coords.y, selectedSpawn.coords.z, 350.00,0.00,175.00, 90.00, false, 0)
    SetCamActiveWithInterp(endingCam, startingCam, 10000, true, true)
    Citizen.Wait(10000)

    closeSpawnSelectorAndSpawnPlayer(entity, selectedSpawn.coords)
end)

--[[ RegisterCommand('spawnSelector', function() -- For tests only
    local lastLoc = nil -- Using your framework get the player's last location (vector4)
    TriggerEvent('turnOnSpawnSelector', lastLoc)
end) ]]