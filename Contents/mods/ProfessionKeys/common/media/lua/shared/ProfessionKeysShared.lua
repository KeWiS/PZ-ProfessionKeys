ProfessionKeysShared = ProfessionKeysShared or {}
ProfessionKeysLastBuilding = {}
PROFESSION_KEYS_POLICE_STATION = "Police Station"

local MODDATA_KEY = "ProfessionKeys"

local function getBuildingRooms(building, buildingType)
    if not building then
        ProfessionKeysLogger.log(buildingType, "Building is nil.")
        return
    end

    local def = building:getDef()
    if not def then
        ProfessionKeysLogger.log(buildingType, "Building def is nil.")
        return
    end

    local rooms = def:getRooms()
    if not rooms then
        ProfessionKeysLogger.log(buildingType, "No rooms found.")
        return
    end

    return rooms
end

function ProfessionKeysShared.isPoliceStationBuilding(building)
    local rooms = getBuildingRooms(building, PROFESSION_KEYS_POLICE_STATION)

    if not rooms then return false end

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        local name = room:getName()

        if name then
            local roomNameLower = string.lower(name)
            ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Room found: " .. roomNameLower)

            if roomNameLower == "policestorage"
                or roomNameLower == "policelocker"
                or roomNameLower == "policeoffice" then
                ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Valid room detected: " .. roomNameLower)

                return true
            end
        end
    end

    ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "No rooms found for required building type.")

    return false
end

function ProfessionKeysShared.isCharacterOfProfession(character, profession)
    local prof = character:getDescriptor():getProfession()

    return prof and prof == profession
end

function ProfessionKeysShared.getData()
    return ModData.getOrCreate(MODDATA_KEY)
end

function ProfessionKeysShared.getStoredPoliceStationId()
    local buildingId = ProfessionKeysShared.getData().policeStationBuildingId

    if buildingId then
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Fetching buildingId from ModData: " .. buildingId)
    else
        ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "No buildingId in ModData.")
    end

    return buildingId
end

function ProfessionKeysShared.storePoliceStationId(buildingId)
    ProfessionKeysLogger.log(PROFESSION_KEYS_POLICE_STATION, "Storing buildingId in ModData: " .. buildingId)
    ProfessionKeysShared.getData().policeStationBuildingId = buildingId
end
