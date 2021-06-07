local addonName = "KillOnSight"
local KillOnSight = LibStub("AceAddon-3.0"):GetAddon(addonName)
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

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
                                order = 0,
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
                                order = 0,
                                type = "description",
                                name = "Customize your alerts settings"
                            },
                            alertMinTimer = {
                                order = 2,
                                type = 'range',
                                name = 'Alert timer',
                                desc = 'Time in seconds between two alerts for a same player',
                                min = 10,
                                max = 120,
                                step = 10,
                                get = function() return self.db.profile.settings.alertMinTimer end,
                                set = function(_, val) self.db.profile.settings.alertMinTimer = val end,
                            },
                            AlertTypesHeader = {
                                order = 3,
                                type = "header",
                                name = "Alert types"
                            },
                            enableAlertSound = {
                                order = 4,
                                type = 'toggle',
                                name = 'Enable sound alerts',
                                desc = 'Enable KOS sound alerts',
                                get = function() return self.db.profile.settings.enableAlertSound end,
                                set = function(_, val) self.db.profile.settings.enableAlertSound = val end,
                            },
                            enableAlertText = {
                                order = 5,
                                type = 'toggle',
                                name = 'Enable text alerts',
                                desc = 'Enable KOS text alerts',
                                get = function() return self.db.profile.settings.enableAlertText end,
                                set = function(_, val) self.db.profile.settings.enableAlertText = val end,
                            },
                            AlertEventsHeader = {
                                order = 6,
                                type = "header",
                                name = "Alert events"
                            },
                            enableAlertOnNameplateRegistered = {
                                order = 7,
                                type = 'toggle',
                                name = 'Enable alerts on nameplate appearance',
                                desc = 'Enable alerts on nameplate appearance',
                                get = function() return self.db.profile.settings.enableAlertOnNameplateRegistered end,
                                set = function(_, val) self.db.profile.settings.enableAlertOnNameplateRegistered = val end,
                            },
                            enableAlertOnMouseOver = {
                                order = 8,
                                type = 'toggle',
                                name = 'Enable alerts on mouseover',
                                desc = 'Enable alerts on mouseover',
                                get = function() return self.db.profile.settings.enableAlertOnMouseOver end,
                                set = function(_, val) self.db.profile.settings.enableAlertOnMouseOver = val end,
                            },
                            enableAlertOnTarget = {
                                order = 9,
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
                name = "Profiles",
                cmdHidden = true,
                args = {
                    ProfilesDescription = {
                            type = "description",
                            name = "Profile settings"
                        },
                    KillOnSightList = {
                        type = "group",
                        name = "KoS list",
                        args = {
                            KillOnSightListDescription = {
                                order = 0,
                                type = "description",
                                name = "Handle your KoS list data"
                            },
                            exportImportDataHeader = {
                                order = 1,
                                type = "header",
                                name = "Import / Export data"
                            },
                            exportOverrideData = {
                                order = 3,
                                type = 'input',
                                name = 'Export/override KoS data',
                                desc = 'Export or override your KoS list data',
                                multiline = true,
                                get = function() return KillOnSight:GetExportString() end,
                                set = function(_, val) KillOnSight:SetExportString(val) end,
                            },
                            AppendData = {
                                order = 4,
                                type = 'input',
                                name = 'Append KoS data',
                                desc = 'Append data to your KoS list data',
                                multiline = true,
                                get = function() return "" end,
                                set = function(_, val) KillOnSight:AppendKoSList(val) end,
                            },
                        }
                    },
                    Profiles = AceDBOptions:GetOptionsTable(self.db)
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
    local string = KillOnSight:FromBase64(string)
    local newTable = KillOnSight:stringToTable(string)
    if newTable then
        self.db.char.kos = newTable
        KillOnSight:RefreshKosList()
    else
        KillOnSight:Print(string.format("|cffff0000%s|r", "The string you've entered is malformed !"))
    end
end

function KillOnSight:GetExportString()
    return KillOnSight:ToBase64(KillOnSight:tableToString(self.db.char.kos))
end

function KillOnSight:AppendKoSList(string)
    local string = KillOnSight:FromBase64(string)
    local newTable = KillOnSight:stringToTable(string)

    for iTable, vTable in ipairs(newTable) do
        local alreadyExists = false
        for iDB, vDB in ipairs(self.db.char.kos) do
            if vTable.name == vDB.name then
                alreadyExists = true
            end
        end
        if alreadyExists == true then
            KillOnSight:Print(string.format("|cffff0000'%s' %s|r", vTable.name, "is already on your KoS list !"))
        else
            table.insert(self.db.char.kos, vTable)
            KillOnSight:Print(string.format("'%s' has been successfully added to your KoS list !", vTable.name))
        end
    end
    KillOnSight:RefreshKosList()
end