local addonName = "KillOnSight"
KillOnSight = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local LDBIcon = LibStub("LibDBIcon-1.0")

local defaultProfile = {
    profile = {
        players = {},
        settings = {
            enableInBG = false,
            enableInArena = false,
            enableAlertSound = true,
            enableAlertText = true,
            [[-- TODO
            enableAlertOnMouseOver = true,
            enableAlertOnTarget = true,
            enableAlertOnNameplateRegistered = true, NEEDED SHOW ENEMY NAMEPLATES
            enableOnAllies = false, TO DEBUG MOSTLY
            --]]
        },
        minimapButton = {
            hide = false,
        },
    }
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
    --KillOnSight:HideGUI()
end

function KillOnSight:OnEnable()
    KillOnSight:RegisterEvent("PLAYER_TARGET_CHANGED")
    KillOnSight:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    KillOnSight:RegisterEvent("NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_ADDED")
end

function KillOnSight:NAME_PLATE_UNIT_ADDED(event, nameplate)
    name = UnitName(nameplate)
    KillOnSight:AlertEvent(name)
end

function KillOnSight:PLAYER_TARGET_CHANGED()
    KillOnSight:AlertEvent(false)
end

function KillOnSight:UPDATE_MOUSEOVER_UNIT()
    KillOnSight:AlertEvent(false)
end

function KillOnSight:AlertEvent(name)
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

    for i,v in ipairs(self.db.profile.players) do
        if UnitName("target") == v.name or UnitName("mouseover") == v.name or name == v.name then
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
        KillOnSight:RefreshKosList()
    else
        KillOnSight:Print("Your target is already on your KoS list !")
    end
end

function KillOnSight:PurgeData()
    self.db.profile.players = {players = {}}
    KillOnSight:RefreshKosList()
end
