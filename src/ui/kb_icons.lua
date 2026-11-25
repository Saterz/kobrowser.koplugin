local IconWidget = require("ui/widget/iconwidget")
local Screen = require("device").screen

local _PluginRoot = require("common/kb_plugin_root")

local Icons = {}
Icons._index = Icons

Icons.icon_dir = _PluginRoot .. "/icons/"

function Icons:new(name, size)
    return IconWidget:new{
        file = self.icon_dir .. name .. ".svg",
        width = size,
        height = size,
        alpha = true,
    }
end

return Icons
