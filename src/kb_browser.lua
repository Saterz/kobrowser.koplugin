local UIManager = require("ui/uimanager")
local Button = require("ui/widget/button")
local FocusManager = require("ui/widget/focusmanager")
local FrameContainer = require("ui/widget/container/framecontainer")
local VerticalGroup = require("ui/widget/verticalgroup")
local BlitBuffer = require("ffi/blitbuffer")
local HorizontalGroup = require("ui/widget/horizontalgroup")
local Size = require("ui/size")
local Device = require("device")
local Screen = Device.screen
local _ = require("gettext")

local SearchBar = require("ui/kb_searchbar")
local ToolbarButton = require("ui/kb_toolbar_button")

local Browser = FocusManager:extend {
    covers_fullscreen = true
}

function Browser:init()
    self.dimen = Screen:getSize()
    local w, h = self.dimen.w, self.dimen.h

    if Device:hasKeys() then
        self.key_events.Close = { { Device.input.group.Back } }
    end

    local padding = Size.padding.default
    local border = Size.border.inputtext

    local back = ToolbarButton:new { svg = "arrow-left", show_parent = self, enabled = false }
    local forward = ToolbarButton:new { svg = "arrow-right", show_parent = self, enabled = false }
    local reload = ToolbarButton:new { svg = "rotate-cw", show_parent = self, enabled = false }
    local settings = ToolbarButton:new { svg = "settings", show_parent = self, enabled = false }
    local close = ToolbarButton:new {
        svg = "x",
        show_parent = self,
        callback = function() self:onClose() end,
    }

    self.address = SearchBar:new {
        parent = self,
        width = w - back:getSize().w - forward:getSize().w - reload:getSize().w - settings:getSize().w - close:getSize().w,

        callback = function(query)
            self:onSubmitAddress(query)
        end
    }

    local navbar = HorizontalGroup:new { back, forward, reload, self.address, settings, close }
    self.layout = { { back, forward, reload, self.address, settings, close } }


    self[1] = FrameContainer:new {
        width = w,
        height = h,
        background = BlitBuffer.COLOR_WHITE,
        bordersize = 0,
        padding = 0,
        VerticalGroup:new {
            align = "left",
            navbar,
        },
    }
end

---@param query string
function Browser:onSubmitAddress(query)
    local url = query:match("^%s*(.-)%s*$")
    if url == "" then return end

    self.url = url
    self:onKeyboardClosed()
end

function Browser:onKeyboardClosed()
    if Device:hasDPad() then
        self:moveFocusTo(2, 1)
    else
        self.address:unfocus()
    end
    UIManager:setDirty(self, "ui")
end

function Browser:onShow()
    if Device:hasDPad() then
        self:moveFocusTo(1, 1)
    end
end

function Browser:onClose()
    UIManager:close(self, "ui")
    return true
end

return Browser
