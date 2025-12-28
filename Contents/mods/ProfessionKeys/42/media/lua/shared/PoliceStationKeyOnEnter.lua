local PROFESSION_NAME = "policeofficer"

local function isValidPlayer(player)
    if not ProfessionKeysShared.isCharacterOfProfession(player, PROFESSION_NAME) then
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION,
            "Player has not required profession: " .. PROFESSION_NAME)
        return false
    end

    if not player then
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Player is nil.")
        return false
    end

    if player:isDead() then
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Player is dead.")
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
        ProfessionKeysShared.storePoliceStationId(keyId)
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Key given with keyId: " .. keyId)
    else
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Failed to create key item.")
    end
end

local function checkBuildingCorrectness(building, playerId)
    if ProfessionKeysLastBuilding[playerId] == building then
        return false
    end

    ProfessionKeysLastBuilding[playerId] = building

    ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Player entered new building.")

    if not ProfessionKeysShared.isPoliceStationBuilding(building) then
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Building is NOT a police station.")
        return false
    end

    return true
end

local function keyAlreadyGenerated(building)
    local storedId = ProfessionKeysShared.getStoredPoliceStationId()

    if storedId then
        if building:getDef():getKeyId() == storedId then
            ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION,
                "Player entered building for which key has already been generated.")
        else
            ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION,
                "Player entered correct profession building but key has already been generated for different one.")
        end

        return true
    end

    return false
end

local function onPlayerUpdate(player)
    if not isValidPlayer(player) then return end

    local playerId = player:getOnlineID() or player:getPlayerNum()
    local square = player:getSquare()

    if not square then
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Player square is nil.")
        return
    end

    local building = square:getBuilding()

    if checkBuildingCorrectness(building, playerId) and not keyAlreadyGenerated(building) then
        createAndAssignBuildingKey(building, player)
    end
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)
