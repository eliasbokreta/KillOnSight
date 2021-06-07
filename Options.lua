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
            delete = {
                type = 'input',
                name = 'deleteKoS',
                desc = 'Remove an enemy from your KoS',
                func = 'DeleteEnemy',
                guiHidden = true,
                set = function(_, val) KillOnSight:DeleteEnemy(val) end,
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
                    GeneralDescription = {
                        type = "description",
                        name = "Customize general KoS preferences"
                    },
                    KoS = {
                        type = "group",
                        name = "KoS",
                        args = {
                            KoSDescription = {
                                type = "description",
                                name = "Customize your KoS settings"
                            },
                            enableOnAllies = {
                                type = 'toggle',
                                name = 'Enable KoS on allies',
                                desc = 'Enable KoS on allies (For debug mostly)',
                                get = function() return self.db.profile.settings.enableOnAllies end,
                                set = function(_, val) self.db.profile.settings.enableOnAllies = val end,
                            },
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
                        }
                    },
                    Alerts = {
                        type = "group",
                        name = "Alerts",
                        args = {
                            AlertsDescription = {
                                type = "description",
                                name = "Customize your alerts settings"
                            },
                            alertMinTimer = {
                                type = 'range',
                                name = 'Alert timer',
                                desc = 'Time in seconds between two alerts for a same player',
                                min = 10,
                                max = 120,
                                step = 10,
                                get = function() return self.db.profile.settings.alertMinTimer end,
                                set = function(_, val) self.db.profile.settings.alertMinTimer = val end,
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
                            enableAlertOnNameplateRegistered = {
                                type = 'toggle',
                                name = 'Enable alerts on nameplate appearance',
                                desc = 'Enable alerts on nameplate appearance',
                                get = function() return self.db.profile.settings.enableAlertOnNameplateRegistered end,
                                set = function(_, val) self.db.profile.settings.enableAlertOnNameplateRegistered = val end,
                            },
                            enableAlertOnMouseOver = {
                                type = 'toggle',
                                name = 'Enable alerts on mouseover',
                                desc = 'Enable alerts on mouseover',
                                get = function() return self.db.profile.settings.enableAlertOnMouseOver end,
                                set = function(_, val) self.db.profile.settings.enableAlertOnMouseOver = val end,
                            },
                            enableAlertOnTarget = {
                                type = 'toggle',
                                name = 'Enable alerts on targeting',
                                desc = 'Enable alerts on targeting',
                                get = function() return self.db.profile.settings.enableAlertOnTarget end,
                                set = function(_, val) self.db.profile.settings.enableAlertOnTarget = val end,
                            },
                        }
                    }
                }
            },
            Profiles = {
                type = "group",
                name = "Profile",
                cmdHidden = true,
                args = {
                    ProfilesDescription = {
                        type = "description",
                        name = "Import / Export / Reset the database"
                    },
                    exportImportData = {
                        order = 0,
                        type = 'input',
                        name = 'Export/Import Data',
                        desc = 'Export or import KoS list',
                        get = function() return KillOnSight:GetExportString() end,
                        set = function(_, val) KillOnSight:SetExportString(val) end,
                    },
                    delete = {
                        order = 1,
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
    AceConfigDialog:AddToBlizOptions(addonName, addonName)
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