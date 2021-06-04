local addonName = "KillOnSight"
KillOnSight = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")

function KillOnSight:OnInitialize()
    local defaults = {
        profile = {
            players = {},
        }
    }
    local globalProfile = true
    self.db = LibStub("AceDB-3.0"):New(addonName, defaults, globalProfile)
    KillOnSight:InitGUI()
end

function KillOnSight:AddEnemy()
    local playerFaction = UnitFactionGroup("player")
    local zoneName = GetZoneText()
    local targetName = UnitName("target")

    if targetName then
        local targetGUID = UnitGUID("target")
        local targetFaction = UnitFactionGroup("target")
        local targetLevel = UnitLevel("target")
        local targetClass = UnitClass("target")

        if (UnitIsPlayer("target")) then
            if playerFaction ~= targetFaction then
                -- TODO CALL KOS ADD ENTRY FUNC
            else
                KillOnSight:Print("Your target is from your faction !")
            end
        else
            KillOnSight:Print("Your target is not a player !")
        end
        KillOnSight:InsertTable(targetName, targetLevel, targetClass, zoneName) 
    end
end

function KillOnSight:InsertTable(targetName, targetLevel, targetClass, zoneName)
    local count = #self.db.profile.players
    local enemy = {
        ['id'] = count,
        ['name'] = targetName,
        ['level'] = targetLevel,
        ['class'] = targetClass,
        ['zone'] = zoneName,
        ['date'] = date("%m/%d/%y %H:%M"),
    }
    local alreadyExists = false
    for i,v in ipairs(self.db.profile.players) do
        if targetName == v.name then
            alreadyExists = true
        end
    end
    if alreadyExists == false then
        table.insert(self.db.profile.players, enemy)
        KillOnSight:AddToKosList(enemy)
    else
        KillOnSight:Print("Your target is already on your KoS list !")
    end
end