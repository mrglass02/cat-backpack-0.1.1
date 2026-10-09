local QBCore = exports['qb-core']:GetCoreObject()
local currentBackpackProp = nil
local isAttachedToBack = false

-- Helper function to clean up attached/placed prop
local function RemoveBackpackProp()
    if DoesEntityExist(currentBackpackProp) then
        DeleteEntity(currentBackpackProp)
        currentBackpackProp = nil
    end
    isAttachedToBack = false
end

-- Function to attach prop to player's back (Spine)
local function AttachToBack()
    RemoveBackpackProp()
    local ped = PlayerPedId()
    local model = `a_back_pack_with_a_cat_in_it`

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local coords = GetEntityCoords(ped)
    currentBackpackProp = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
    
    -- Attach to Spine bone (24818) - adjust offset/rotation as needed for your specific ped model
    AttachEntityToEntity(currentBackpackProp, ped, GetPedBoneIndex(ped, 24818), 
        0.0, -0.15, -0.02, 
        0.0, 90.0, 180.0, 
        true, true, false, true, 1, true)

    isAttachedToBack = true
    SetModelAsNoLongerNeeded(model)
end

-- Function to place prop on the ground in front of player
local function PlaceOnGround()
    RemoveBackpackProp()
    local ped = PlayerPedId()
    local model = `a_back_pack_with_a_cat_in_it`

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local forward = GetEntityForwardVector(ped)
    local coords = GetEntityCoords(ped) + (forward * 1.0)
    
    currentBackpackProp = CreateObject(model, coords.x, coords.y, coords.z - 0.9, true, true, false)
    PlaceObjectOnGroundProperly(currentBackpackProp)
    SetEntityHeading(currentBackpackProp, GetEntityHeading(ped))

    SetModelAsNoLongerNeeded(model)
end

-- Event triggered when item is used in QS Inventory
RegisterNetEvent('cat_backpack:client:ToggleBackpack', function()
    if isAttachedToBack then
        RemoveBackpackProp()
        QBCore.Functions.Notify('Removed cat backpack', 'primary')
    else
        AttachToBack()
        QBCore.Functions.Notify('Put on cat backpack', 'success')
    end
end)

-- Command to place the backpack on the ground
RegisterCommand('a_back_pack_with_a_cat_in_it', function()
    PlaceOnGround()
    QBCore.Functions.Notify('Placed cat backpack on the ground', 'primary')
end, false)

-- Cleanup prop when resource stops to avoid persistent invisible/ghost props
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        RemoveBackpackProp()
    end
end)
