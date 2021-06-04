local addonName = "KillOnSight"
local KillOnSight = LibStub("AceAddon-3.0"):GetAddon(addonName)

local options = {
    name = addonName,
    handler = KillOnSight,
    type = 'group',
    args = {
        show = {
            type = 'execute',
            name = 'showGUI',
            desc = 'Display KoS menu window',
            func = 'InitGUI',
            guiHidden = true
        },
        hide = {
            type = 'execute',
            name = 'hideGUI',
            desc = 'Hide KoS menu window',
            func = 'HideGUI',
            guiHidden = true
        },
        add = {
            type = 'execute',
            name = 'addTarget',
            desc = 'Add current target to KoS',
            func = 'AddEnemy',
            guiHidden = true
        },
        menu = {
            type = 'execute',
            name = 'openAddonMenu',
            desc = 'Open interface menu',
            func = 'OpenAddonMenu',
            guiHidden = true
        },
        General = {
            type = "group",
            name = "general",
            cmdHidden = true,
            args = {
                delete = {
                    type = 'execute',
                    name = 'Reset DB',
                    desc = 'Delete Database',
                    func = 'InitGUI',
                }
            }
        }
    },
}


function KillOnSight:OpenAddonMenu()
    InterfaceOptionsFrame_Show()
    InterfaceOptionsFrame_OpenToCategory(addonName)
end

LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options, {"killonsight", "kos", "ko", "k"})

local AceConfigDialog = LibStub("AceConfigDialog-3.0")

AceConfigDialog:AddToBlizOptions(addonName, nil, nil, "General")