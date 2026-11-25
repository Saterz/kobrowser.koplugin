local UIManager = require("ui/uimanager")
local Button = require("ui/widget/button")
local FocusManager = require("ui/widget/focusmanager")
local FrameContainer = require("ui/widget/container/framecontainer")
local VerticalGroup = require("ui/widget/verticalgroup")
local Blitbuffer = require("ffi/blitbuffer")
local HorizontalGroup = require("ui/widget/horizontalgroup")
local InputText = require("ui/widget/inputtext")
local Size = require("ui/size")
local Device = require("device")
local _ = require("gettext")
local Screen = Device.screen

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

    local close = Button:new {
        text = _("Close"),
        show_parent = self,
        callback = function() self:onClose() end,
    }

    self.address = InputText:new {
        parent = self,
        text = "",
        hint = _("Enter URL"),
        width = w - close:getSize().w - 2 * (padding + border),
        padding = padding,
        bordersize = border,
        margin = 0,
        focused = false,
        enter_callback = function() self:onSubmitAddress() end
    }

    local navbar = HorizontalGroup:new { self.address, close }

    self.layout = { { self.address, close } }

    self[1] = FrameContainer:new {
        width = w,
        height = h,
        background = Blitbuffer.COLOR_WHITE,
        bordersize = 0,
        padding = 0,
        VerticalGroup:new {
            align = "left",
            navbar,
        },
    }
end

function Browser:onSubmitAddress()
    local url = self.address:getText():match("^%s*(.-)%s*$")
    if url == "" then return end

    self.url = url
    self.address:onCloseKeyboard()
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
    self.address:onCloseKeyboard()
    UIManager:close(self, "ui")
    return true
end

return Browser
