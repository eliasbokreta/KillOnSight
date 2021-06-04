local addonName = "KillOnSight"
KillOnSight = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local defaultProfile = {
    profile = {
        players = {},
        settings = {
            enableInBG = false,
            enableInArena = false,
            enableAlertSound = true,
            enableAlertText = true,
        }
    }
}

function KillOnSight:OnInitialize()
    local globalProfile = true
    self.db = LibStub("AceDB-3.0"):New("kosDB", defaultProfile, globalProfile)
    KillOnSight:RegisterOptionsTable()
    KillOnSight:InitGUI()
end

function KillOnSight:OnEnable()
    KillOnSight:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function KillOnSight:PLAYER_TARGET_CHANGED()
    local currentZone = GetRealZoneText()
    
    if self.db.profile.settings.enableInBG == false then
        if currentZone == L["Warsong Gulch"] or currentZone == L["Arathi Basin"] or currentZone == L["Alterac Valley"] or currentZone == L["Eye of the Storm"] then
            return
        end
    end

    if self.db.profile.settings.enableInArena == false then
        if currentZone == L["Nagrand Arena"] or currentZone == L["Ruins of Lordaeron"] or currentZone == L["Dalaran Arena"] or currentZone == L["The Ring of Valor"] then
            return
        end
    end

    for i,v in ipairs(self.db.profile.players) do
        if UnitName("target") == v.name then
            if self.db.profile.settings.enableAlertSound then
                PlaySound(8959)
            end
            if self.db.profile.settings.enableAlertText then
                KillOnSight:EnemyFoundCreateFrame(v.name)
            end
        end
    end
end

function KillOnSight:AddEnemy()
    local playerFaction = UnitFactionGroup("player")
    local zoneName = GetRealZoneText()
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
    local enemy = {
        ['id'] = #self.db.profile.players,
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

function KillOnSight:PurgeData()
    self.db.profile.players = {players = {}}
    KillOnSight:ResetGUI()
end