local professionName = "policeofficer"

local function isValidPlayer(player)
    if not ProfessionKeysShared.isCharacterOfProfession(player, professionName) then
        ProfessionKeysLogger.log("Police Station: player has not required profession: " .. professionName)
        return false
    end

    if not player then
        ProfessionKeysLogger.log("Police Station: player is nil")
        return false
    end

    if player:isDead() then
        ProfessionKeysLogger.log("Police Station: player is dead")
        return false
    end

    return true
end

local function createAndAssignBuildingKey(building, player)
    local keyId = building:getDef():getKeyId()
    local key = player:getInventory():AddItem("Base.Key1")

    key:setKeyId(keyId)
    key:setName("Key - Police Station")

    if keyId and key then
        ProfessionKeysLogger.log("Police station key given with keyId: " .. keyId)
    else
        ProfessionKeysLogger.log("Failed to create key item")
    end
end

local function onPlayerUpdate(player)
    if not isValidPlayer(player) then return end

    local id = player:getOnlineID() or player:getPlayerNum()
    local square = player:getSquare()

    if not square then
        ProfessionKeysLogger.log("Police Station: player square is nil")
        return
    end

    local building = square:getBuilding()

    if ProfessionKeysLastBuilding[id] == building then
        return
    end

    ProfessionKeysLastBuilding[id] = building

    ProfessionKeysLogger.log("Police Station: player entered new building")

    if not ProfessionKeysShared.isPoliceStationBuilding(building) then
        ProfessionKeysLogger.log("Police Station: building is NOT a police station")
        return
    end

    createAndAssignBuildingKey(building, player)
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)
