local addonName = "KillOnSight"
KillOnSight = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local LDBIcon = LibStub("LibDBIcon-1.0")

local eventFrame = CreateFrame("Frame")

local defaultProfile = {
    profile = {
        settings = {
            enableInBG = false,
            enableInArena = false,
            enableAlertSound = true,
            enableAlertText = true,

            enableAlertOnNameplateRegistered = true,
            enableAlertOnMouseOver = true,
            enableAlertOnTarget = true,
            enableOnAllies = false,
            alertMinTimer = 10,
        },
        minimapButton = {
            hide = false,
        },
    },
    char = {
        kos = {},
        history = {}
    },
}

function KillOnSight:OnInitialize()
    local globalProfile = true
    self.db = LibStub("AceDB-3.0"):New("kosDB", defaultProfile, globalProfile)
    KillOnSight:RegisterOptionsTable()
    KillOnSight:InitGUI()
    LDBIcon:Register(addonName, LibStub("LibDataBroker-1.1"):NewDataObject(addonName,
	{
		type = "data source",
		text = addonName,
        icon = "135271",
		OnClick = function(self, button)
			if (button == "LeftButton") then
                KillOnSight:ToggleGUI()
            elseif (button == "RightButton") then
                InterfaceOptionsFrame_Show()
                InterfaceOptionsFrame_OpenToCategory(addonName)
            elseif (button == "MiddleButton") then
                LDBIcon:Hide(addonName)
            end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(addonName)
			tooltip:AddLine(string.format("|cff888888%s|r |cffffffff%s|r", "Left Click :", "Open KoS main window"))
            tooltip:AddLine(string.format("|cff888888%s|r |cffffffff%s|r", "Middle Click :", "Hide KoS minimap icon"))
			tooltip:AddLine(string.format("|cff888888%s|r |cffffffff%s|r", "Right Click :", "Open addon interface window"))
		end
    }), self.db.profile.minimapButton)
    eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
end

function KillOnSight:OnEnable()

end

local function OnEvent(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        local nameplate = ...
        local name = UnitName(nameplate)
        KillOnSight:AlertEvent(name, "nameplate")
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        local name = UnitName("mouseover")
        KillOnSight:AlertEvent(name, "mouseover")
    elseif event == "PLAYER_TARGET_CHANGED" then
        local name = UnitName("target")
        KillOnSight:AlertEvent(name, "target")
    end
end

eventFrame:SetScript("OnEvent", OnEvent)

function KillOnSight:AlertEvent(name, type)
    if type == "nameplate" and self.db.profile.settings.enableAlertOnNameplateRegistered == false then
        return
    end
    if type == "mouseover" and self.db.profile.settings.enableAlertOnMouseOver == false then
        return
    end
    if type == "target" and self.db.profile.settings.enableAlertOnTarget == false then
        return
    end
    local currentZone = GetRealZoneText()

    if self.db.profile.settings.enableInArena == false then
        for arenaUS, arenaLocale in pairs(Arena_List) do
            if currentZone == arenaLocale then
                return
            end
        end
    end

    if self.db.profile.settings.enableInBG == false then
        for bgUS, bgLocale in pairs(BG_List) do
            if currentZone == bgLocale then
                return
            end
        end
    end

    for i,v in ipairs(self.db.char.kos) do
        if name == v.name then
            if (time() > (v.lastUpdated + self.db.profile.settings.alertMinTimer)) then
                KillOnSight:UpdateEnemy(v)
                if self.db.profile.settings.enableAlertSound then
                    PlaySound(8959)
                end
                if self.db.profile.settings.enableAlertText then
                    KillOnSight:EnemyFoundMessage(v.name)
                end
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

        if (not UnitIsPlayer("target")) then
            KillOnSight:Print(string.format("|cffff0000%s|r", "This target is not a player !"))
        else
            if self.db.profile.settings.enableOnAllies == false then
                if playerFaction ~= targetFaction then
                    KillOnSight:AddEnemyToKos(targetName, targetLevel, targetClass, zoneName) 
                else
                    KillOnSight:Print(string.format("|cffff0000%s|r", "This target is from your faction !"))
                end
            else
                KillOnSight:AddEnemyToKos(targetName, targetLevel, targetClass, zoneName) 
            end
        end
    end
end

function KillOnSight:UpdateEnemy(enemy)
    local zoneName = GetRealZoneText()
    enemy.zone = zoneName
    enemy.lastUpdated = time()
    KillOnSight:RefreshKosList()
end

function KillOnSight:DeleteEnemy(enemyName)
    if enemyName == "" then
        KillOnSight:Print(string.format("|cffff0000%s|r", "You need to type the enemy name !"))
        return
    end
    
    local foundIndex = -1
    for i,v in ipairs(self.db.char.kos) do
        if enemyName == v.name then
            foundIndex = i
            break
        end
    end

    if (foundIndex ~= -1) then
        table.remove(self.db.char.kos, foundIndex) 
        KillOnSight:Print(string.format("%s has been successfully removed from your KoS list !", enemyName))
    else
        KillOnSight:Print(string.format("|cffff0000'%s' %s|r", enemyName, "was not found in your list !"))
        return
    end
    KillOnSight:RefreshKosList()
end

function KillOnSight:AddEnemyToKos(targetName, targetLevel, targetClass, zoneName)
    local enemy = {
        ['name'] = targetName,
        ['level'] = targetLevel,
        ['class'] = targetClass,
        ['zone'] = zoneName,
        ['date'] = time(),
        ['lastUpdated'] = time(),
    }
    local alreadyExists = false
    for i,v in ipairs(self.db.char.kos) do
        if targetName == v.name then
            alreadyExists = true
        end
    end
    if alreadyExists == false then
        table.insert(self.db.char.kos, enemy)
        KillOnSight:RefreshKosList()
        KillOnSight:Print(string.format("'%s' has been successfully added to your KoS list !", targetName))
    else
        KillOnSight:Print(string.format("|cffff0000%s|r", "This target is already on your KoS list !"))
    end
end

function KillOnSight:PurgeData()
    self.db.char.kos = {}
    KillOnSight:RefreshKosList()
end
