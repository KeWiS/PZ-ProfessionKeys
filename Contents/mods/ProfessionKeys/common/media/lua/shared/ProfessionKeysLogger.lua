ProfessionKeysLogger = ProfessionKeysLogger or {}

function ProfessionKeysLogger.logOnlyMessage(message)
    if isDebugEnabled then
        print("[ProfessionKeys] " .. message)
    end
end

function ProfessionKeysLogger.log(buildingType, message)
    if isDebugEnabled then
        print("[ProfessionKeys] " .. buildingType .. ": " .. message)
    end
end
