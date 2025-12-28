ProfessionKeysLogger = ProfessionKeysLogger or {}

function ProfessionKeysLogger.log(message)
    if isDebugEnabled then
        print("[ProfessionKeys] " .. message)
    end
end
