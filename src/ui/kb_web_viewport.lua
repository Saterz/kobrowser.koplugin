local ffi = require("ffi")
local BlitBuffer = require("ffi/blitbuffer")
local Geom = require("ui/geometry")
local UIManager = require("ui/uimanager")
local Widget = require("ui/widget/widget")

local WebViewport = Widget:extend {}

function WebViewport:init()
    self.dimen = Geom:new { w = self.width, h = self.height }
    self.frame = BlitBuffer.new(self.width, self.height, BlitBuffer.TYPE_BBRGB32)
    self.frame:fill(BlitBuffer.COLOR_WHITE)
end

function WebViewport:paintTo(bb, x, y)
    self.dimen.x, self.dimen.y = x, y
    bb:blitFrom(self.frame, x, y, 0, 0, self.width, self.height)
end

function WebViewport:setFrame(rgba)
    assert(#rgba == self.width * self.height * 4, "Unexpected RGBA frame size")
    ffi.copy(self.frame.data, rgba, #rgba)
    UIManager:setDirty(self.show_parent, "ui", self.dimen)
end

function WebViewport:free()
	if self.frame then
        self.frame:free()
		self.frame = nil
	end
end

return WebViewport
