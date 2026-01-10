local function onPlayerUpdate(player)
    local playerProfession = player:getDescriptor():getProfession()
    local professionBuildingDef = ProfessionKeysLogic.getBuildingDefForProfession(playerProfession)
    if not professionBuildingDef then return end
    if ProfessionKeysLogic.keyAlreadyGenerated() then return end

    local building = player:getBuilding()
    if not building then return end
    if not ProfessionKeysLogic.isValidPlayer(player, professionBuildingDef.name) then return end

    local playerId = player:getOnlineID() or player:getPlayerNum()

    if ProfessionKeysLogic.checkBuildingCorrectness(building, playerId, professionBuildingDef) then
        ProfessionKeysLogic.createAndAssignBuildingKey(building, player, professionBuildingDef.name)
    end
end

Events.OnPlayerUpdate.Add(onPlayerUpdate)
