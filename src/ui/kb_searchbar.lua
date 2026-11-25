local FrameContainer = require("ui/widget/container/framecontainer")
local InputText = require("ui/widget/inputtext")
local HorizontalGroup = require("ui/widget/horizontalgroup")
local HorizontalSpan = require("ui/widget/horizontalspan")
local Font = require("ui/font")
local IconWidget = require("ui/widget/iconwidget")
local BlitBuffer = require("ffi/blitbuffer")
local Device = require("device")
local Screen = Device.screen

local SearchBar = FrameContainer:extend {
    width = Screen:scaleBySize(300),
    placeholder = "Search or enter URL",
    text = "",
    parent = nil,
    callback = nil,
}

function SearchBar:init()
    local padding = Screen:scaleBySize(10)
    local icon_size = Screen:scaleBySize(22)
    local spacing = Screen:scaleBySize(8)
    local border = Screen:scaleBySize(1)

    self.radius = Screen:scaleBySize(25)
    self.bordersize = border
    self.padding = padding
    self.margin = 0
    self.background = BlitBuffer.COLOR_WHITE

    self.input = InputText:new {
        parent = self.parent,

        text = self.text,
        hint = self.placeholder,

        width = self.width
            - 2 * padding
            - 2 * border
            - icon_size
            - spacing,

        height = Screen:scaleBySize(28),
        face = Font:getFace("cfont", 20),

        bordersize = 0,
        padding = 0,
        margin = 0,
        scroll = false,

        enter_callback = function()
            local query = self.input:getText()
            self.input:onCloseKeyboard()

            if self.callback then
                self.callback(query)
            end
        end,
    }

    self[1] = HorizontalGroup:new {
        align = "center",

        IconWidget:new {
            icon = "search",
            width = icon_size,
            height = icon_size,
        },

        HorizontalSpan:new {
            width = spacing,
        },

        self.input,
    }
end

function SearchBar:getText()
    return self.input:getText()
end

function SearchBar:setText(text)
    self.input:setText(text)
end

return SearchBar
