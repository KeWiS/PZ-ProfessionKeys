ProfessionKeysShared = ProfessionKeysShared or {}
ProfessionKeysLastBuilding = {}

local function getBuildingRooms(building, buildingType)
    if not building then
        ProfessionKeysLogger.log("isPoliceStationBuilding: building is nil")
        return
    end

    local def = building:getDef()
    if not def then
        ProfessionKeysLogger.log("isPoliceStationBuilding: building def is nil")
        return
    end

    local rooms = def:getRooms()
    if not rooms then
        ProfessionKeysLogger.log("isPoliceStationBuilding: no rooms found")
        return
    end

    return rooms
end

function ProfessionKeysShared.isPoliceStationBuilding(building)
    local buildingType = "Police Station"
    local rooms = getBuildingRooms(building, buildingType)

    if not rooms then return false end

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        local name = room:getName()

        if name then
            local roomNameLower = string.lower(name)
            ProfessionKeysLogger.log("Room found: " .. roomNameLower)

            if roomNameLower == "policestorage"
                or roomNameLower == "policelocker"
                or roomNameLower == "policeoffice" then
                ProfessionKeysLogger.log(buildingType .. " room detected: " .. roomNameLower)

                return true
            end
        end
    end

    ProfessionKeysLogger.log("No rooms found for " .. buildingType)

    return false
end

function ProfessionKeysShared.isCharacterOfProfession(character, profession)
    local prof = character:getDescriptor():getProfession()

    return prof and prof == profession
end
