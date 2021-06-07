local addonName = "KillOnSight"
local KillOnSight = LibStub("AceAddon-3.0"):GetAddon(addonName)

local AceGUI = LibStub("AceGUI-3.0")
local LibST = LibStub("ScrollingTable")

local winWidth = 750
local winHeight = 450

local frame, tabGroup, alertFrame, scrollingTableFrame, historyLogsScrollingTableFrame

function KillOnSight:InitGUI()
    frame = AceGUI:Create("Frame")
    frame:SetTitle("Kill On Sight")
    frame:SetWidth(winWidth)
    frame:SetHeight(winHeight)
    frame:EnableResize(false)
    frame:SetCallback("OnClose", ToggleGUI)
    frame:SetLayout("Fill")

    tabGroup = AceGUI:Create("TabGroup")
    tabGroup:SetLayout("Flow")
    tabGroup:SetTabs({{text="KoS List", value="1"}, {text="K/D History", value="2"}})
    tabGroup:SetCallback("OnGroupSelected", SelectGroup)
    frame:AddChild(tabGroup)

    scrollingTableFrame = LibST:CreateST(KillOnSightListStructure, 14, nil, nil, tabGroup.frame)
    scrollingTableFrame.frame:ClearAllPoints()
    scrollingTableFrame.frame:SetPoint("TOP", frame.frame, "TOP", 0, -170)
    scrollingTableFrame.head:SetHeight(30)

    historyLogsScrollingTableFrame = LibST:CreateST(HistoryLogsStructure, 14, nil, nil, tabGroup.frame)
    historyLogsScrollingTableFrame.frame:ClearAllPoints()
    historyLogsScrollingTableFrame.frame:SetPoint("TOP", frame.frame, "TOP", 0, -170)
    historyLogsScrollingTableFrame.head:SetHeight(30)

    tabGroup:SelectTab("1")
    KillOnSight:InitAlertFrame()
end

function KillOnSight:InitKillOnSightListTab()
    local buttonGroup = AceGUI:Create("SimpleGroup")
    buttonGroup:SetLayout("Flow")
    buttonGroup:SetFullWidth(true)
    tabGroup:AddChild(buttonGroup)

    local button = AceGUI:Create("Button")
    button:SetText("Add Target")
    button:SetWidth(100)
    button:SetCallback("OnClick", function() KillOnSight:AddEnemy() end)
    buttonGroup:AddChild(button)

    local button = AceGUI:Create("Button")
    button:SetText("Delete Target")
    button:SetWidth(120)
    button:SetCallback("OnClick", function() KillOnSight:DeleteEnemy(UnitName("target")) end)
    buttonGroup:AddChild(button)

    local button = AceGUI:Create("Button")
    button:SetText("Delete All")
    button:SetWidth(100)
    button:SetCallback("OnClick", function() KillOnSight:PurgeData() end)
    buttonGroup:AddChild(button)

    local filterName = AceGUI:Create("EditBox")
    filterName:SetLabel("Filter by name")
    filterName:SetWidth(100)
    filterName:DisableButton(true)
    filterName:SetCallback("OnTextChanged", function(self) KillOnSight:RefreshKosList(filterName:GetText()) end)
    buttonGroup:AddChild(filterName)

    local heading = AceGUI:Create("Heading")
    heading:SetRelativeWidth(1)
    buttonGroup:AddChild(heading)
end

function KillOnSight:InitHistoryLogsTab()
    local buttonGroup = AceGUI:Create("SimpleGroup")
    buttonGroup:SetLayout("Flow")
    buttonGroup:SetFullWidth(true)
    tabGroup:AddChild(buttonGroup)

    local button = AceGUI:Create("Button")
    button:SetText("Delete all")
    button:SetWidth(100)
    button:SetCallback("OnClick", function() KillOnSight:ResetHistoryLogs() end)
    buttonGroup:AddChild(button)

    local heading = AceGUI:Create("Heading")
    heading:SetRelativeWidth(1)
    buttonGroup:AddChild(heading)
end

function DrawKillOnSightListTab(container)
    KillOnSight:InitKillOnSightListTab()
    KillOnSight:RefreshKosList()
    historyLogsScrollingTableFrame:Hide()
    scrollingTableFrame:Show()
end
  
function DrawKillDeathStatsTab(container)
    KillOnSight:InitHistoryLogsTab()
    KillOnSight:RefreshHistoryLogs()
    scrollingTableFrame:Hide()
    historyLogsScrollingTableFrame:Show()
end
  
function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "1" then
        DrawKillOnSightListTab(container)
    elseif group == "2" then
        DrawKillDeathStatsTab(container)
    end
end

function KillOnSight:InitAlertFrame()
    alertFrame = CreateFrame("ScrollingMessageFrame", UIParent)
    alertFrame:SetPoint("TOP")
    alertFrame:SetSize(300, 50)
    alertFrame:SetTimeVisible(0.8)
    alertFrame:SetFadeDuration(0.4)
    alertFrame:SetFont("Fonts\\FRIZQT__.TTF", 15)
    alertFrame:SetInsertMode("TOP")
    alertFrame:SetMaxLines(2)
end

function KillOnSight:RefreshKosList(filter)
    local data = {
        cols = {}
    }
    for k, v in pairs(self.db.char.kos) do
        local player = {
            ["cols"] = {
                {
                    ["value"] = v["name"],
                },
                {
                    ["value"] = v["level"],
                },
                {
                    ["value"] = v["class"],
                },
                {
                    ["value"] = v["zone"],
                },
                {
                    ["value"] = date("%m/%d/%y %H:%M:%S", v["date"]),
                },
                {
                    ["value"] = date("%m/%d/%y %H:%M:%S", v["lastUpdated"]),
                },
                --[[
                    ["value"] = v["guild"] == nil and "Unknown" or v["guild"],
                },]]--
            }
        }
        if filter ~= nil and filter ~= "" then
            if string.find(v.name:lower(), filter:lower()) then
                data[#data+1] = player
            end
        else
            data[#data+1] = player
        end
    end
    scrollingTableFrame:SetData(data, false)
end

function KillOnSight:RefreshHistoryLogs()
    local data = {
        cols = {}
    }
    for k, v in pairs(self.db.char.history) do
        local pvpLog = {
            ["cols"] = {
                {
                    ["value"] = v["name"],
                },
                {
                    ["value"] = v["win"],
                },
                {
                    ["value"] = v["lose"],
                },
            }
        }
        data[#data+1] = pvpLog
    end
    historyLogsScrollingTableFrame:SetData(data, false)
end

function KillOnSight:EnemyFoundMessage(enemyName)
    alertFrame:AddMessage("KILL ON SIGHT : " .. enemyName, 1.0, 0.0, 0.0)
end

function KillOnSight:ToggleGUI()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end
