local addonName = "KillOnSight"
local KillOnSight = LibStub("AceAddon-3.0"):GetAddon(addonName)
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function KillOnSight:RegisterOptionsTable()
    local options = {
        name = addonName,
        handler = KillOnSight,
        type = 'group',
        args = {
            add = {
                type = 'execute',
                name = 'addTarget',
                desc = 'Add current target to KoS',
                func = 'AddEnemy',
                guiHidden = true
            },
            menu = {
                type = 'execute',
                name = 'toggleGUI',
                desc = 'Display/hide KoS main menu',
                func = 'ToggleGUI',
                guiHidden = true
            },
            settings = {
                type = 'execute',
                name = 'openAddonMenu',
                desc = 'Open interface addon settings',
                func = 'OpenAddonMenu',
                guiHidden = true
            },
            General = {
                type = "group",
                name = "General",
                cmdHidden = true,
                args = {
                    enableInBG = {
                        type = 'toggle',
                        name = 'Enable in BGs',
                        desc = 'Enable KOS in battlegrounds',
                        get = function() return self.db.profile.settings.enableInBG end,
                        set = function(_, val) self.db.profile.settings.enableInBG = val end,
                    },
                    enableInArena = {
                        type = 'toggle',
                        name = 'Enable in arenas',
                        desc = 'Enable KOS in arenas',
                        get = function() return self.db.profile.settings.enableInArena end,
                        set = function(_, val) self.db.profile.settings.enableInArena = val end,
                    },
                    enableAlertSound = {
                        type = 'toggle',
                        name = 'Enable sound alerts',
                        desc = 'Enable KOS sound alerts',
                        get = function() return self.db.profile.settings.enableAlertSound end,
                        set = function(_, val) self.db.profile.settings.enableAlertSound = val end,
                    },
                    enableAlertText = {
                        type = 'toggle',
                        name = 'Enable text alerts',
                        desc = 'Enable KOS text alerts',
                        get = function() return self.db.profile.settings.enableAlertText end,
                        set = function(_, val) self.db.profile.settings.enableAlertText = val end,
                    },
                    exportImportData = {
                        type = 'input',
                        name = 'Export/Import Data',
                        desc = 'Export or import KoS list',
                        get = function()
                                return KillOnSight:GetExportString()
                            end,
                        set = function(_, val)
                                KillOnSight:SetExportString(val)
                            end,
                    },
                    delete = {
                        type = 'execute',
                        name = 'Reset Database',
                        desc = 'Delete Database',
                        func = 'PurgeData',
                    }
                }
            }
        },
    }

    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options, {"killonsight", "kos", "ko", "k"})
    AceConfigDialog:AddToBlizOptions(addonName, nil, nil, "General")
end

function KillOnSight:OpenAddonMenu()
    InterfaceOptionsFrame_Show()
    InterfaceOptionsFrame_OpenToCategory(addonName)
end

function KillOnSight:SetExportString(string)
    string = KillOnSight:FromBase64(string)
    self.db.char.kos = KillOnSight:stringToTable(string)
    KillOnSight:RefreshKosList()
end

function KillOnSight:GetExportString()
    return KillOnSight:ToBase64(KillOnSight:tableToString(self.db.char.kos))
end