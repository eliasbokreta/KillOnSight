local addonName = "KillOnSight"
local KillOnSight = LibStub("AceAddon-3.0"):GetAddon(addonName)

local AceGUI = LibStub("AceGUI-3.0")

local winWidth = 650
local winHeight = 300

local frame, playerNameColumn, playerLevelColumn, playerClassColumn, zoneColumn, dateColumn, deleteColumn

function KillOnSight:InitGUI()
    frame = AceGUI:Create("Frame")
    frame:SetTitle("KoS")
    frame:SetStatusText("KoS list")
    frame:SetWidth(winWidth)
    frame:SetHeight(winHeight)
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("List")

    local button = AceGUI:Create("Button")
    button:SetText("Add Target")
    button:SetWidth(100)
    button:SetCallback("OnClick", function() KillOnSight:AddEnemy() end)
    frame:AddChild(button)

    local button = AceGUI:Create("Button")
    button:SetText("Delete All")
    button:SetWidth(100)
    button:SetCallback("OnClick", function() KillOnSight:Purge() end)
    frame:AddChild(button)

    local playerList = AceGUI:Create("SimpleGroup")
    playerList:SetFullWidth(true)
    playerList:SetFullHeight(true)
    playerList:SetLayout("Fill")
    frame:AddChild(playerList)

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    playerList:AddChild(scroll)

    playerNameColumn = AceGUI:Create("SimpleGroup")
    playerNameColumn:SetRelativeWidth(0.2)
    scroll:AddChild(playerNameColumn)
    
    local playerNameLabel = AceGUI:Create("Label")
    playerNameLabel:SetText("Name")
    playerNameLabel:SetFullWidth(true)
    playerNameLabel:SetJustifyH("CENTER")
    playerNameColumn:AddChild(playerNameLabel)

    playerLevelColumn = AceGUI:Create("SimpleGroup")
    playerLevelColumn:SetRelativeWidth(0.2)
    scroll:AddChild(playerLevelColumn)
    
    local playerLevelLabel = AceGUI:Create("Label")
    playerLevelLabel:SetText("Level")
    playerLevelLabel:SetFullWidth(true)
    playerLevelLabel:SetJustifyH("CENTER")
    playerLevelColumn:AddChild(playerLevelLabel)

    playerClassColumn = AceGUI:Create("SimpleGroup")
    playerClassColumn:SetRelativeWidth(0.15)
    scroll:AddChild(playerClassColumn)
    
    local playerClassLabel = AceGUI:Create("Label")
    playerClassLabel:SetText("Class")
    playerClassLabel:SetFullWidth(true)
    playerClassLabel:SetJustifyH("CENTER")
    playerClassColumn:AddChild(playerClassLabel)

    zoneColumn = AceGUI:Create("SimpleGroup")
    zoneColumn:SetRelativeWidth(0.2)
    scroll:AddChild(zoneColumn)
    
    local zoneLabel = AceGUI:Create("Label")
    zoneLabel:SetText("Zone")
    zoneLabel:SetFullWidth(true)
    zoneLabel:SetJustifyH("CENTER")
    zoneColumn:AddChild(zoneLabel)

    dateColumn = AceGUI:Create("SimpleGroup")
    dateColumn:SetRelativeWidth(0.2)
    scroll:AddChild(dateColumn)
    
    local dateLabel = AceGUI:Create("Label")
    dateLabel:SetText("Date")
    dateLabel:SetFullWidth(true)
    dateLabel:SetJustifyH("CENTER")
    dateColumn:AddChild(dateLabel)

    KillOnSight:RefreshKosList()
end

function KillOnSight:AddToKosList(enemy)
    local playerName = AceGUI:Create("Label")
    playerName:SetText(enemy['name'])
    playerName:SetFullWidth(true)
    playerName:SetJustifyH("CENTER")
    playerNameColumn:AddChild(playerName)

    local playerLevel = AceGUI:Create("Label")
    playerLevel:SetText(enemy['level'])
    playerLevel:SetFullWidth(true)
    playerLevel:SetJustifyH("CENTER")
    playerLevelColumn:AddChild(playerLevel)

    local playerClass = AceGUI:Create("Label")
    playerClass:SetText(enemy['class'])
    playerClass:SetFullWidth(true)
    playerClass:SetJustifyH("CENTER")
    playerClassColumn:AddChild(playerClass)

    local zone = AceGUI:Create("Label")
    zone:SetText(enemy['zone'])
    zone:SetFullWidth(true)
    zone:SetJustifyH("CENTER")
    zoneColumn:AddChild(zone)

    local dateValue = AceGUI:Create("Label")
    dateValue:SetText(enemy['date'])
    dateValue:SetFullWidth(true)
    dateValue:SetJustifyH("CENTER")
    dateColumn:AddChild(dateValue)
end

function KillOnSight:RefreshKosList()
    for i, value in ipairs(self.db.profile.players) do
        local playerName = AceGUI:Create("Label")
        playerName:SetText(value.name)
        playerName:SetFullWidth(true)
        playerName:SetJustifyH("CENTER")
        playerNameColumn:AddChild(playerName)

        local playerLevel = AceGUI:Create("Label")
        playerLevel:SetText(value.level)
        playerLevel:SetFullWidth(true)
        playerLevel:SetJustifyH("CENTER")
        playerLevelColumn:AddChild(playerLevel)

        local playerClass = AceGUI:Create("Label")
        playerClass:SetText(value.class)
        playerClass:SetFullWidth(true)
        playerClass:SetJustifyH("CENTER")
        playerClassColumn:AddChild(playerClass)

        local zone = AceGUI:Create("Label")
        zone:SetText(value.zone)
        zone:SetFullWidth(true)
        zone:SetJustifyH("CENTER")
        zoneColumn:AddChild(zone)
    
        local dateValue = AceGUI:Create("Label")
        dateValue:SetText(value.date)
        dateValue:SetFullWidth(true)
        dateValue:SetJustifyH("CENTER")
        dateColumn:AddChild(dateValue)

    end
end

function KillOnSight:HideGUI()
    frame:Hide()
end
