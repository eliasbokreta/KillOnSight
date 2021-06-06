local addonName = "KillOnSight"
local KillOnSight = LibStub("AceAddon-3.0"):GetAddon(addonName)

KillOnSightListStructure = {
    {
        ["name"] = "Name",
        ["width"] = 150,
        ["align"] = "CENTER",
        ["comparesort"] = function (self, rowa, rowb, sortbycol) return KillOnSight:Sort(self, rowa, rowb, sortbycol, 1) end,
        ["color"] = { 
            ["r"] = 255.0, 
            ["g"] = 255.0, 
            ["b"] = 255.0, 
            ["a"] = 1.0 
        },
        ["bgcolor"] = {
            ["r"] = 0.0, 
            ["g"] = 0.0, 
            ["b"] = 255.0, 
            ["a"] = 0.1
        }
    },
    {
        ["name"] = "Level",
        ["width"] = 50,
        ["align"] = "CENTER",
        ["comparesort"] = function (self, rowa, rowb, sortbycol) return KillOnSight:Sort(self, rowa, rowb, sortbycol, 2) end,
        ["color"] = { 
            ["r"] = 255.0, 
            ["g"] = 255.0, 
            ["b"] = 255.0, 
            ["a"] = 1.0 
        },
        ["bgcolor"] = {
            ["r"] = 0.0, 
            ["g"] = 0.0, 
            ["b"] = 255.0, 
            ["a"] = 0.0
        }
    },
    {
        ["name"] = "Class",
        ["width"] = 150,
        ["align"] = "CENTER",
        ["comparesort"] = function (self, rowa, rowb, sortbycol) return KillOnSight:Sort(self, rowa, rowb, sortbycol, 3) end,
        ["color"] = { 
            ["r"] = 255.0, 
            ["g"] = 255.0, 
            ["b"] = 255.0, 
            ["a"] = 1.0 
        },
        ["bgcolor"] = {
            ["r"] = 0.0, 
            ["g"] = 0.0, 
            ["b"] = 255.0, 
            ["a"] = 0.1
        }
    },
    {
        ["name"] = "Zone",
        ["width"] = 150,
        ["align"] = "CENTER",
        ["comparesort"] = function (self, rowa, rowb, sortbycol) return KillOnSight:Sort(self, rowa, rowb, sortbycol, 4) end,
        ["color"] = { 
            ["r"] = 255.0, 
            ["g"] = 255.0, 
            ["b"] = 255.0, 
            ["a"] = 1.0 
        },
        ["bgcolor"] = {
            ["r"] = 0.0, 
            ["g"] = 0.0, 
            ["b"] = 255.0, 
            ["a"] = 0.0
        }
    },
    {
        ["name"] = "Date",
        ["width"] = 150,
        ["align"] = "CENTER",
        ["comparesort"] = function (self, rowa, rowb, sortbycol) return KillOnSight:Sort(self, rowa, rowb, sortbycol, 5) end,
        ["color"] = { 
            ["r"] = 255.0, 
            ["g"] = 255.0, 
            ["b"] = 255.0, 
            ["a"] = 1.0 
        },
        ["bgcolor"] = {
            ["r"] = 0.0, 
            ["g"] = 0.0, 
            ["b"] = 255.0, 
            ["a"] = 0.1
        }
    },
}