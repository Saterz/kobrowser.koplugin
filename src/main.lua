--[[
This is a KOReader template plugin.

@module koplugin.Kobrowser
]]

local Dispatcher = require("dispatcher")
local InfoMessage = require("ui/widget/infomessage")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local _ = require("gettext")

local Kobrowser = WidgetContainer:extend {
    name = "kobrowser",
    is_doc_only = false,
}

function Kobrowser:onDispatcherRegisterActions()
    Dispatcher:registerAction("kobrowser_action",
        { category = "none", event = "Kobrowser", title = _("Kobrowser"), general = true, })
end

function Kobrowser:init()
    self:onDispatcherRegisterActions()
    self.ui.menu:registerToMainMenu(self)
end

function Kobrowser:addToMainMenu(menu_items)
    menu_items["kobrowser"] = {
        text = _("Kobrowser"),
        -- in which menu this should be appended
        sorting_hint = "more_tools",
        -- a callback when tapping
        callback = function()
            UIManager:show(InfoMessage:new {
                text = _("Hello from Kobrowser"),
            })
        end,
    }
end

function Kobrowser:onKobrowser()
    local popup = InfoMessage:new {
        text = _("Kobrowser"),
    }
    UIManager:show(popup)
end

-- KOReader will call this function when users choose to delete the plugin's settings.
function Kobrowser:deletePluginSettings()
    return true
end

return Kobrowser
