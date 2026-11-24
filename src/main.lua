--[[
This is a KOReader template plugin.

@module koplugin.Kobrowser
]]

local Dispatcher = require("dispatcher")
local InfoMessage = require("ui/widget/infomessage")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local _ = require("gettext")

local KOBrowser = WidgetContainer:extend {
    name = "KOBrowser",
    is_doc_only = false,
}

function KOBrowser:onDispatcherRegisterActions()
    Dispatcher:registerAction("KOBrowser_action",
        { category = "none", event = "KOBrowser", title = _("KOBrowser"), general = true, })
end

function KOBrowser:init()
    self:onDispatcherRegisterActions()
    self.ui.menu:registerToMainMenu(self)
end

function KOBrowser:addToMainMenu(menu_items)
    menu_items["kobrowser"] = {
        text = _("KOBrowser"),
        -- in which menu this should be appended
        sorting_hint = "more_tools",
        -- a callback when tapping
        callback = function()
            UIManager:show(InfoMessage:new {
                text = _("Hello from KOBrowser"),
            })
        end,
    }
end

function KOBrowser:onKOBrowser()
    local popup = InfoMessage:new {
        text = _("KOBrowser"),
    }
    UIManager:show(popup)
end

-- KOReader will call this function when users choose to delete the plugin's settings.
function KOBrowser:deletePluginSettings()
    return true
end

return KOBrowser
