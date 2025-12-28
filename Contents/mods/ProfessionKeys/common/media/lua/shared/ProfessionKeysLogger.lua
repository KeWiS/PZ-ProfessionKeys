ProfessionKeysLogger = ProfessionKeysLogger or {}

function ProfessionKeysLogger.log(buildingType, message)
    if isDebugEnabled then
        print("[ProfessionKeys] " .. buildingType .. ": " .. message)
    end
end
