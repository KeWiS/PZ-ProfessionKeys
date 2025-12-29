ProfessionKeysLogic = ProfessionKeysLogic or {}

PROFESSION_KEYS_BUILDINGS = {
    POLICE_STATION = {
        profession = "policeofficer",
        name = "Police Station",
        rooms = {
            policestorage = true,
            policelocker = true,
            policeoffice = true
        }
    },
    FIRE_STATION = {
        profession = "fireofficer",
        name = "Fire Station",
        rooms = {
            firestorage = true,
            firegarage = true
        }
    }
}

local KEY_MESSAGES = {
    "You notice a familiar key on you.",
    "You find the right key for this building.",
    "You must have had this key already.",
}
local MODDATA_KEY = "ProfessionKeys"

local ProfessionKeysLastBuilding = {}

function ProfessionKeysLogic.getBuildingDefForProfession(profession)
    for _, def in pairs(PROFESSION_KEYS_BUILDINGS) do
        if def.profession == profession then
            return def
        end
    end
    return nil
end

local function getModData()
    return ModData.getOrCreate(MODDATA_KEY)
end

function ProfessionKeysLogic.keyAlreadyGenerated()
    local storedId = getModData().professionBuildingId

    if storedId then
        return true
    end

    return false
end

function ProfessionKeysLogic.isValidPlayer(player, buildingName)
    if not player then
        ProfessionKeysLogger.log(buildingName, "Player is nil.")
        return false
    end

    if player:isDead() then
        ProfessionKeysLogger.log(buildingName, "Player is dead.")
        return false
    end

    return true
end

local function getBuildingRooms(building, buildingName)
    local def = building:getDef()
    if not def then
        ProfessionKeysLogger.log(buildingName, "Building def is nil.")
        return
    end

    local rooms = def:getRooms()
    if not rooms then
        ProfessionKeysLogger.log(buildingName, "No rooms found.")
        return
    end

    return rooms
end

local function getBuildingCache()
    local modData = getModData()
    modData.buildingCache = modData.buildingCache or {}

    return modData.buildingCache
end

local function isProfessionBuilding(building, buildingDefinition)
    local rooms = getBuildingRooms(building, buildingDefinition.name)

    if not rooms then return false end

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        local name = room:getName()

        if name then
            local roomNameLower = string.lower(name)
            ProfessionKeysLogger.log(buildingDefinition.name, "Room found: " .. roomNameLower)

            if buildingDefinition.rooms[roomNameLower] then
                ProfessionKeysLogger.log(buildingDefinition.name, "Valid room detected: " .. roomNameLower)

                return true
            end
        end
    end

    ProfessionKeysLogger.log(buildingDefinition.name, "No rooms found for required building type.")

    return false
end

local function isProfessionBuildingCached(building, buildingDefinition)
    local cache = getBuildingCache()
    local keyId = building:getDef():getKeyId()

    if cache[keyId] and cache[keyId]["profession"] == buildingDefinition.profession then
        ProfessionKeysLogger.log(buildingDefinition.name, "Reading building classification from cache.")
        return cache[keyId].classification
    end

    local calculatedClassification = isProfessionBuilding(building, buildingDefinition)
    cache[keyId] = {
        classification = calculatedClassification,
        profession = buildingDefinition.profession
    }

    return calculatedClassification
end

function ProfessionKeysLogic.checkBuildingCorrectness(building, playerId, buildingDefinition)
    if not building or ProfessionKeysLastBuilding[playerId] == building then
        return false
    end

    ProfessionKeysLastBuilding[playerId] = building

    ProfessionKeysLogger.log(buildingDefinition.name, "Player entered new building.")

    if not isProfessionBuildingCached(building, buildingDefinition) then
        ProfessionKeysLogger.log(buildingDefinition.name, "Entered building is NOT character profession building.")
        return false
    end

    return true
end

local function storeProfessionBuildingId(buildingId)
    ProfessionKeysLogger.logOnlyMessage("Storing buildingId in ModData: " .. buildingId)
    getModData().professionBuildingId = buildingId
end

local function showFoundKeyMessage(player)
    player:addLineChatElement(KEY_MESSAGES[ZombRand(#KEY_MESSAGES) + 1])
end

function ProfessionKeysLogic.createAndAssignBuildingKey(building, player, buildingName)
    local keyId = building:getDef():getKeyId()
    local key = player:getInventory():AddItem("Base.Key1")

    key:setKeyId(keyId)
    key:setName("Key - " .. buildingName)

    if keyId and key then
        storeProfessionBuildingId(keyId)
        showFoundKeyMessage(player)
        ProfessionKeysLogger.log(buildingName, "Key given with keyId: " .. keyId)
    else
        ProfessionKeysLogger.log(buildingName, "Failed to create key item.")
    end
end
