local Button = require("ui/widget/button")
local Screen = require("device").screen
local Icons = require("ui/kb_icons")

local ToolbarButton = Button:extend {
    icon = "close", -- Built-in placeholder used while Button builds its layout.
    icon_width = Screen:scaleBySize(22),
    icon_height = Screen:scaleBySize(22),
    bordersize = 0,
}

function ToolbarButton:init()
    Button.init(self)

    local image = Icons:new(self.svg, self.icon_width)
    image.dim = not self.enabled
    self.label_widget:free()
    self.label_widget = image
    self.label_container[1] = image
end

return ToolbarButton
