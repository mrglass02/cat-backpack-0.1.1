local placedProps = {} -- Tracks props placed on the ground
local propModel = `a_back_pack_with_a_cat_in_it`

-- Helper function to ensure model is loaded
local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

--------------------------------------------------------------------------------
-- COMMAND: Place Cat Backpack on Ground
--------------------------------------------------------------------------------
RegisterCommand('placecatbackpack', function()
    local ped = PlayerPedId()
    -- Get position slightly in front of the player (0.75 units ahead, lowered to ground level)
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.75, -0.9)
    local heading = GetEntityHeading(ped)

    LoadModel(propModel)
    
    -- Create object as networked so other players can see it
    local spawnedObj = CreateObject(propModel, coords.x, coords.y, coords.z, true, true, true)
    SetEntityHeading(spawnedObj, heading)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetModelAsNoLongerNeeded(propModel)

    -- Add entity handle to tracking list
    table.insert(placedProps, spawnedObj)
    exports['qs-inventory']:Notify("Placed cat backpack on the ground.", "success")
end, false)

--------------------------------------------------------------------------------
-- COMMAND: Undo / Delete Last Placed Backpack
--------------------------------------------------------------------------------
RegisterCommand('undocatbackpack', function()
    if #placedProps > 0 then
        -- Pop the last spawned prop entity from the table
        local lastProp = table.remove(placedProps)
        
        if DoesEntityExist(lastProp) then
            DeleteEntity(lastProp)
            exports['qs-inventory']:Notify("Removed last placed backpack.", "primary")
        end
    else
        exports['qs-inventory']:Notify("No placed backpacks to remove.", "error")
    end
end, false)

--------------------------------------------------------------------------------
-- CLEANUP ON RESOURCE STOP
--------------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, obj in ipairs(placedProps) do
            if DoesEntityExist(obj) then
                DeleteEntity(obj)
            end
        end
    end
end)